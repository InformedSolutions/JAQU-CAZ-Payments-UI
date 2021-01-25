# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - POST #confirm_daily_charge', type: :request do
  subject do
    post confirm_daily_charge_dates_path, params: { 'confirm-exempt' => confirmation }
  end

  let(:transaction_id) { SecureRandom.uuid }
  let(:confirmation) { 'yes' }

  context 'with details in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_details_to_session
    end

    context 'with checked checkbox' do
      it 'redirects to :dates' do
        expect(subject).to redirect_to(select_daily_date_dates_path(id: transaction_id))
      end
    end

    context 'without checked checkbox' do
      let(:confirmation) { nil }

      it 'redirects to :daily_charge' do
        expect(subject).to redirect_to(daily_charge_dates_path(id: transaction_id))
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
