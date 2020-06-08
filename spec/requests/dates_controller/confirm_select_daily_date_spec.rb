# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_daily_date', type: :request do
  subject do
    post confirm_daily_date_dates_path, params: params
  end

  let(:params) { { 'dates' => %w[2019-10-07 2019-10-10] } }
  let(:charge) { 12.5 }
  let(:vrn) { 'CU123AB' }
  let(:la_id) { SecureRandom.uuid }

  context 'with details in the session' do
    before do
      add_details_to_session(details: { daily_charge: charge, vrn: vrn, la_id: la_id })
      allow(Dates::CheckPaidDaily).to receive(:call).and_return(true)
    end

    context 'with checked dates' do
      it 'redirects to :review_payment' do
        expect(subject).to redirect_to(review_payment_charges_path)
      end

      it 'calls Dates::CheckPaidDaily with proper params' do
        expect(Dates::CheckPaidDaily)
          .to receive(:call)
          .with(vrn: vrn, zone_id: la_id, dates: params['dates'])
        subject
      end

      describe 'setting session' do
        before { subject }

        it 'sets total_charge' do
          expect(session[:vehicle_details]['total_charge']).to eq(25)
        end

        it 'sets dates' do
          expect(session[:vehicle_details]['dates']).to eq(params['dates'])
        end

        it 'sets weekly to false' do
          expect(session[:vehicle_details]['weekly']).to be_falsey
        end
      end

      context 'when dates are already paid' do
        before do
          allow(Dates::CheckPaidDaily).to receive(:call).and_return(false)
        end

        it 'redirects to :dates_charges' do
          expect(subject).to redirect_to(select_daily_date_dates_path)
        end
      end
    end

    context 'without checked dates' do
      let(:params) { nil }

      it 'redirects to :dates_charges' do
        expect(subject).to redirect_to(select_daily_date_dates_path)
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
