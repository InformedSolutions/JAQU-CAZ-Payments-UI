# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_select_period', type: :request do
  subject(:http_request) do
    post confirm_select_period_dates_path, params: { 'period' => period }
  end

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:period) { 'daily-charge' }

  context 'with VRN an LA in the session' do
    before do
      add_vrn_to_session(vrn: vrn)
      add_la_to_session(zone_id: zone_id)
      http_request
    end

    context 'with selected radio' do
      context 'when selected daily charge' do
        it 'redirects to daily charge page' do
          expect(response).to redirect_to(daily_charge_dates_path)
        end
      end

      context 'when selected weekly charge' do
        let(:period) { 'weekly-charge' }

        it 'redirects to weekly charge page' do
          expect(response).to redirect_to(weekly_charge_dates_path)
        end
      end
    end

    context 'without selected radio' do
      let(:period) { nil }

      it 'redirects to :select_period' do
        expect(http_request).to redirect_to(select_period_dates_path)
      end
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before do
      add_vrn_to_session(vrn: vrn)
    end

    it_behaves_like 'la is missing'
  end
end
