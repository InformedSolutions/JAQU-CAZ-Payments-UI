# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChargeableZonesService do
  subject(:service_call) { described_class.call(vehicle_details: vehicle_details) }

  let(:vehicle_details) do
    {
      'vrn' => vrn,
      'country' => country,
      'unrecognised' => unrecognised,
      'type' => type
    }
  end

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:unrecognised) { false }
  let(:type) { nil }

  context 'when zones are not chargeable' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_compliance)

      mock_non_chargeable_zones
      mock_vehicle_compliance
    end

    it 'calls ComplianceCheckerApi.clean_air_zones' do
      expect(ComplianceCheckerApi).to receive(:clean_air_zones)
      service_call
    end

    it 'does not call ComplianceCheckerApi.vehicle_compliance' do
      expect(ComplianceCheckerApi).not_to receive(:vehicle_compliance)
      service_call
    end

    it 'returns empty CAZes collection' do
      expect(service_call.length).to eq(0)
    end
  end

  context 'when zones are chargeable' do
    before { mock_chargeable_zones }

    context 'when country is UK' do
      context 'and charge price is more then zero for many CAZes' do
        before { mock_vehicle_compliance }

        it_behaves_like 'a chargeable zones service'

        it 'calls ComplianceCheckerApi.vehicle_compliance with the right params' do
          expect(ComplianceCheckerApi).to receive(:vehicle_compliance).with(vrn, mocked_zone_ids)
          service_call
        end
      end

      context 'and charge price is more then zero for one CAZ' do
        before { mock_private_car_compliance }

        it_behaves_like 'a chargeable zones service', 1
      end

      context 'and charge price equals to zero in all CAZes' do
        before { mock_vehicle_with_zero_charge }

        it 'returns zero caz zones' do
          expect(service_call).to be_empty
        end
      end
    end

    context 'when country is Non-UK' do
      let(:country) { 'Non-UK' }
      let(:type) { 'private_car' }
      let(:one_charge) { false }

      before do
        mock_chargeable_zones
        mock_unrecognised_compliance(one_charge)
      end

      it_behaves_like 'a chargeable zones service'

      it 'calls ComplianceCheckerApi.unrecognised_compliance with the right params' do
        expect(ComplianceCheckerApi)
          .to receive(:unrecognised_compliance)
          .with(type, mocked_zone_ids)
        service_call
      end

      context 'when charge for one CAZ equals 0' do
        let(:one_charge) { true }

        it_behaves_like 'a chargeable zones service', 1
      end
    end

    context 'when vehicle is unrecognised' do
      let(:unrecognised) { true }
      let(:type) { 'private_car' }

      before do
        mock_vehicle_compliance
        mock_unrecognised_compliance
      end

      it_behaves_like 'a chargeable zones service'

      it 'calls ComplianceCheckerApi.unrecognised_compliance with the right params' do
        expect(ComplianceCheckerApi)
          .to receive(:unrecognised_compliance)
          .with(type, mocked_zone_ids)
        service_call
      end
    end
  end
end
