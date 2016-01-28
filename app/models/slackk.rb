class Slackk
  def self.all_slack_members
    Rails.cache.fetch("all_slack_members") do
      Slack.users_list["members"]
    end
  end

  def self.member(uid)
    all_slack_members.find { |m| m["id"] == uid }
  end

  def self.member_by_name(slack_name)
    all_slack_members.find { |m| m["name"] == slack_name }
  end

  def self.user_groups
    Rails.cache.fetch("user_groups") do
      Slack.usergroups_list["usergroups"]
    end
  end

  def self.user_group_by_handle(handle)
    handle = handle.sub(/^@/,"")
    user_groups.find do |g|
      g["handle"] == handle
    end
  end

  def self.user_group_members(user_group_id)
    Rails.cache.fetch("user_group_#{user_group_id}") do
      Slack.usergroups_users_list(usergroup: user_group_id)["users"]
    end
  end
end
