# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #select_daily_date', type: :request do
  subject(:http_request) { get select_daily_date_dates_path }

  context 'with VRN in the session' do
    before do
      add_details_to_session
      allow(PaymentsApi).to receive(:paid_payments_dates).and_return([])
      http_request
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before { add_vrn_to_session }

    it_behaves_like 'la is missing'
  end
end
