# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_daily_date', type: :request do
  subject(:http_request) do
    post confirm_daily_date_dates_path, params: dates
  end

  let(:dates) { { 'dates' => %w[2019-10-07 2019-10-10] } }
  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:la_name) { 'Leeds' }
  let(:charge) { 12.50 }

  context 'with VRN, COUNTRY, LA, LA NAME and CHARGE in the session' do
    before do
      add_to_session(vrn: vrn, la_id: zone_id, charge: charge, la_name: la_name)
      http_request
    end

    context 'with checked dates' do
      it 'redirects to :review_payment' do
        expect(http_request).to redirect_to(review_payment_charges_path)
      end
    end

    context 'without checked dates' do
      let(:dates) { nil }

      it 'redirects to :dates_charges' do
        expect(http_request).to redirect_to(select_daily_date_dates_path)
      end
    end

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
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

  context 'without CHARGE in the session' do
    before do
      add_to_session(vrn: vrn, country: country, la_id: zone_id, la_name: la_name)
    end

    it_behaves_like 'charge is missing'
  end

  context 'without LA NAME in the session' do
    before do
      add_to_session(vrn: vrn, country: country, la_id: zone_id, charge: charge)
    end

    it_behaves_like 'la name is missing'
  end
end
