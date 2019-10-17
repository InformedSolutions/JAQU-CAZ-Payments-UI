# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - GET #daily_charge', type: :request do
  subject(:http_request) { get daily_charge_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:details) do
    instance_double(ComplianceDetails,
                    zone_name: 'Name',
                    charge: 5,
                    exemption_or_discount_url: 'www.wp.pl')
  end

  before do
    allow(ComplianceDetails)
      .to receive(:new)
      .with('vrn' => vrn, 'country' => country, 'la' => zone_id)
      .and_return(details)
  end

  context 'with VRN and LA in the session' do
    before do
      add_vrn_to_session(vrn: vrn, country: country)
      add_la_to_session(zone_id)
    end

    it 'call ComplianceDetails with right params' do
      expect(ComplianceDetails)
        .to receive(:new)
        .with('vrn' => vrn, 'country' => country, 'la' => zone_id)
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
      add_vrn_to_session(vrn: vrn, country: country)
    end

    it_behaves_like 'la is missing'
  end
end
