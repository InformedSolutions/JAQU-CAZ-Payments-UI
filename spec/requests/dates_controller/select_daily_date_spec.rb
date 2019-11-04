# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #select_daily_date', type: :request do
  subject(:http_request) { get select_daily_date_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:la_name) { 'Leeds' }
  let(:charge) { 12.50 }

  context 'with VRN in the session' do
    before do
      add_to_session(vrn: vrn, la_id: zone_id, charge: charge, la_name: la_name)
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
