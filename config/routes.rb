Rails.application.routes.draw do
  root 'sessions#new'

  get   '/login',          to: 'sessions#new'
  post   '/login',         to: 'sessions#create'
  delete '/logout',        to: 'sessions#destroy'
  get "submission/:token", to: "submissions#new"

  post "/slack/:command", to: "slack_commands#create"

  get "/feedback/:token", to: "feedbacks#edit", as: "feedback"
  patch "/feedback/:token", to: "feedbacks#update", as: "update_feedback"

  get "/oauth", to: redirect("/auth/slack")#, as: :login
  get "/auth/slack/callback" => "sessions#oauth"
  # get "/logout", to: "sessions#destroy", as: :logout

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
end
