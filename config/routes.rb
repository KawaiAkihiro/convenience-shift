Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help',      to: 'static_pages#help'
  get  '/signup',   to: 'masters#new'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  post 'logout',    to:'sessions#destroy'

  get '/staffs/login',   to: 'staffs_sessions#new'
  post '/staffs/login',  to: 'staffs_sessions#create'
  post '/staffs/logout', to: 'staffs_sessions#destroy'

  resources :masters do
    patch     :shift_onoff   , on: :member
    resources :shift_separations, :except => [:show]
  end

  resources :staffs 

  resources :individual_shifts do
    collection do
      get    :confirm,  to: 'individual_shifts#confirm_form'
      patch  :confirm,  to: 'individual_shifts#confirm'
      get    :confirmed
    end
    
  end

end
