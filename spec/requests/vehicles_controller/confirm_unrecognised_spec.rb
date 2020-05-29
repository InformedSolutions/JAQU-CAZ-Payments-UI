# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - POST #confirm_unrecognised', type: :request do
  subject do
    post confirm_unrecognised_vehicles_path,
         params: { 'confirm-registration': confirmation }
  end

  let(:confirmation) { 'yes' }

  before do
    add_vrn_to_session
    subject
  end

  context 'when registration confirmed' do
    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'redirects to unrecognised page' do
      expect(response).to redirect_to(choose_type_non_dvla_vehicles_path)
    end
  end

  context 'when registration not confirmed' do
    let(:confirmation) { nil }

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'redirects to unrecognised page' do
      expect(response).to redirect_to(unrecognised_vehicles_path)
    end
  end
end
