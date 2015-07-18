ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  def make_invite_set
    InviteSet.create!(
      'title' => "Sample Project A",
      'groups' => "* Jeff Casimir & Rachel Warbelow\n* Steve Kinney & Jorge Tellez"
    )
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def assert_ok(page)
    assert_equal 200, page.status_code
  end

  def assert_path(path)
    assert_equal path, current_path
  end

  def assert_content(expected)
    assert_match /.*#{expected}.*/, page.body
  end
end
