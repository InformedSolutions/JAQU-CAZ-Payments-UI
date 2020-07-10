# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - POST #submit_type', type: :request do
  subject do
    post not_determined_vehicles_path, params: { 'vehicle-type': vehicle_type }
  end

  let(:vehicle_type) { 'car' }

  before do
    add_vrn_to_session
    subject
  end

  context 'when user chooses the vehicle type' do
    it 'redirects to select local authority page' do
      expect(response).to redirect_to(local_authority_charges_path)
    end

    it 'sets the type in the session' do
      expect(session[:vehicle_details]['type']).to eq(vehicle_type)
    end
  end

  context 'when user does not choose the vehicle type' do
    let(:vehicle_type) { nil }

    it 'redirects to :choose_type page' do
      expect(response).to redirect_to(not_determined_vehicles_path)
    end
  end
end
