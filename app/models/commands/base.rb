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
