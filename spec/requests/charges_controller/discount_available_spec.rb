# frozen_string_literal: true

require 'rails_helper'

describe 'ChargesController - GET #review_payment', type: :request do
  subject { get discount_available_charges_path, params: params }

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
        add_transaction_id_to_session(transaction_id)
        add_full_payment_details(details: details)
        subject
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns DatesController#select_daily_date as next_url path' do
        expect(assigns(:next_url)).to eq(daily_charge_dates_path(id: transaction_id))
      end
    end

    context 'with Taxidiscountcaz charge flow' do
      before do
        add_transaction_id_to_session(transaction_id)
        add_full_payment_details(weekly: true)
      end

      context 'when last visited page was select weekly date page' do
        before { subject }

        it 'assigns DatesController#select_weekly_date as next_url path' do
          expect(assigns(:next_url)).to eq(select_period_dates_path(id: transaction_id))
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
end
