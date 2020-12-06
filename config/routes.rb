Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get '/help',     to: 'static_pages#help'
  get  '/signup',  to: 'masters#new'
  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',to: 'sessions#destroy'
  resources :masters
end
