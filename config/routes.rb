Rails.application.routes.draw do
  # Routes for the admin users
  draw :admin

  # Routes for the site customers
  draw :site

  get "up" => "rails/health#show", as: :rails_health_check
end
