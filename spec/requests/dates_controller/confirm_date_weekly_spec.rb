# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_date_weekly', type: :request do
  subject(:http_request) do
    post confirm_date_weekly_charges_path,
         params:
           {
             'dates' => ['2019-11-08']
           }
  end

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:charge) { 50 }
  let(:la_name) { 'Leeds' }

  context 'with VRN, COUNTRY, LA, LA NAME and CHARGE in the session' do
    before do
      add_to_session(vrn: vrn, country: country, la: zone_id, charge: charge, la_name: la_name)
      http_request
    end

    it 'redirects to :review_payment' do
      expect(http_request).to redirect_to(review_payment_charges_path)
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

  context 'without charge in the session' do
    before do
      add_to_session(vrn: vrn, country: country, la: zone_id, la_name: la_name)
    end

    it_behaves_like 'charge is missing'
  end

  context 'without la name in the session' do
    before do
      add_to_session(vrn: vrn, country: country, la: zone_id, charge: charge)
    end

    it_behaves_like 'la name is missing'
  end
end
