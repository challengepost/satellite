Rails.application.routes.draw do
  mount Satellite::Engine => "/", as: :satellite
  root :to => "visitors#index"
  get "about" => "high_voltage/pages#show", id: "about"

  get "auth/satellite_refresh", to: "authentications#satellite_refresh"
end
