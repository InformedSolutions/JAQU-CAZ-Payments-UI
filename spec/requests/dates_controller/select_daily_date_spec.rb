# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - GET #select_daily_date', type: :request do
  subject { get select_daily_date_dates_path }

  let(:transaction_id) { SecureRandom.uuid }

  context 'with VRN in the session' do
    before do
      add_details_to_session
      allow(PaymentsApi).to receive(:paid_payments_dates).and_return([])
      stubbed_caz = instance_double('Caz', active_charge_start_date: '2020-05-01')
      allow(FetchSingleCazData).to receive(:call).and_return(stubbed_caz)
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'calls FetchSingleCazData service' do
      expect(FetchSingleCazData).to have_received(:call)
    end

    it 'assigns the @d_day_notice' do
      expect(assigns(:d_day_notice)).to eq(false)
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
end
