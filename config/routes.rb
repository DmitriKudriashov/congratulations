Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'holidays#index'
  # get '/companies_holidays', to: 'companies_holidays#index'
  # get '/companies_holidays/new', to: 'companies_holidays#new'
  resources :companies_holidays, only: [:index, :new, :create]

  # get '/countries_holidays', to: 'countries_holidays#index'
  # get '/countries_holidays/new', to: 'countries_holidays#new'
  resources :countries_holidays, only: [:index, :new, :create]


  # get '/dates_holidays/new', to: 'dates_holidays#new'
  # get '/dates_holidays', to: 'dates_holidays#index'
  # post '/dates_holidays', to: 'dates_holidays#create'
  resources :dates_holidays, only: [:index, :new, :create]

  resources :people #, only: [:index, :new, :create]
  resources :countries
  resources :postcards
  resources :cardtexts
  resources :emails
  resources :mail_addresses

  resources :companies_people, only: [:index, :new, :create]

  resources :companies do
    resources :companies_people, shallow: true
  end
  resources :types
  resources :holidays do
    resources :dates_holidays, shallow: true #, except: :index
    resources :companies_holidays, shallow: true  do #, except: :index
      member do
        # post :create
      end
    end
    resources :countries_holidays,  shallow: true
  end

end
