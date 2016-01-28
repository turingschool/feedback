class SlackCommandsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_slack_token
  def create
    render text: slack_handler(params["text"])
  end

  def slack_handler(message)
    group_members = User.where(slack_name: user_names(message))
    feedbacks = cross_invite(group_members)
    sbot = Bot.new
    feedbacks.each do |f|
      url = "https://cc875ed1.ngrok.io" + feedback_path(token: f.token)
      msg = "Hi, #{f.sender.name}, you've been requested to leave feedback for #{f.receiver.name}. Please do so here #{url}"
      puts "trying to send info to #{f.sender.slack_id}"
      sbot.message_user(f.sender.slack_id, msg)
    end
    "Created #{feedbacks.count} feedback requests"
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
