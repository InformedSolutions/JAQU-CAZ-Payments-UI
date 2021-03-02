# frozen_string_literal: true

require 'rails_helper'

describe 'ChargesController - GET #review_payment', type: :request do
  subject { get review_payment_charges_path, params: params }

  let(:params) { nil }
  let(:transaction_id) { SecureRandom.uuid }
  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:charge) { 50 }
  let(:la_name) { 'Taxidiscountcaz' }
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

    context 'with Taxidiscountcaz charge flow' do
      before do
        caz_double = instance_double(Caz, active_charge_start_date: '2020-03-01')
        allow(FetchSingleCazData).to receive(:call).and_return(caz_double)
        allow(PaymentsApi).to receive(:paid_payments_dates).and_return([])
        mock_chargeable_zones
        add_full_payment_details(weekly: true)
      end

      context 'when last visited page was select weekly date page' do
        before { subject }

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

      context 'when last visited page was select weekly period page' do
        before do
          add_full_payment_details(weekly: true, confirm_weekly_charge_today: true)
          subject
        end

        it 'assigns return_path variable' do
          expect(assigns(:return_path)).to eq(select_weekly_period_dates_path)
        end
      end

      context 'when last visited page was select second weekly date page' do
        before do
          add_to_session(second_week_start_date: '2020-05-01')
          subject
        end

        it 'assigns return_path variable' do
          expect(assigns(:return_path)).to eq(select_second_weekly_date_dates_path)
        end
      end

      context 'when cancel_second_week params is true' do
        let(:params) { { cancel_second_week: 'true' } }

        before do
          allow(SessionManipulation::CalculateTotalCharge).to receive(:call).and_return(true)
          add_to_session({ first_week_start_date: '2020-05-01' })
        end

        it 'sets second_week_selected in the session' do
          subject
          expect(session[:second_week_selected]).to be_falsey
        end

        it 'calls SessionManipulation::CalculateTotalCharge' do
          subject
          expect(SessionManipulation::CalculateTotalCharge).to have_received(:call)
        end
      end
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without compliance details in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vrn_to_session
    end

    it_behaves_like 'la is missing'
  end

  context 'without dates and total_charge in the session' do
    before { add_details_to_session }

    it_behaves_like 'vehicle details is missing'
  end
end
