# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - GET #daily_charge', type: :request do
  subject(:http_request) { get daily_charge_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:details) do
    instance_double(ComplianceDetails,
                    zone_name: 'Name',
                    charge: '£5.00',
                    exemption_or_discount_url: 'www.wp.pl')
  end

  context 'with VRN in the session' do
    before do
      allow(ComplianceDetails)
        .to receive(:new)
        .with(vrn, zone_id)
        .and_return(details)
      add_vrn_to_session(vrn: vrn)
      add_la_to_session(zone_id)
      http_request
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end
end
