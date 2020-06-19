# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #uk_registered_details', type: :request do
  subject { get uk_registered_details_vehicles_path }

  context 'with VRN in session' do
    before do
      add_vrn_to_session
      mock_vehicle_details
    end

    it 'returns http success' do
      subject
      expect(response).to be_successful
    end

    it 'sets type in the session' do
      subject
      expect(session[:vehicle_details]['type']).not_to be_nil
    end

    context 'when vehicle is exempted' do
      before do
        vehicle_details_stub = instance_double('VehicleDetails', exempt?: true)
        allow(VehicleDetails).to receive(:new).and_return(vehicle_details_stub)
      end

      it 'redirects to exempt path' do
        subject
        expect(response).to redirect_to(exempt_vehicles_path)
      end
    end

    context 'when vehicle is a taxi' do
      before do
        mock_vehicle_details_taxi
        subject
      end

      it 'sets taxi in the session' do
        expect(session[:vehicle_details]['leeds_taxi']).to be_truthy
      end
    end
  end

  context 'without VRN in session' do
    it 'redirects to enter details page' do
      subject
      expect(response).to redirect_to(enter_details_vehicles_path)
    end
  end

  context 'when API call fails' do
    before do
      add_vrn_to_session
      allow(ComplianceCheckerApi).to receive(:vehicle_details).and_raise(
        BaseApi::Error500Exception.new(500, 'internal error', message: 'Boom')
      )
    end

    it_behaves_like 'an unsuccessful API call'
  end

  context 'when vehicle is not found' do
    before do
      add_vrn_to_session
      allow(ComplianceCheckerApi).to receive(:vehicle_details).and_raise(
        BaseApi::Error404Exception.new(404, 'not found', message: 'Boom')
      )
    end

    it 'redirects to :unrecognized' do
      subject
      expect(response).to redirect_to(unrecognised_vehicles_path)
    end
  end
end
