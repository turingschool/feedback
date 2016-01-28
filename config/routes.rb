Rails.application.routes.draw do
  root 'sessions#new'

  delete '/logout',        to: 'sessions#destroy'
  get "submission/:token", to: "submissions#new"

  post "/slack/:command", to: "slack_commands#create"

  resources :feedbacks, only: [:index, :update, :edit, :show]

  get "/login", to: redirect("/auth/slack")#, as: :login
  get "/oauth", to: redirect("/auth/slack")#, as: :login
  get "/auth/slack/callback" => "sessions#oauth"
  # get "/logout", to: "sessions#destroy", as: :logout

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
end
