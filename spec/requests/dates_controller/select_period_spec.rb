# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #select_period', type: :request do
  subject(:http_request) { get select_period_dates_path }

  context 'with VRN and LA in the session' do
    context 'when Leeds weekly discount is possible' do
      before { add_details_to_session(weekly_possible: true) }

      it 'returns a success response' do
        http_request
        expect(response).to have_http_status(:success)
      end
    end

    context 'when Leeds weekly discount is NOT possible' do
      it_behaves_like 'not allowed Leeds discount'
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before do
      add_vrn_to_session
    end

    it_behaves_like 'la is missing'
  end
end
