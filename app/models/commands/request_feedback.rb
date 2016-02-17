module Commands
  class RequestFeedback < Base
    def response
      if grouping = Grouping.find_by(tag: text)
        # they sent a tag for a pre-existing grouping
        feedbacks_for_grouping(grouping)
      else
        # assume they are sending usernames e.g. "@j3 @horace @mike"
        feedbacks_for_usernames
      end
    end

    def feedbacks_for_grouping(grouping)
      feedbacks = grouping.groups.flat_map do |group|
        request_feedback(group)
      end
      "Created #{feedbacks.count} feedback requests"
    end

    def feedbacks_for_usernames
      feedbacks = request_feedback(user_names)
      "Created #{feedbacks.count} feedback requests"
    end

    def request_feedback(slack_names)
      group_members = User.where(slack_name: slack_names)
      feedbacks = cross_invite(group_members)
      feedbacks.each do |f|
        url = edit_feedback_url(f)
        msg = "Hi, #{f.sender.name}, you've been requested to leave feedback for #{f.receiver.name}. Please do so here #{url}"
        puts "trying to send info to #{f.sender.slack_id}"
        SlackMessageWorker.perform_async(f.sender.slack_id, msg)
      end
      feedbacks
    end

    def cross_invite(members)
      members.flat_map do |sender|
        (members - [sender]).map do |receiver|
          Feedback.create(sender: sender, receiver: receiver)
        end
      end
    end

    def user_names
      text.split.map { |n| n.sub("@", "") }
    end
  end
end
