# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - POST #validate_vehicle_type', type: :request do
  subject { post validate_vehicle_type_vehicles_path, params: { 'vehicle-type': vehicle_type } }

  let(:vehicle_type) { 'car' }
  before { add_vrn_to_session }

  context 'when user choose the vehicle type' do
    it 'redirects to local authority page' do
      subject
      expect(response).to redirect_to(local_authority_vehicles_path)
    end
  end

  context 'when user not choose the vehicle type' do
    let(:vehicle_type) { nil }

    it 'redirects to vehicle type page' do
      subject
      expect(response).to redirect_to(choose_vehicle_vehicles_path)
    end
  end
end
