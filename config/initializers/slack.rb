require "slack"

Slack.configure do |config|
  config.token = ENV["SLACK_ADMIN_TOKEN"]
end

# Monkeypatch to match the generated code from this example:
# https://github.com/aki017/slack-ruby-gem/blob/dev/lib/slack/endpoint/usergroups.rb#L113-L121
# Takes a Usergroup ID and fetches list of users in that group
module Slack
  module Endpoint
    module Usergroups
      def usergroups_users_list(options={})
        throw ArgumentError.new("Required arguments :usergroup missing") if options[:usergroup].nil?
        post("usergroups.users.list", options)
      end
    end
  end
end

module SlackMembers
  def self.import_from_usergroups
    slack_members = Slack.users_list["members"]
    puts "found #{slack_members.count} slack members"
    user_groups = Slack.usergroups_list["usergroups"]
    puts "found #{user_groups.count} user groups"
    user_groups.map do |g|
      g["id"]
    end.flat_map do |g_id|
      puts "retrieving users for group #{g_id}"
      Slack.usergroups_users_list(usergroup: g_id)["users"]
    end.each do |uid|
      puts "importing user account for uid: #{uid}"
      slack_member_info = slack_members.find { |u| u["id"] == uid }
      if user = User.find_by(slack_id: uid)
        puts "found pre-existing user record for #{uid}; will update"
        user.update_attributes(name: slack_member_info["real_name"],
                               email: slack_member_info["profile"]["email"],
                               slack_name: slack_member_info["name"])
      else
        if User.create(name: slack_member_info["real_name"],
                       email: slack_member_info["profile"]["email"],
                       slack_id: uid,
                       admin: false,
                       slack_name: slack_member_info["name"])
          puts "imported user #{uid}"
        else
          puts "failed to import user #{uid}"
        end
      end
    end
  end
end
