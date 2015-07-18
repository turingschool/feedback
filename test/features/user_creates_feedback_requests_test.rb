require 'test_helper'

class UserCreatesFeedbackRequestsTest < ActionDispatch::IntegrationTest

  def test_user_drops_groupings_into_a_form
    visit new_invite_set_path
    fill_in 'title', :with => "Sample Project A"
    fill_in 'groups', :with => "* Jeff Casimir & Rachel Warbelow\n* Steve Kinney & Jorge Tellez"
    click_link_or_button 'submit'
    assert_ok page
  end
end
