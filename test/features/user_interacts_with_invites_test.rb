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

  def test_submits_feedback_from_an_invite
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

    within('#submission_participation_input') do
      choose 'neutral'
    end
    within('#submission_valuable_input') do
      choose 'agree'
    end
    within('#submission_again_input') do
      choose 'strongly_agree'
    end
    fill_in :submission_comments, :with => "You're a great pair."
    click_link_or_button 'submit'

    assert_path invites_path
    within('#pending') do
      refute page.has_content?(peer2.name)
    end
    within('#completed') do
      assert page.has_content?(peer2.name)
    end
  end

  def test_a_user_submits_incomplete_feedback
    visit invites_path(:user_id => user)
    within("#feedback-for-#{peer2.id}") do
      click_link_or_button 'give_feedback'
    end

    assert_path new_submission_path

    # Blank
    click_link_or_button 'submit'
    assert page.has_css?("form.submission")

    # Fill only participation
    within('#submission_participation_input') do
      choose 'neutral'
    end
    click_link_or_button 'submit'
    assert page.has_css?("form.submission")

    # Fill valuable
    within('#submission_valuable_input') do
      choose 'neutral'
    end
    click_link_or_button 'submit'
    assert page.has_css?("form.submission")

    # Fill again
    within('#submission_again_input') do
      choose 'neutral'
    end
    click_link_or_button 'submit'
    assert page.has_css?("form.submission")

    # Add a too-short comment
    fill_in :submission_comments, :with => "You suck"
    click_link_or_button 'submit'
    assert page.has_css?("form.submission")

    # Add a good comment
    fill_in :submission_comments, :with => "You're a great pair. Thanks for your time!"
    click_link_or_button 'submit'

    # Finally success
    assert_path invites_path
    within('#completed') do
      assert page.has_content?(peer2.name)
    end
  end
end
