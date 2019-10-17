# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComplianceDetails, type: :model do
  subject(:details) { described_class.new(vehicle_details, zone_id) }

  let(:vehicle_details) { { 'vrn' => vrn, 'country' => country } }
  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }

  let(:outcomes) do
    [{ 'name' => name, 'charge' => 5, 'urls' => { 'exemptionOrDiscount' => url } }]
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
        expect(details.zone_name).to eq(name)
      end
    end
  end

  context 'when the vehicle is registered outside of the UK' do
    let(:vehicle_details) { { 'vrn' => vrn, 'country' => country, 'type' => type } }
    let(:country) { 'non-UK' }
    let(:type) { 'Car' }

    before do
      allow(ComplianceCheckerApi)
        .to receive(:non_uk_vehicle_compliance)
        .with(vrn, [zone_id], type)
        .and_return('complianceOutcomes' => outcomes)
    end

    it 'calls :non_uk_vehicle_compliance with right params' do
      expect(ComplianceCheckerApi)
        .to receive(:non_uk_vehicle_compliance)
        .with(vrn, [zone_id], type)
      details.zone_name
    end
  end
end
