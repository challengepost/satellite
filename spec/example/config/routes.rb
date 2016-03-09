Rails.application.routes.draw do
  mount Satellite::Engine => "/", as: :satellite
  root :to => "visitors#index"
  get "about" => "high_voltage/pages#show", id: "about"

  get "auth/router", to: "authentications#router"
end
