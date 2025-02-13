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

scope module: :site, path: "/" do
  resources :posts, controller: "/site/posts", as: :posts
  root "posts#index", as: :root
end
