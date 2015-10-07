class RemoveInviteDuplicationsFromSubmissons < ActiveRecord::Migration

  def up
    remove_column :submissions, :feedback_from_id
    remove_column :submissions, :feedback_for_id
    remove_column :submissions, :token
  end


  def down
    add_column :submissions, :feedback_from_id, :integer
    add_column :submissions, :feedback_for_id, :integer
    add_column :submissions, :token, :string

    Submission.all.each do |submission|
      invite = submission.invite
      submission.update_attributes(feedback_for_id: invite.feedback_for_id, feedback_from_id: invite.feedback_from_id, token: invite.token)
    end
  end
end
