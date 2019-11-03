# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #dates', type: :request do
  subject(:http_request) { get dates_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }

  context 'with VRN in the session' do
    before do
      add_vrn_to_session(vrn: vrn)
      add_la_to_session(zone_id: zone_id)
      http_request
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before do
      add_vrn_to_session(vrn: vrn)
    end

    it_behaves_like 'la is missing'
  end
end
