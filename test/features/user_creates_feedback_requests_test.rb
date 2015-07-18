require 'test_helper'

class UserCreatesFeedbackRequestsTest < ActionDispatch::IntegrationTest

  def test_user_enters_groupings_into_a_form
    visit new_invite_set_path
    fill_in 'title', :with => "Sample Project A"
    fill_in 'groups', :with => "* Jeff Casimir & Rachel Warbelow\n* Steve Kinney & Jorge Tellez"
    click_link_or_button 'submit'
    assert_ok page
  end

  def test_user_sends_invites_from_a_set
    invite_set = make_invite_set
    visit invite_sets_path
    within("#invite-set-#{invite_set.id}") do
      click_link_or_button('deliver')
    end

    assert_path invite_sets_path
    within("#invite-set-#{invite_set.id}") do
      assert_content "delivered"
    end
  end
end
