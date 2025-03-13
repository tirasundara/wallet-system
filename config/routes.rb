# config/routes.rb
Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # Authentication routes
      post "login", to: "sessions#create"

      # User routes
      resource :user, only: [ :show ]

      # Wallet routes
      resources :wallets, only: [ :show ] do
        resources :transactions, only: [ :index ]
        post "deposit", to: "transactions#deposit"
        post "withdraw", to: "transactions#withdraw"
      end

      # Transaction routes
      post "transfer", to: "transactions#transfer"

      # Stock routes
      resources :stocks, only: [ :index ]
      get "stocks/:symbol", to: "stocks#show"

      # Team routes
      resources :teams, only: [ :index, :show ]
    end
  end
end
