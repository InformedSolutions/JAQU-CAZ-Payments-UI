# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComplianceDetails, type: :model do
  subject(:details) { described_class.new(vehicle_details) }

  let(:vehicle_details) do
    {
      'vrn' => vrn,
      'country' => country,
      'la_id' => zone_id,
      'unrecognised' => unrecognised,
      'type' => type
    }
  end

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:unrecognised) { false }
  let(:type) { 'private_car' }
  let(:tariff) { 'BCC01-private_car' }
  let(:charge) { 15 }

  let(:outcomes) do
    [
      {
        'name' => name,
        'charge' => charge,
        'tariffCode' => tariff,
        'informationUrls' => {
          'exemptionOrDiscount' => url,
          'becomeCompliant' => url
        }
      }
    ]
  end
  let(:name) { 'Leeds' }
  let(:url) { 'www.wp.pl' }

  let(:unrecognised_response) do
    {
      'charges' =>
      [
        {
          'cleanAirZoneId' => '39e54ed8-3ed2-441d-be3f-38fc9b70c8d3',
          'name' => name,
          'tariffCode' => tariff,
          'charge' => charge
        }
      ]
    }
  end

  context 'when the vehicle is registered in the UK' do
    before do
      allow(ComplianceCheckerApi)
        .to receive(:vehicle_compliance)
        .with(vrn, [zone_id])
        .and_return('complianceOutcomes' => outcomes)
    end

    it 'calls :vehicle_compliance with right params' do
      expect(ComplianceCheckerApi).to receive(:vehicle_compliance).with(vrn, [zone_id])
      details.zone_name
    end

    it_behaves_like 'compliance details fields'

    describe '.exemption_or_discount_url' do
      it 'returns URL' do
        expect(details.exemption_or_discount_url).to eq(url)
      end
    end

    describe '.compliance_url' do
      it 'returns URL' do
        expect(details.compliance_url).to eq(url)
      end
    end

    context 'when vehicle is unrecognised' do
      let(:unrecognised) { true }

      before do
        allow(ComplianceCheckerApi)
          .to receive(:unrecognised_compliance)
          .with(type, [zone_id])
          .and_return(unrecognised_response)
      end

      it 'calls :unrecognised_compliance with right params' do
        expect(ComplianceCheckerApi)
          .to receive(:unrecognised_compliance)
          .with(type, [zone_id])
        details.zone_name
      end

      it 'does not call :vehicle_compliance' do
        expect(ComplianceCheckerApi).not_to receive(:vehicle_compliance)
        details.zone_name
      end

      it_behaves_like 'compliance details fields'
    end
  end

  context 'when the vehicle is registered outside of the UK' do
    let(:country) { 'non-UK' }

    before do
      allow(ComplianceCheckerApi)
        .to receive(:unrecognised_compliance)
        .with(type, [zone_id])
        .and_return(unrecognised_response)
    end

    it 'calls :unrecognised_compliance with right params' do
      expect(ComplianceCheckerApi)
        .to receive(:unrecognised_compliance)
        .with(type, [zone_id])
      details.zone_name
    end

    it_behaves_like 'compliance details fields'
  end
end
