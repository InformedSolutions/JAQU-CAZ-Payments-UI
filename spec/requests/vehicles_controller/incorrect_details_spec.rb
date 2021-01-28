# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #incorrect_details', type: :request do
  subject { get incorrect_details_vehicles_path }

  context 'when vehicle is recognized' do
    before do
      add_vrn_to_session
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'sets incorrect in the session' do
      expect(session[:vehicle_details]['incorrect']).to be_truthy
    end
  end

  context 'when vehicle is possible_fraud' do
    before do
      add_vehicle_details_to_session(vrn: 'CU57ABC', country: 'UK', possible_fraud: true)
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'sets incorrect in the session' do
      expect(session[:vehicle_details]['incorrect']).to be_truthy
    end

    it 'assigns VehicleController#uk_registered_details as return path' do
      expect(assigns(:return_path)).to eq(uk_registered_details_vehicles_path)
    end
  end
end
