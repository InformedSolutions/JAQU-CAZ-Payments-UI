# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  resources :vehicles, only: [] do
    collection do
      get :enter_details
      post :enter_details, to: 'vehicles#submit_details'
      get :details
      post :confirm_details
      get :incorrect_details
      get :unrecognised
      post :confirm_unrecognised
      get :compliant
      get :exempt
    end
  end

  resources :non_dvla_vehicles, only: [:index] do
    collection do
      post :confirm_registration
      get :choose_type
      post :submit_type
    end
  end

  resources :charges, only: [] do
    collection do
      get :local_authority
      post :submit_local_authority
      get :review_payment
    end
  end

  resources :dates, only: [] do
    collection do
      get :select_period
      post :confirm_select_period

      get :daily_charge
      post :confirm_daily_charge

      get :weekly_charge
      post :confirm_weekly_charge

      get :select_daily_date
      post :confirm_daily_date

      get :select_weekly_date
      post :confirm_date_weekly
    end
  end

  resources :refunds, only: [] do
    collection do
      get :scenarios
      get :details
    end
  end

  resources :payments, only: %i[index create] do
    collection do
      get :success
      get :failure
    end
  end

  get :accessibility_statement, to: 'accessibility#index'
  resources :cookies, only: [:index]
  resources :policies, only: [:index]

  get :build_id, to: 'application#build_id'
  get :health, to: 'application#health'

  get :service_unavailable, to: 'application#server_unavailable'
  match '/404', to: 'errors#not_found', via: :all
  # There is no 422 error page in design systems
  match '/422', to: 'errors#internal_server_error', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/503', to: 'errors#service_unavailable', via: :all
end
