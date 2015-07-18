require 'test_helper'

class UserInteractsWithInvitesTest < ActionDispatch::IntegrationTest

  def test_sees_their_invites
    user = User.create(:name => "Jeff Casimir")
    peer1 = User.create(:name => "Steve Kinney")
    peer2 = User.create(:name => "Mike Dao")
    user.invites.create!(:feedback_for => peer1)
    user.invites.create!(:feedback_for => peer2)

    visit invites_path(:user_id => user)
    assert_content user.name
    within('#pending-invites') do
      assert_content peer1.name
      assert_content peer2.name
    end
  end
end
