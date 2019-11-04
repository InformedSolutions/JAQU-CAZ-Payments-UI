# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_weekly_charge', type: :request do
  subject(:http_request) do
    post confirm_weekly_charge_dates_path, params: { 'confirm-exempt' => confirmation }
  end

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:confirmation) { 'yes' }

  context 'with VRN, LA, LA NAME and CHARGE in the session' do
    before do
      add_to_session(vrn: vrn, la_id: zone_id, charge: 50, la_name: 'Leeds')
      http_request
    end

    context 'with checked checkbox' do
      it 'redirects to :dates' do
        expect(http_request).to redirect_to(select_weekly_date_dates_path)
      end
    end

    context 'without checked checkbox' do
      let(:confirmation) { nil }

      it 'redirects to :weekly_charge' do
        expect(http_request).to redirect_to(weekly_charge_dates_path)
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
