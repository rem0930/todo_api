Rails.application.routes.draw do
  resources :todos
  resources :users, only: [:create]
  post '/login', to: 'sessions#create'
end
