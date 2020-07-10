# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_weekly_charge', type: :request do
  subject do
    post confirm_weekly_charge_dates_path, params: { 'confirm-exempt' => confirmation }
  end

  let(:confirmation) { 'yes' }

  context 'with details in the session' do
    before do
      add_details_to_session(weekly_possible: true)
      subject
    end

    context 'with checked checkbox' do
      it 'redirects to :dates' do
        expect(subject).to redirect_to(select_weekly_date_dates_path)
      end
    end

    context 'without checked checkbox' do
      let(:confirmation) { nil }

      it 'redirects to :weekly_charge' do
        expect(subject).to redirect_to(weekly_charge_dates_path)
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
