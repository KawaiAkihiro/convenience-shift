Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get '/help',      to: 'static_pages#help'
  get  '/signup',   to: 'masters#new'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  post 'logout',    to:'sessions#destroy'

  get '/staffs/login',   to: 'staffs_sessions#new'
  post '/staffs/login',  to: 'staffs_sessions#create'
  post '/staffs/logout', to: 'staffs_sessions#destroy'

  resources :masters
  resources :staffs
end
