# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_select_period', type: :request do
  subject do
    post confirm_select_period_dates_path, params: { 'period' => period }
  end
  let(:period) { 'daily-charge' }

  context 'when Leeds weekly discount is possible' do
    before do
      add_details_to_session(weekly_possible: true)
      subject
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
        expect(subject).to redirect_to(select_period_dates_path)
      end
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before { add_vrn_to_session }

    it_behaves_like 'la is missing'
  end

  context 'when Leeds weekly discount is NOT possible' do
    it_behaves_like 'not allowed Leeds discount'
  end
end
