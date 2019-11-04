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
      post :confirm_unrecognised_registration
      get :compliant
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

  get :build_id, to: 'application#build_id'
end
