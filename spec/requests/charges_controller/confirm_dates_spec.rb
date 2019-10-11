# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - POST #confirm_dates', type: :request do
  subject(:http_request) do
    post confirm_dates_charges_path, params: dates
  end

  let(:dates) { { 'dates' => %w[2019-10-07 2019-10-10] } }
  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }

  context 'with VRN in the session' do
    before do
      add_vrn_to_session(vrn: vrn)
      add_la_to_session(zone_id)
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
        expect(http_request).to redirect_to(dates_charges_path)
      end
    end

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end
  end

  context 'without VRN in the session' do
    it 'redirects to :enter_details' do
      expect(http_request).to redirect_to(enter_details_vehicles_path)
    end
  end
end
