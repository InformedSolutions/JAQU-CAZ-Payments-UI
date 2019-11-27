# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #exempt', type: :request do
  subject(:http_request) { get exempt_vehicles_path }

  context 'with VRN in session' do
    before do
      add_vrn_to_session
    end

    it 'returns http success' do
      http_request
      expect(response).to be_successful
    end
  end

  context 'without VRN' do
    it 'redirects to enter details page' do
      http_request
      expect(response).to redirect_to(enter_details_vehicles_path)
    end
  end
end
