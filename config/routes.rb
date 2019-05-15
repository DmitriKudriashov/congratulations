Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'holidays#index'
  get '/companies_holidays', to: 'companies_holidays#index'

  resources :countries
  resources :companies
  resources :types
  resources :people
  resources :holidays do
    resources :dates_holidays, shallow: true #, except: :index
    resources :companies_holidays, shallow: true #, except: :index
  end

  get '/companies_holidays/new', to: 'companies_holidays#new_company_holiday'

end
