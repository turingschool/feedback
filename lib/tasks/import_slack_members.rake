namespace :slack_members do
  desc "Generate user records for all members listed in Slack Usergroups"
  task :import => :environment do
    SlackMembers.import_from_usergroups
  end
end


