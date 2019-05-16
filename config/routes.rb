Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'holidays#index'
  get '/companies_holidays', to: 'companies_holidays#index'
  get '/companies_holidays/new', to: 'companies_holidays#new'

  resources :countries
  resources :companies
  resources :types
  resources :people
  resources :companies_holidays, only: :create
  resources :holidays do
    resources :dates_holidays, shallow: true #, except: :index
    resources :companies_holidays, shallow: true  do #, except: :index
      member do
        # post :create
      end
    end
  end
  # post 'companies_holidays', to: 'companies_holidays#create'
end
