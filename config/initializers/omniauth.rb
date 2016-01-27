Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack,
           ENV["FEEDBACK_SLACK_CLIENT_ID"],
           ENV["FEEDBACK_SLACK_CLIENT_SECRET"],
           scope: "channels:history,channels:read,team:read,usergroups:read,users:read,identify"
end
