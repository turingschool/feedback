class SubmissionMailer < ApplicationMailer
  default :from => "Feedback@turing.io"

  def send_submission(submission, user)
    binding.pry
    @user_to  = user
    @feedback = submission
    mail( :to => @user_to.email,
    :subject => "Project FeedBack")
  end
end
