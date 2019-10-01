# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - POST #confirm_details', type: :request do
  subject(:http_request) do
    post confirm_details_vehicles_path, params: { 'confirm-vehicle' => confirmation }
  end

  let(:confirmation) { 'yes' }

  before do
    add_vrn_to_session
    http_request
  end

  context 'when user confirms details' do
    it 'redirects to LA page' do
      expect(response).to redirect_to(local_authorities_path)
    end
  end

  context 'when user does not confirm details' do
    let(:confirmation) { 'no' }

    it 'redirects to incorrect details page' do
      expect(response).to redirect_to(incorrect_details_vehicles_path)
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it 'redirects to confirm details page' do
      expect(response).to redirect_to(details_vehicles_path)
    end
  end
end
