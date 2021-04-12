# frozen_string_literal: true

require 'rails_helper'

describe UnrecognisedComplianceDetails, type: :model do
  subject(:details) { described_class.new(la_id: la_id) }

  let(:la_id) { '7d0c4240-1618-446b-bde2-2f3458c8a521' }
  let(:api_response) do
    {
      'charges' =>
        [
          {
            'cleanAirZoneId' => '7d0c4240-1618-446b-bde2-2f3458c8a521',
            'name' => 'Taxidiscountcaz',
            'charge' => 9.0,
            'tariffCode' => 'BAT01-TAXI_OR_PHV',
            'informationUrls' => {
              'mainInfo' => 'www.sample-main-info-link.com',
              'exemptionOrDiscount' => 'www.sample-exemption-link.com',
              'becomeCompliant' => 'www.sample-compliant-link.com',
              'boundary' => 'www.sample-boundary-link.com',
              'additionalInfo' => 'www.sample-info-link.com',
              'publicTransportOptions' => 'www.sample-public-link.com'
            },
            'operatorName' => nil
          }
        ]
    }
  end

  before do
    allow(ComplianceCheckerApi).to receive(:unrecognised_compliance)
      .and_return(api_response)
  end

  describe '.zone_name' do
    it 'returns proper value' do
      expect(details.zone_name).to eq('Taxidiscountcaz')
    end
  end

  describe '.charge' do
    it 'returns proper value' do
      expect(details.charge).to eq(9.0)
    end
  end

  describe '.tariff_code' do
    it 'returns proper value' do
      expect(details.tariff_code).to eq('BAT01-TAXI_OR_PHV')
    end
  end

  describe '.main_info_url' do
    it 'returns proper value' do
      expect(details.main_info_url).to eq('www.sample-main-info-link.com')
    end
  end

  describe '.exemption_or_discount_url' do
    it 'returns proper value' do
      expect(details.exemption_or_discount_url).to eq('www.sample-exemption-link.com')
    end
  end

  describe '.compliance_url' do
    it 'returns proper value' do
      expect(details.compliance_url).to eq('www.sample-compliant-link.com')
    end
  end

  describe '.public_transport_options_url' do
    it 'returns proper value' do
      expect(details.public_transport_options_url).to eq('www.sample-public-link.com')
    end
  end

  describe '.dynamic_compliance_url' do
    it 'returns proper value' do
      expect(details.dynamic_compliance_url).to eq('www.sample-compliant-link.com')
    end
  end
end
