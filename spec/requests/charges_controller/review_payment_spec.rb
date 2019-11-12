# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - GET #review_payment', type: :request do
  subject(:http_request) { get review_payment_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:charge) { 50 }
  let(:la_name) { 'Leeds' }
  let(:session_data) do
    { vrn: vrn, la_id: zone_id, charge: charge, la_name: la_name, dates: [Date.current] }
  end

  context 'with VRN, COUNTRY, LA NAME, CHARGE and DATES in the session' do
    context 'with normal charge flow' do
      before do
        add_to_session(session_data)
        http_request
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns DatesController#daily_charge as return path' do
        expect(assigns(:return_path)).to eq(daily_charge_dates_path)
      end
    end

    context 'with Leeds charge flow' do
      before do
        add_to_session(session_data.merge(weekly_period: true))
        http_request
      end

      it 'assigns DatesController#weekly_charge as return path' do
        expect(assigns(:return_path)).to eq(weekly_charge_dates_path)
      end
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

  context 'without DATES in the session' do
    before do
      add_vrn_to_session
      add_la_to_session(zone_id: zone_id)
      add_daily_charge_to_session
    end

    it_behaves_like 'vehicle details is missing'
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
