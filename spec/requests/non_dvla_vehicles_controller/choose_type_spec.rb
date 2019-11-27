# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'NonDvlaVehiclesController - GET #choose_type', type: :request do
  subject(:http_request) { get choose_type_non_dvla_vehicles_path }

  context 'with VRN in the session' do
    context 'when vehicle is recognized' do
      before do
        add_vrn_to_session
        http_request
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns :index as return path' do
        expect(assigns(:return_path)).to eq(non_dvla_vehicles_path)
      end
    end

    context 'when vehicle is unrecognized' do
      before do
        add_to_session(vrn: 'CU57ABC', country: 'UK', unrecognised: true)
        http_request
      end

      it 'assigns VehicleController#unrecognized as return path' do
        expect(assigns(:return_path)).to eq(unrecognised_vehicles_path)
      end
    end
  end

  context 'without VRN in the session' do
    before { http_request }

    it 'returns a redirect to :enter_details' do
      expect(response).to redirect_to(enter_details_vehicles_path)
    end
  end
end
