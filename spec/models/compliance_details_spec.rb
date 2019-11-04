# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComplianceDetails, type: :model do
  subject(:details) { described_class.new(vehicle_details) }

  let(:vehicle_details) { { 'vrn' => vrn, 'country' => country, 'la_id' => zone_id } }
  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }

  let(:outcomes) do
    [
      {
        'name' => name,
        'charge' => 5,
        'informationUrls' => {
          'exemptionOrDiscount' => url,
          'becomeCompliant' => url
        }
      }
    ]
  end
  let(:name) { 'Leeds' }
  let(:url) { 'www.wp.pl' }

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

    describe '.zone_name' do
      it 'returns CAZ name' do
        expect(details.zone_name).to eq(name)
      end
    end

    describe '.charge' do
      it 'returns charge value' do
        expect(details.charge).to eq(5)
      end
    end

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
      let(:vehicle_details) do
        { 'vrn' => vrn, 'country' => country, 'la_id' => zone_id, 'unrecognised' => true }
      end

      before do
        allow(ComplianceCheckerApi)
          .to receive(:non_dvla_vehicle_compliance)
          .with(vrn, [zone_id], nil)
          .and_return('complianceOutcomes' => outcomes)
      end

      it 'calls :non_dvla_vehicle_compliance with right params' do
        expect(ComplianceCheckerApi)
          .to receive(:non_dvla_vehicle_compliance)
          .with(vrn, [zone_id], nil)
        details.zone_name
      end

      it 'does not call :vehicle_compliance' do
        expect(ComplianceCheckerApi).not_to receive(:vehicle_compliance)
        details.zone_name
      end
    end
  end

  context 'when the vehicle is registered outside of the UK' do
    let(:vehicle_details) do
      { 'vrn' => vrn, 'country' => country, 'la_id' => zone_id, 'type' => type }
    end
    let(:country) { 'non-UK' }
    let(:type) { 'Car' }

    before do
      allow(ComplianceCheckerApi)
        .to receive(:non_dvla_vehicle_compliance)
        .with(vrn, [zone_id], type)
        .and_return('complianceOutcomes' => outcomes)
    end

    it 'calls :non_dvla_vehicle_compliance with right params' do
      expect(ComplianceCheckerApi)
        .to receive(:non_dvla_vehicle_compliance)
        .with(vrn, [zone_id], type)
      details.zone_name
    end
  end
end
