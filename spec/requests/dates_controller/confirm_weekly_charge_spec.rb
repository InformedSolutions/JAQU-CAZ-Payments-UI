# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - POST #confirm_weekly_charge', type: :request do
  subject do
    post confirm_weekly_charge_dates_path, params: { 'confirm-exempt' => confirmation }
  end

  let(:transaction_id) { SecureRandom.uuid }
  let(:confirmation) { 'yes' }

  context 'with details in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_details_to_session(weekly_possible: true)
      subject
    end

    context 'with checked checkbox' do
      it 'redirects to :dates' do
        expect(subject).to redirect_to(select_weekly_date_dates_path(id: transaction_id))
      end
    end

    context 'without checked checkbox' do
      let(:confirmation) { nil }

      it 'redirects to :weekly_charge' do
        expect(subject).to redirect_to(weekly_charge_dates_path(id: transaction_id))
      end
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vrn_to_session
    end

    it_behaves_like 'la is missing'
  end

  context 'when Taxidiscountcaz discount is NOT possible' do
    it_behaves_like 'not allowed Taxidiscountcaz discount'
  end
end
