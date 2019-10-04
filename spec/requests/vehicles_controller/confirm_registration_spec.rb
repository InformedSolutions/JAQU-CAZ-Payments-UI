# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #confirm_registation', type: :request do
  subject(:http_request) do
    get confirm_registration_vehicles_path,
        params: { 'confirm-registration': confirmation }
  end

  let(:confirmation) { 'true' }

  before do
    add_vrn_to_session
    http_request
  end

  context 'when registration confirmed' do
    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'redirects to unrecognised page' do
      expect(response).to redirect_to(choose_type_non_uk_vehicles_path)
    end
  end

  context 'when registration not confirmed' do
    let(:confirmation) { 'false' }

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'redirects to unrecognised page' do
      expect(response).to redirect_to(unrecognised_vehicles_path)
    end
  end
end
