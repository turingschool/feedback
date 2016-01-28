class FeedbacksController < ApplicationController
  def edit
    @fb = Feedback.find_by(token: params[:token])
  end

  def update
    fb = Feedback.find_by(token: params[:token])
    fb.text = params[:feedback][:text]
    fb.save
    b = Bot.new
    b.message_user(fb.receiver.slack_id, "Hi, #{fb.receiver.slack_name}, #{fb.sender.slack_name} sent you the following feedback: #{fb.text}")
    render text: "THANKS FOR SUBMITTING FEEDBACK"
  end
end
