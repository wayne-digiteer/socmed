Rails.application.routes.draw do
  resources :posts
  get "pages/home"
  # Routes for the admin users
  draw :admin

  # Routes for the site customers
  draw :site

  # Defines the root path route ("/")
  root "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
end
