class SlackCommandsController < ApplicationController
  rescue_from Exception, with: :text_error_handler
  skip_before_action :verify_authenticity_token
  before_action :verify_slack_token

  def text_error_handler(error)
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
    command_handler(params["command"]).
      new(params["command"], params).
      response

    # params["text"] takes everything after the command name and
    # initial space
    # e.g. /command this is the text
    # params["text"] == "this is the text"
    # case params["command"]
    # when "feedback"
    #   render text: feedback_handler(params["text"])
    # when "pairs"
    #   render text: pairs_handler(params["text"])
    # when "groups"
    #   render text: groups_handler(params["text"])
    # when "check"
    #   render text: check_handler(params)
    # else
    #   "Sorry, command #{params["command"]} not known."
    # end
  end

  # sample params
  #   {"token"=>"XXXXXX",
  # "team_id"=>"T029P2S9M",
  # "team_domain"=>"turingschool",
  # "channel_id"=>"D0KJSMAEL",
  # "channel_name"=>"directmessage",
  # "user_id"=>"U02MYKGQB",
  # "user_name"=>"horace",
  # "command"=>"pairs",
  # "text"=>"sadfsadfdsaf asdfadsf asdfasdf",
  # "response_url"=>"https://hooks.slack.com/commands/T029P2S9M/20226350451/XXXXXXX"}

  def verify_slack_token
    raise "invalid token" unless params["token"] == ENV["FEEDBACK_SLASH_COMMAND_TOKEN"]
  end
end
