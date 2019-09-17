# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  resources :vehicle_checkers, only: [] do
    collection do
      get :enter_details
      post :validate_vrn
    end
  end
end
