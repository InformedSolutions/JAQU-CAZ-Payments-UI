# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #select_weekly_date', type: :request do
  subject(:http_request) { get select_weekly_date_dates_path }

  context 'with VRN, COUNTRY, LA, LA NAME and CHARGE in the session' do
    before do
      add_details_to_session(weekly_possible: true)
      allow(PaymentsApi).to receive(:paid_payments_dates).and_return([])
      stubbed_caz = instance_double('Caz', active_charge_start_date: '2020-05-01')
      allow(FetchSingleCazData).to receive(:call).and_return(stubbed_caz)
      http_request
    end

    it 'returns a success response' do
      http_request
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

  context 'without details in the session' do
    before { add_vrn_to_session }

    it_behaves_like 'la is missing'
  end

  context 'when Leeds weekly discount is NOT possible' do
    it_behaves_like 'not allowed Leeds discount'
  end
end
