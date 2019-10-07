# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  resources :vehicles, only: [] do
    collection do
      get :enter_details
      post :submit_details
      get :details
      post :confirm_details
      get :incorrect_details
      get :unrecognised_vehicle
    end
  end

  resources :non_uk_vehicles, only: [:index] do
    collection do
      post :confirm_registration
      get :choose_type
      post :submit_type
    end
  end

  resources :local_authorities, only: [:index]

  resources :refunds, only: [] do
    collection do
      get :scenarios
      get :details
    end
  end

  get :build_id, to: 'application#build_id'
end
