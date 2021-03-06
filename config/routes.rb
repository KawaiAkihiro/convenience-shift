Rails.application.routes.draw do

  root 'perfect_shifts#index'
  get '/help',      to: 'static_pages#help'
  get  '/signup',   to: 'masters#new'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  post '/logout',    to:'sessions#destroy'

  resources :masters do
    patch     :shift_onoff   , on: :collection
    resources :shift_separations, :except => [:show]

    member do
      get :login,  to: 'masters#login_form'
      post :login, to: 'masters#login'
      delete :logout
    end
  end

  resources :staffs 

  resources :notices, :only => [:index, :show, :destroy, :update] do
    # patch :deny, on: :member
  end

  # get :chnage_form,      to: 'perfect_shifts#change_form'
  # patch :change,         to: 'perfect_shifts#change'

  resources :perfect_shifts, :only => [:index] do
    collection do
      get :fill
      get :change
      get :new_plan
      post :create_plan
    end

    member do
      patch :fill_in
      patch :instead
      patch :delete
    end
  end

  get :comfirmed_shifts,  to: 'comfirmed_shifts#index'

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

  resources :deletable_shifts, :only => [:index] do
    get :restore , on: :collection
    patch :reborn, on: :member
  end
  
  resources :individual_shifts do
    
    collection do
      # patch  :confirm,  to: 'individual_shifts#confirm'
      patch  :perfect
      get  :remove
      post :finish
    end

    member do
      patch :deletable, to: 'individual_shifts#deletable'
    end
  end

end
