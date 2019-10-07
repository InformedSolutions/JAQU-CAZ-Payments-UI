# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehicleDetails, type: :model do
  subject(:compliance) { described_class.new(vrn) }

  let(:vrn) { 'CU57ABC' }
  let(:type_approval) { 'M1' }
  let(:taxi_or_phv) { false }
  let(:type) { 'car' }

  let(:response) do
    {
      'registration_number' => vrn,
      'typeApproval' => type_approval,
      'type' => type,
      'make' => 'peugeot',
      'model' => '208',
      'colour' => 'grey',
      'fuelType' => 'diesel',
      'taxiOrPhv' => taxi_or_phv
    }
  end

  before do
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(response)
  end

  describe '.registration_number' do
    it 'returns a proper registration number' do
      expect(subject.registration_number).to eq(vrn)
    end
  end

  describe '.vrn_for_request' do
    before do
      allow(VrnParser).to receive(:call).and_return(vrn)
    end

    it 'returns a proper vrn' do
      expect(subject.vrn_for_request).to eq(vrn)
    end
  end

  describe '.make' do
    it 'returns a proper type' do
      expect(subject.make).to eq('Peugeot')
    end
  end

  describe '.type' do
    it 'returns a proper type' do
      expect(subject.type).to eq('Car')
    end
  end

  describe '.colour' do
    it 'returns a proper colour' do
      expect(subject.colour).to eq('Grey')
    end
  end

  describe '.fuel_type' do
    it 'returns a proper fuel type' do
      expect(subject.fuel_type).to eq('Diesel')
    end
  end

  describe '.taxi_private_hire_vehicle' do
    describe 'when taxi_or_phv value is false' do
      it "returns a 'No'" do
        expect(subject.taxi_private_hire_vehicle).to eq('No')
      end
    end

    describe 'when taxi_or_phv value is true' do
      let(:taxi_or_phv) { true }

      it "returns a 'Yes'" do
        expect(subject.taxi_private_hire_vehicle).to eq('Yes')
      end
    end
  end

  describe '.type_approval' do
    it 'returns a proper type approval' do
      expect(subject.type_approval).to eq('M1')
    end

    context 'when key is not present' do
      before do
        allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return({})
      end

      it 'returns a nil' do
        expect(compliance.type_approval).to eq(nil)
      end
    end

    context 'when value is empty' do
      let(:type_approval) { ' ' }

      it 'returns a nil' do
        expect(compliance.type_approval).to eq(nil)
      end
    end

    context "when value is equal to 'null'" do
      let(:type_approval) { 'null' }

      it 'returns a nil' do
        expect(compliance.type_approval).to eq(nil)
      end
    end
  end

  describe '.model' do
    it 'returns a proper model' do
      expect(subject.model).to eq('208')
    end
  end

  describe '.undetermined?' do
    it 'returns a proper type approval' do
      expect(subject.undetermined?).to eq('false')
    end

    context 'when key is not present' do
      before do
        allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return({})
      end

      it 'returns a nil' do
        expect(compliance.undetermined?).to eq('true')
      end
    end

    context 'when value is empty' do
      let(:type) { ' ' }

      it 'returns a nil' do
        expect(compliance.undetermined?).to eq('true')
      end
    end

    context "when value is equal to 'null'" do
      let(:type) { 'null' }

      it 'returns a nil' do
        expect(compliance.undetermined?).to eq('true')
      end
    end
  end
end
