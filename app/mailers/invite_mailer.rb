class InviteMailer < ApplicationMailer
  default :from => "Feedback@turing.io"

  def create_invite(user_from, user_to, token)
    @user_from = user_from
    @user_to   = user_to
    @token     = token
    mail( :to => @user_from.email,
    :subject => "FeedBack Requested")
  end
end
