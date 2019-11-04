# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_daily_charge', type: :request do
  subject(:http_request) do
    post confirm_daily_charge_dates_path, params: { 'confirm-exempt' => confirmation }
  end

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:la_name) { 'Leeds' }
  let(:charge) { 12.50 }
  let(:confirmation) { 'yes' }

  context 'with VRN, COUNTRY, LA, LA NAME and CHARGE in the session' do
    before do
      add_to_session(vrn: vrn, la_id: zone_id, charge: charge, la_name: la_name)
    end

    context 'with checked checkbox' do
      it 'redirects to :dates' do
        expect(http_request).to redirect_to(select_daily_date_dates_path)
      end
    end

    context 'without checked checkbox' do
      let(:confirmation) { nil }

      it 'redirects to :daily_charge' do
        expect(http_request).to redirect_to(daily_charge_dates_path)
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

  context 'without CHARGE in the session' do
    before do
      add_to_session(vrn: vrn, country: country, la_id: zone_id, la_name: la_name)
    end

    it_behaves_like 'charge is missing'
  end

  context 'without LA NAME in the session' do
    before do
      add_to_session(vrn: vrn, country: country, la_id: zone_id, charge: charge)
    end

    it_behaves_like 'la name is missing'
  end
end
