# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - POST #validate_non_uk', type: :request do
  subject { post validate_non_uk_vehicles_path, params: { 'confirm-registration': confirm } }

  let(:confirm) { 'true' }
  before { add_vrn_to_session }

  context 'when user confirms the registration' do
    it 'redirects to vehicle type page' do
      subject
      expect(response).to redirect_to(choose_vehicle_vehicles_path)
    end
  end

  context 'when user not confirms the registration' do
    let(:confirm) { nil }

    it 'redirects to enter details page' do
      subject
      expect(response).to redirect_to(non_uk_vehicles_path)
    end
  end
end
