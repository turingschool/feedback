class FeedbacksController < ApplicationController
  before_action :require_login, only: [:index]
  def index
  end

  def show
    @fb = Feedback.find_by(token: params[:id])
    if @fb
      render text: "Feedback: from: #{@fb.sender.name}, to: #{@fb.receiver.name}, text: #{@fb.text}"
    else
      render text: "Feedback #{params[:id]} not found"
    end
  end

  def edit
    @fb = Feedback.find_by(token: params[:id])
  end

  def update
    fb = Feedback.find_by(token: params[:id])
    fb.text = params[:feedback][:text]
    fb.save
    msg = "Hi, #{fb.receiver.slack_name}, #{fb.sender.slack_name} sent you the following feedback: #{fb.text}"
    SlackMessageWorker.perform_async(fb.receiver.slack_id, msg)
    flash[:message] = "Thanks for submitting feedback to #{fb.receiver.name}."
    redirect_to feedbacks_path
  end
end
