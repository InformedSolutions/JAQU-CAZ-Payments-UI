# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - POST #confirm_select_weekly_period', type: :request do
  subject { post select_weekly_period_dates_path, params: params }

  let(:params) { { 'confirm_weekly_charge_today' => confirm_weekly_charge_today } }
  let(:confirm_weekly_charge_today) { 'true' }
  let(:transaction_id) { SecureRandom.uuid }

  context 'with details in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_details_to_session(
        weekly_possible: true,
        weekly_charge_today: true,
        dates: [Date.current.strftime(Dates::Weekly::VALUE_DATE_FORMAT)]
      )
    end

    context 'when confirmation is true' do
      it 'redirects to :review_payment page' do
        expect(subject).to redirect_to(review_payment_charges_path(id: transaction_id))
      end

      it 'calls Dates::AssignBackButtonDate' do
        expect(Dates::AssignBackButtonDate).to receive(:call)
        subject
      end

      it 'calls SessionManipulation::SetSelectedWeek' do
        expect(SessionManipulation::SetSelectedWeek).to receive(:call)
        subject
      end

      it 'calls SessionManipulation::CalculateTotalCharge' do
        expect(SessionManipulation::CalculateTotalCharge).to receive(:call)
        subject
      end

      describe 'setting session' do
        before { subject }

        it 'sets total_charge' do
          expect(session[:vehicle_details]['total_charge']).to eq(50)
        end
      end
    end

    context 'when confirmation is false' do
      let(:confirm_weekly_charge_today) { 'false' }

      it 'redirects to :select_weekly_date page' do
        expect(subject).to redirect_to(select_weekly_date_dates_path(id: transaction_id))
      end

      it 'calls Dates::AssignBackButtonDate' do
        expect(Dates::AssignBackButtonDate).to receive(:call)
        subject
      end
    end

    context 'when confirmation is nil' do
      let(:confirm_weekly_charge_today) { nil }

      it 'renders the view' do
        expect(subject).to render_template(:select_weekly_period)
      end
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without details in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vrn_to_session
    end

    it_behaves_like 'la is missing'
  end
end
