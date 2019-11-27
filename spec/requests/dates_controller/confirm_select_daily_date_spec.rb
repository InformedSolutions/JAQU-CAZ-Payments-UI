# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_daily_date', type: :request do
  subject(:http_request) do
    post confirm_daily_date_dates_path, params: dates
  end

  let(:dates) { { 'dates' => %w[2019-10-07 2019-10-10] } }
  let(:charge) { 12.5 }

  context 'with details in the session' do
    before do
      add_details_to_session(details: { daily_charge: charge })
    end

    context 'with checked dates' do
      it 'redirects to :review_payment' do
        expect(http_request).to redirect_to(review_payment_charges_path)
      end

      describe 'setting session' do
        before { http_request }

        it 'sets total_charge' do
          expect(session[:vehicle_details]['total_charge']).to eq(25)
        end

        it 'sets dates' do
          expect(session[:vehicle_details]['dates']).to eq(dates['dates'])
        end

        it 'sets weekly to false' do
          expect(session[:vehicle_details]['weekly']).to be_falsey
        end
      end
    end

    context 'without checked dates' do
      let(:dates) { nil }

      it 'redirects to :dates_charges' do
        expect(http_request).to redirect_to(select_daily_date_dates_path)
      end
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without details in the session' do
    before { add_vrn_to_session }

    it_behaves_like 'la is missing'
  end
end
