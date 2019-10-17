# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - GET #review_payment', type: :request do
  subject(:http_request) { get review_payment_charges_path }

  let(:zone_id) { SecureRandom.uuid }

  context 'with VRN, LA and DATES in the session' do
    before do
      add_vrn_to_session
      add_la_to_session(zone_id)
      add_dates_to_session
      add_daily_charge_to_session
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
      add_vrn_to_session
    end

    it_behaves_like 'la is missing'
  end

  context 'without DATES in the session' do
    before do
      add_vrn_to_session
      add_la_to_session(zone_id)
    end

    it_behaves_like 'dates is missing'
  end
end
