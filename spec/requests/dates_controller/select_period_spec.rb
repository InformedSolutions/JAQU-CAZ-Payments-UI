# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #select_period', type: :request do
  subject(:http_request) { get select_period_dates_path }

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }

  context 'with VRN and LA in the session' do
    before do
      add_vrn_to_session(vrn: vrn, country: country)
      add_la_to_session(zone_id: zone_id)
    end

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before do
      add_vrn_to_session(vrn: vrn, country: country)
    end

    it_behaves_like 'la is missing'
  end
end
