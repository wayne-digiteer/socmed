Rails.application.routes.draw do
  namespace :site do
    get "customer/show"
  end
  # Routes for the admin users
  draw :admin

  # Routes for the site customers
  draw :site

  get "up" => "rails/health#show", as: :rails_health_check
end
