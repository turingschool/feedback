class CheckForUnderstandingWorker
  include Sidekiq::Worker
  def perform(question, channel_id)
    b = Bot.new
    message_info = b.post_to_channel(channel_id, question)
    ["one", "two", "three", "four", "five"].each do |r|
      b.add_reaction(message_info["channel"],
                     message_info["ts"],
                     r)
    end
  end
end
