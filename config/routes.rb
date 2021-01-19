Rails.application.routes.draw do

  root 'perfect_shifts#index'
  get '/help',      to: 'static_pages#help'
  get  '/signup',   to: 'masters#new'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  post '/logout',    to:'sessions#destroy'

  resources :masters do
    patch     :shift_onoff   , on: :member
    resources :shift_separations, :except => [:show]

    member do
      get :login,  to: 'masters#login_form'
      post :login, to: 'masters#login'
      delete :logout
    end
  end

  resources :staffs 

  get :perfect_shifts, to: 'perfect_shifts#index' 
  get :comfirmed_shifts,  to: 'comfirmed_shifts#index'
  #get :temporary_shifts,  to: 'temporary_shifts#index'

  resources :temporary_shifts , :only => [:index, :destroy] do
    collection do
      get :new_shift
      get :new_plan
      post :create_shift
      post :create_plan
      get  :delete
      patch :perfect
    end
    
    member do
      patch :deletable
    end

  end
  

  resources :individual_shifts do
    
    collection do
      patch  :confirm,  to: 'individual_shifts#confirm'
      patch  :perfect
      get  :remove
    end

    member do
      patch :deletable, to: 'individual_shifts#deletable'
    end
  end

end
