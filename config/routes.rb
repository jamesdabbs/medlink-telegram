Rails.application.routes.draw do
  post "/telegram/:token" => "telegram#receive"

  resources :users, only: [:show] do
    resources :notifications, only: [] do
      collection do
        post :check_delivery
        post :response_created
      end
    end
  end
end
