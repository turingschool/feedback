module Commands
  class Base
    include Rails.application.routes.url_helpers

    attr_reader :name, :params

    def initialize(name, params)
      @name = name
      @params = params
      Rails.logger.info("Creating command handler for text: #{text} and params: #{params}")
    end

    def response
      "Sorry, command #{name} not known."
    end

    def text
      params["text"]
    end
  end
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
