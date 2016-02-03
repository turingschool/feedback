require "slack"
class Bot
  attr_reader :client
  def initialize
    @client = Slack::Client.new(token: ENV["FEEDBACK_BOT_TOKEN"])
  end

  def message_user(uid, text)
    channel = im_channel(uid)
    client.chat_postMessage(channel: channel, text: text)
  end

  def im_channel(uid)
    client.im_open(user: uid)["channel"]["id"]
  end

  def post_to_channel(channel_id, text)
    client.chat_postMessage(channel: channel_id,
                            text: text)
  end

  def add_reaction(channel_id, timestamp, emoji)
    client.reactions_add(name: emoji,
                         channel: channel_id,
                         timestamp: timestamp)
  end
end
