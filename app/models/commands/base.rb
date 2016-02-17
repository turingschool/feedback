module Commands
  class Base
    attr_reader :name, :params
    def initialize(name, params)
      Rails.logger.info("Creating command handler for text: #{text} and params: #{params}")
      @name = name
      @params = params
    end

    def response
      "Sorry, command #{name} not known."
    end

    def text
      params["text"]
    end
  end
end
