Rails.application.routes.draw do
  root 'feedbacks#index'

  post "/slack/:command", to: "slack_commands#create"

  resources :feedbacks, only: [:index, :update, :edit, :show]

  get "/login", to: redirect("/auth/slack")#, as: :login
  get "/oauth", to: redirect("/auth/slack")#, as: :login
  get "/auth/slack/callback" => "sessions#oauth"
  # delete '/logout',        to: 'sessions#destroy'
  get "/logout", to: "sessions#destroy", as: :logout

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
end
