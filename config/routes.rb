Rails.application.routes.draw do
  root 'sessions#new'

  get   '/login',   to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get "positive/:id",          to: "submissions#positive",    as: "positive"
  get "negative/:id",          to: "submissions#negative",    as: "negative"
  get "submission/:token",     to: "submissions#new",         as: "submission"
  get "admin/deliver-all/:id", to: "admin/users#deliver_all", as: "deliver_all"

  resources :submissions, only: [:index, :create]
  resources :invites
  namespace :admin do
    resources :submissions, only: [:index, :update]
    resources :users
    resources :invite_sets do
      member do
        post :deliver
      end
    end
   end
end
