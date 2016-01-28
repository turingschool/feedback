class SlackCommandsController < ApplicationController
  rescue_from Exception, with: :text_error_handler
  skip_before_action :verify_authenticity_token
  before_action :verify_slack_token

  def text_error_handler(error)
    render text: "Error: #{error.class} -- #{error.message}"
  end

  def create
    case params["command"]
    when "feedback"
      render text: feedback_handler(params["text"])
    when "pairs"
      render text: pairs_handler(params["text"])
    else
      "Sorry, command #{params["command"]} not known."
    end
  end

  # When pairs are generated, store a grouping record
  # assign group record a tag (hash? words?)
  # show message indicating you can request feedback for these
  # groups later using the tag

  def pairs_handler(usergroup)
    group = Slackk.user_group_by_handle(usergroup)
    if group
      members = Slackk.user_group_members(group["id"])
      header = "Pairs:"
      grouping = "* " + members.map do |uid|
         Slackk.member(uid)
      end.map do |member|
        member["name"]
      end.shuffle.each_slice(2).map do |pair|
        pair.join(", ")
      end.join("\n* ")

      g = Grouping.create(content: grouping)

      footer = "Stored this grouping as #{g.tag}. You can use this tag later to request feedback from these groups."
      [header, grouping, footer].join("\n")
    else
      gnames = Slackk.user_groups.map { |g| g["handle"] }.join(", ")
      "Sorry, #{usergroup} is not a known usergroup. Try one of #{gnames}."
    end
  end

  def feedback_handler(message)
    if grouping = Grouping.find_by(tag: message)
      feedbacks = grouping.groups.flat_map do |group|
        request_feedback(group)
      end
      "Created #{feedbacks.count} feedback requests"
    else
      # assume they are sending usernames e.g. "@j3 @horace @mike"
      feedbacks = request_feedback(user_names(message))
      "Created #{feedbacks.count} feedback requests"
    end
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

  def user_names(message)
    message.split.map { |n| n.sub("@", "") }
  end

  def verify_slack_token
    raise "invalid token" unless params["token"] == ENV["FEEDBACK_SLASH_COMMAND_TOKEN"]
  end
end
