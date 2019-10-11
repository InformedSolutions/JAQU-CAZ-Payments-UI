# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - GET #dates', type: :request do
  subject(:http_request) { get dates_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }

  context 'with VRN in the session' do
    before do
      add_vrn_to_session(vrn: vrn)
      add_la_to_session(zone_id)
      http_request
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'without VRN in the session' do
    it 'redirects to :enter_details' do
      expect(http_request).to redirect_to(enter_details_vehicles_path)
    end
  end
end
