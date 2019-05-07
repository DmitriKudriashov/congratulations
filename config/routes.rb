Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'companies#index'

  resources :companies
  resources :types
  resources :people
  resources :holidays
  resources :dates_holidays

end
