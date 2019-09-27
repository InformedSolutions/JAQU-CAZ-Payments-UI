# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  resources :vehicles, only: [] do
    collection do
      get :enter_details
      post :validate_details
      get :confirm_details
      get :incorrect_details
      post :local_authority
      get :non_uk
      post :choose_vehicle
    end
  end
end
