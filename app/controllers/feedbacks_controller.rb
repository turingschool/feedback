class FeedbacksController < ApplicationController
  def edit
    @fb = Feedback.find_by(token: params[:token])
  end

  def update
    fb = Feedback.find_by(token: params[:token])
    fb.text = params[:feedback][:text]
    fb.save
    msg = "Hi, #{fb.receiver.slack_name}, #{fb.sender.slack_name} sent you the following feedback: #{fb.text}"
    SlackMessageWorker.perform_async(fb.receiver.slack_id, msg)
    render text: "THANKS FOR SUBMITTING FEEDBACK"
  end
end
