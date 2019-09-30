# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #choose_vehicle', type: :request do
  subject { post choose_vehicle_vehicles_path, params: { 'confirm-registration': confirm } }

  let(:confirm) { 'true' }
  before { add_vrn_to_session }

  context 'when registration number confirmed' do
    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end
  end

  context 'when registration number not confirmed' do
    let(:confirm) { 'false' }

    it 'redirects to enter details page' do
      subject
      expect(response).to redirect_to(non_uk_vehicles_path)
    end
  end
end
