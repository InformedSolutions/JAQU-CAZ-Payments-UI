# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #details', type: :request do
  subject(:http_request) { get details_vehicles_path }

  context 'with VRN in session' do
    before do
      add_vrn_to_session
      mock_vehicle_details
    end

    it 'returns http success' do
      http_request
      expect(response).to be_successful
    end

    context 'when vehicle is exempted' do
      let(:vehicle_details_stub) { instance_double('VehicleDetails', exempt?: true) }

      before { allow(VehicleDetails).to receive(:new).and_return(vehicle_details_stub) }

      it 'redirects to compliant path' do
        http_request
        expect(response).to redirect_to(compliant_vehicles_path)
      end
    end
  end

  context 'without VRN in session' do
    it 'redirects to enter details page' do
      http_request
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
end
