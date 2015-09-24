Rails.application.routes.draw do
  mount Satellite::Engine => "/satellite"
  root :to => "visitors#index"
  get "about" => "high_voltage/pages#show", id: "about"
end
