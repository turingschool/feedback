class SlackMessageWorker
  include Sidekiq::Worker
  def perform(uid, message)
    puts "sending slack message: #{message} to user: #{uid}"
    sbot = Bot.new
    sbot.message_user(uid, message)
  end
end
