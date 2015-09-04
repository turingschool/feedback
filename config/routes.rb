Rails.application.routes.draw do
  root 'admin/invite_sets#new'
  get "positive/:id",       to: "submissions#positive", as: "positive"
  get "negative/:id",       to: "submissions#negative", as: "negative"
  get "submission/:token",  to: "submissions#new",      as: "submission"

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
