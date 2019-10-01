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
end
