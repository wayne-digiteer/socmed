# config/routes/admin.rb
devise_for :users,
  path: "admin",
  controllers: {
    sessions: "admin/devise/sessions",
    registrations: "admin/devise/registrations",
    passwords: "admin/devise/passwords"
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

namespace :admin do
  get "/", to: "dashboard#index", as: :dashboard
  resources :posts
  resources :users
end
