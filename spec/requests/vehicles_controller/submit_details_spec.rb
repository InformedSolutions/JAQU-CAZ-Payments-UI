# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - POST #submit_details', type: :request do
  subject(:http_request) do
    post submit_details_vehicles_path, params: { vrn: vrn, 'registration-country': country }
  end

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }

  before { http_request }

  context 'when VRN is valid' do
    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end
  end

  context 'when VRN is not valid' do
    let(:vrn) { '' }

    it 'redirects to enter details page' do
      expect(response).to render_template(:enter_details)
    end
  end

  context 'when registration country is not valid' do
    let(:country) { '' }

    it 'redirects to enter details page' do
      expect(response).to render_template(:enter_details)
    end
  end
end
