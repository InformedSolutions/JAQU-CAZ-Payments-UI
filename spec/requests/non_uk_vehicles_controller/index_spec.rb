# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'NonUkVehiclesController - GET #index', type: :request do
  subject(:http_request) { get non_uk_vehicles_path }

  context 'with VRN in the session' do
    before do
      add_vrn_to_session
      http_request
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'without VRN in the session' do
    before { http_request }

    it 'returns a redirect to :enter_details' do
      expect(response).to redirect_to(enter_details_vehicles_path)
    end
  end
end
