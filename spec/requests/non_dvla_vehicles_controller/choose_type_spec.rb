# frozen_string_literal: true

require 'rails_helper'

describe 'NonDvlaVehiclesController - GET #choose_type', type: :request do
  subject { get choose_type_non_dvla_vehicles_path }

  context 'with VRN in the session' do
    context 'when vehicle is recognized' do
      before do
        add_vrn_to_session
        subject
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
        add_vehicle_details_to_session(vrn: 'CU57ABC', country: 'UK', unrecognised: true)
        subject
      end

      it 'assigns VehicleController#unrecognized as return path' do
        expect(assigns(:return_path)).to eq(unrecognised_vehicles_path)
      end
    end

    context 'when vehicle is possible_fraud' do
      before do
        add_vehicle_details_to_session(vrn: 'CU57ABC', country: 'UK', possible_fraud: true)
        subject
      end

      it 'assigns VehicleController#uk_registered_details as return path' do
        expect(assigns(:return_path)).to eq(uk_registered_details_vehicles_path)
      end
    end
  end

  context 'without VRN in the session' do
    before { subject }

    it 'returns a redirect to :enter_details' do
      expect(response).to redirect_to(enter_details_vehicles_path)
    end
  end
end
