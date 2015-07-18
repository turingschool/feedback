require 'test_helper'

class UserInteractsWithInvitesTest < ActionDispatch::IntegrationTest

  attr_reader :user, :peer1, :peer2, :set

  def setup
    @user = User.create(:name => "Jeff Casimir")
    @peer1 = User.create(:name => "Steve Kinney")
    @peer2 = User.create(:name => "Mike Dao")
    @set = InviteSet.create!(
      'title' => "Sample Project A",
      'groups' => "* Jeff Casimir & Steve Kinney & Mike Dao"
    )
    @set.deliver!
  end

  def test_sees_their_invites
    visit invites_path(:user_id => user)
    assert_content user.name
    within('#pending') do
      assert_content peer1.name
      assert_content peer2.name
    end
  end

  def test_sees_their_invites
    visit invites_path(:user_id => user)
    within("#feedback-for-#{peer2.id}") do
      click_link_or_button 'give_feedback'
    end

    assert_path new_submission_path
    within("#feedback-for") do
      assert_content peer2.name
    end
    within("#title") do
      assert_content set.title
    end
    within('#participation') do
      choose 'neutral'
    end
    within('#valuable') do
      choose 'agree'
    end
    within('#again') do
      choose 'strongly_agree'
    end
    fill_in :comments, :with => "You're a great pair."
    click_link_or_button 'submit'

    assert_path invites_path
    within('#pending') do
      refute page.has_content?(peer2.name)
    end
    within('#completed') do
      assert page.has_content?(peer2.name)
    end
  end
end
