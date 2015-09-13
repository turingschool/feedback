# Preview all emails at http://localhost:3000/rails/mailers
class CreateInviteEmailPreview < ActionMailer::Preview
  def create_invite
    user = User.last
    InviteMailer.create_invite(user)
  end
end
