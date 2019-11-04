# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #select_date_weekly', type: :request do
  subject(:http_request) { get select_weekly_date_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:charge) { 50 }
  let(:la_name) { 'Leeds' }

  context 'with VRN, COUNTRY, LA, LA NAME and CHARGE in the session' do
    before do
      add_to_session(vrn: vrn, country: country, la_id: zone_id, charge: charge, la_name: la_name)
      http_request
    end

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before do
      add_to_session(vrn: vrn, country: country, charge: charge, la_name: la_name)
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
