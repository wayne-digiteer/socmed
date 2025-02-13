# config/routes/site.rb
devise_for :customers,
  path: "/",
  controllers: {
    sessions: "site/devise/sessions",
    registrations: "site/devise/registrations",
    passwords: "site/devise/passwords"
  },
  path_names: {
    sign_in: "/login",
    password: "/forgot",
    confirmation: "/confirm",
    unlock: "/unblock",
    registration: "/register",
    sign_up: "/new",
    sign_out: "/logout",
    password_expired: "/password-expired"
  }

namespace :site, path: "/" do
  resources :post
  root to: "posts#index"
end
