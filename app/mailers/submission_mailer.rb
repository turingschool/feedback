class SubmissionMailer < ApplicationMailer
  default :from => "Feedback@turing.io"

  def send_submission(submission, user, title)
    @user_to  = user
    @feedback = submission
    mail( :to => @user_to.email,
    :subject => "#{title} FeedBack")
  end
end
