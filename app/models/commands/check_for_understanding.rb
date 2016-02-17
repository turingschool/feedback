module Commands
  class CheckForUnderstanding < Base
    def response
      CheckForUnderstandingWorker.perform_async("Check for Understanding: #{params["text"]}.",
                                                params["channel_id"])
      "Check for understanding incoming..."
    end
  end
end

