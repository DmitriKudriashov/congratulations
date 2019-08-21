# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: :congratulation, path_names: { sign_in: :login, sign_out: :logout }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root  'dates_holidays#index'
  # get '/companies_holidays', to: 'companies_holidays#index'
  # get '/companies_holidays/new', to: 'companies_holidays#new'
  resources :companies_holidays, only: %i[index new create]
  # get '/countries_holidays', to: 'countries_holidays#index'
  # get '/countries_holidays/new', to: 'countries_holidays#new'
  resources :countries_holidays, only: %i[index new create]

  # get '/dates_holidays/new', to: 'dates_holidays#new'
  # get '/dates_holidays', to: 'dates_holidays#index'
  # post '/dates_holidays', to: 'dates_holidays#create'
  resources :dates_holidays, only: %i[index new create]

  resources :people # , only: [:index, :new, :create]
  resources :countries

  get '/emails/send/:id(.:format)', to: 'emails#send_e'

  get '/emails/create_emails', to: 'emails#create_emails', except: :show

  # get '/dates_holidays/after', to: 'dates_holidays', only: :after

  resources :postcards, only: %i[index new create]
  resources :cardtexts, only: %i[index new create]

  resources :emails do
    resources :email_cards, shallow: true, except: %i[index edit] do
      resources :postcards, shallow: true
    end

    resources :email_texts, shallow: true do
      resources :cardtexts, shallow: true # ,  except: [:index, :new, :create]
    end
  end

  resources :email_cards, only: %i[index create edit]

  resources :mail_addresses

  resources :companies_people, only: %i[index new create]

  resources :companies do
    resources :companies_people, shallow: true
  end

  resources :types
  resources :holidays do
    resources :dates_holidays, shallow: true # , except: :index
    resources :companies_holidays, shallow: true
    # do #, except: :index
    #  member do
    #    # post :create
    #  end
    # end
    resources :countries_holidays, shallow: true
  end
end
