# config/routes/site.rb
devise_for :customers,
  path: "/",
  controllers: {
    sessions: "site/sessions",
    registrations: "site/registrations",
    passwords: "site/passwords"
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
end
