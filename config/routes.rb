Rails.application.routes.draw do
  post "/telegram/:token" => "telegram#receive"

  resources :users, only: [:show] do
    resources :messages, only: [:create]
  end
end
