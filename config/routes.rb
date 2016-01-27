Rails.application.routes.draw do
  root 'sessions#new'

  get   '/login',          to: 'sessions#new'
  post   '/login',         to: 'sessions#create'
  delete '/logout',        to: 'sessions#destroy'
  get "submission/:token", to: "submissions#new"

  resources :submissions, only: [:index, :create, :update]
  resources :invites
  namespace :admin do
    get "deliver-all/:id",  to: "admin/users#deliver_all", as: "deliver_all" #just an idea for later
    resources :submissions, only: [:index, :update]
    resources :users
    resources :invite_sets do
      member do
        post :deliver
      end
    end
  end

  get "/oauth", to: redirect("/auth/slack")#, as: :login
  get "/auth/slack/callback" => "sessions#oauth"
  # get "/logout", to: "sessions#destroy", as: :logout

end
