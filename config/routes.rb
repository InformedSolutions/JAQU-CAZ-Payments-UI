# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  resources :vehicles, only: [] do
    collection do
      get :enter_details
      post :validate_details
      get :confirm_details
      get :validate_confirm_details
      get :incorrect_details
      get :choose_vehicle
      post :validate_vehicle_type
      get :local_authority
      get :non_uk
      post :validate_non_uk
    end
  end
end
