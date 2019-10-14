# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - GET #review_payment', type: :request do
  subject(:http_request) { get review_payment_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:details) do
    instance_double(ComplianceDetails,
                    zone_name: 'Name',
                    charge: '£5.00',
                    exemption_or_discount_url: 'www.wp.pl')
  end

  before do
    allow(ComplianceDetails)
      .to receive(:new)
      .with(vrn, zone_id)
      .and_return(details)
  end

  context 'with VRN, LA and DATES in the session' do
    before do
      add_vrn_to_session(vrn: vrn)
      add_la_to_session(zone_id)
      add_dates_to_session
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
    before do
      add_vrn_to_session(vrn: vrn)
    end

    it_behaves_like 'la is missing'
  end

  context 'without DATES in the session' do
    before do
      add_vrn_to_session(vrn: vrn)
      add_la_to_session(zone_id)
    end

    it_behaves_like 'dates is missing'
  end
end
