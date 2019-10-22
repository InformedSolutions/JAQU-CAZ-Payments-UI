# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChargeableZonesService do
  subject(:service_call) { described_class.call(vrn: vrn, country: country) }

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }

  describe '#call' do
    before { mock_chargeable_zones }
    context 'when country is UK' do
      context 'and charge price more then zero' do
        before do
          mock_vehicle_compliance
        end

        let(:compliance_data) { read_file('vehicle_compliance_response.json') }

        it 'returns chargeable caz zones' do
          expect(service_call).to eq(compliance_data['complianceOutcomes'])
        end
      end

      context 'and charge price equals to zero' do
        before do
          mock_vehicle_with_zero_charge
        end

        it 'returns zero caz zones' do
          expect(service_call).to be_empty
        end
      end
    end

    context 'when country is Non-UK' do
      let(:country) { 'Non-UK' }

      before do
        mock_vehicle_compliance
      end

      it 'returns all caz zones' do
        expect(service_call).to eq(MockCazesForNonukResponse.new.response['complianceOutcomes'])
      end
    end
  end
end
