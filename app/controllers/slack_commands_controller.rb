class SlackCommandsController < ApplicationController
  rescue_from Exception, with: :text_error_handler
  skip_before_action :verify_authenticity_token
  before_action :verify_slack_token

  def text_error_handler(error)
    Rails.logger.info("Slack Command encountered error: #{error.class} -- #{error.message}")
    Rails.logger.info(error.backtrace.join("\n"))
    render text: "Error: #{error.class} -- #{error.message}"
  end

  def command_handler(command)
    {"feedback" => Commands::RequestFeedback,
     "pairs" => Commands::Pairs,
     "groups" => Commands::Groups,
     "check" => Commands::CheckForUnderstanding
    }.fetch(command, Commands::Base)
  end

  def create
    render text: command_handler(params["command"]).
            new(params["command"], params).
            response
  end


  def verify_slack_token
    raise "invalid token" unless params["token"] == ENV["FEEDBACK_SLASH_COMMAND_TOKEN"]
  end
end
