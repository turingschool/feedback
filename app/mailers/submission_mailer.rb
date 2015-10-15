class SubmissionMailer < ApplicationMailer
  default :from => "Feedback@turing.io"

  def send_submission(submission)
    @user_to  = submission.feedback_for
    @feedback = submission
    @title    = submission.project_title
    mail( :to => @user_to.email,
    :subject => "#{@title} FeedBack")
  end
end
