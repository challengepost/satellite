Satellite::Engine.routes.draw do
  get '/auth/login' => 'satellite/sessions#new', :as => :sign_in
  get '/auth/logout' => 'satellite/sessions#destroy', :as => :sign_out
  get '/auth/:provider/callback' => 'satellite/sessions#create'
  get '/auth/failure' => 'satellite/sessions#failure', :as => :failure
end
