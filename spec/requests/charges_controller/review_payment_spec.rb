# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - GET #review_payment', type: :request do
  subject { get review_payment_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:charge) { 50 }
  let(:la_name) { 'Leeds' }
  let(:details) { {} }

  context 'with full payment details in the session' do
    context 'with normal charge flow' do
      before do
        add_full_payment_details(details: details)
        subject
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns DatesController#select_daily_date as return path' do
        expect(assigns(:return_path)).to eq(select_daily_date_dates_path)
      end

      describe 'details' do
        let(:dates) { %w[2019-11-01 2019-11-02] }
        let(:details) { { daily_charge: 12.5, dates: dates } }

        it 'assigns total_charge' do
          expect(assigns(:total_charge)).to eq(25)
        end

        it 'assigns dates' do
          expect(assigns(:dates)).to eq(dates)
        end

        it 'assigns weekly_period to false' do
          expect(assigns(:weekly_period)).to be_falsey
        end

        it 'assigns second_week_available' do
          expect(assigns(:second_week_available)).to be_falsey
        end
      end
    end

    context 'with Leeds charge flow' do
      before do
        caz_double = instance_double(Caz, active_charge_start_date: '2020-03-01')
        allow(FetchSingleCazData).to receive(:call).and_return(caz_double)
        allow(PaymentsApi).to receive(:paid_payments_dates).and_return([])
        add_full_payment_details(weekly: true)
        mock_chargeable_zones
        subject
      end

      it 'assigns DatesController#select_weekly_date as return path' do
        expect(assigns(:return_path)).to eq(select_weekly_date_dates_path)
      end

      it 'assigns weekly_period to true' do
        expect(assigns(:weekly_period)).to be_truthy
      end

      it 'assigns second_week_available' do
        expect(assigns(:second_week_available)).to be_truthy
      end
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without compliance details in the session' do
    before { add_vrn_to_session }

    it_behaves_like 'la is missing'
  end

  context 'without dates and total_charge in the session' do
    before { add_details_to_session }

    it_behaves_like 'vehicle details is missing'
  end
end
