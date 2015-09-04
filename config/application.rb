require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "action_mailer/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Feedback
  class Application < Rails::Application
    config.action_mailer.delivery_method = :smtp

    config.action_mailer.smtp_settings = {
      address:              'smtp.mandrillapp.com',
      port:                 '587',
      user_name:            'tjmee90@gmail.com',
      password:             ENV['mandrill_key'],
      authentication:       'plain',
      enable_starttls_auto: true
    }
    config.active_record.raise_in_transactional_callbacks = true
  end
end
