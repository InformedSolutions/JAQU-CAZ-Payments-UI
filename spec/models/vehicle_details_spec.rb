# frozen_string_literal: true

require 'rails_helper'

describe VehicleDetails, type: :model do
  subject(:compliance) { described_class.new(vrn) }

  let(:vrn) { 'CU57ABC' }
  let(:type_approval) { 'M1' }
  let(:taxi_or_phv) { false }
  let(:type) { 'car' }
  let(:las) { %w[Leeds Birmingham] }
  let(:fuel_type) { 'diesel' }

  let(:response) do
    {
      'registration_number' => vrn,
      'typeApproval' => type_approval,
      'type' => type,
      'make' => 'peugeot',
      'model' => '208',
      'colour' => 'grey',
      'fuelType' => fuel_type,
      'taxiOrPhv' => taxi_or_phv,
      'licensingAuthoritiesNames' => las
    }
  end

  let(:date_of_first_registration) { '2020-03' }
  let(:euro_status) { 'EURO V' }

  let(:external_details_response) do
    {
      'colour' => 'grey',
      'dateOfFirstRegistration' => date_of_first_registration,
      'euroStatus' => euro_status,
      'fuelType' => 'diesel',
      'make' => 'Hyundai',
      'typeApproval' => 'M1',
      'revenueWeight' => 3650,
      'bodyType' => 'car',
      'model' => 'i20',
      'unladenWeight' => 3000,
      'seatingCapacity' => 5,
      'standingCapacity' => 6,
      'taxClass' => 'SPECIAL VEHICLE'
    }
  end

  before do
    allow(ComplianceCheckerApi).to receive(:vehicle_details).with(vrn).and_return(response)
    allow(VehiclesCheckerApi).to receive(:external_details).with(vrn).and_return(external_details_response)
  end

  describe '.registration_number' do
    it 'returns a proper registration number' do
      expect(subject.registration_number).to eq(vrn)
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

  describe '.exempt?' do
    describe 'when key is not present' do
      it 'returns a nil' do
        expect(subject.exempt?).to eq(nil)
      end
    end

    describe 'when key is present' do
      before do
        allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return('exempt' => true)
      end

      it 'returns a true' do
        expect(subject.exempt?).to eq(true)
      end
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
        allow(ComplianceCheckerApi).to receive(:vehicle_details).with(vrn).and_return({})
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
      expect(subject.undetermined?).to eq(false)
    end

    context 'when key is not present' do
      before do
        allow(ComplianceCheckerApi).to receive(:vehicle_details).with(vrn).and_return({})
      end

      it 'returns a nil' do
        expect(compliance.undetermined?).to eq(true)
      end
    end

    context 'when value is empty' do
      let(:type) { ' ' }

      it 'returns a nil' do
        expect(compliance.undetermined?).to eq(true)
      end
    end

    context "when value is equal to 'null'" do
      let(:type) { 'null' }

      it 'returns a nil' do
        expect(compliance.undetermined?).to eq(true)
      end
    end
  end

  describe '.undetermined_taxi?' do
    context 'when vehicle is a taxi' do
      let(:taxi_or_phv) { true }

      context 'and it does not have a fuel type' do
        let(:fuel_type) { nil }

        it 'returns true' do
          expect(compliance.undetermined_taxi?).to eq(true)
        end
      end

      context 'and it does not have a vehicle type' do
        let(:type) { nil }

        it 'returns true' do
          expect(compliance.undetermined_taxi?).to eq(true)
        end
      end

      context 'and it does not have dateoffirstregistration and eurostatus' do
        let(:date_of_first_registration) { nil }
        let(:euro_status) { nil }

        it 'returns true' do
          expect(compliance.undetermined_taxi?).to eq(true)
        end
      end

      context 'when VehiclesCheckerApi.external_details throws an error' do
        before do
          allow(VehiclesCheckerApi)
            .to receive(:external_details)
            .and_raise(BaseApi::Error404Exception.new(404, '', {}))
        end

        it 'returns true' do
          expect(compliance.undetermined_taxi?).to eq(true)
        end
      end
    end

    context 'whet vehicle is not a taxi' do
      let(:taxi_or_phv) { false }

      it 'returns false' do
        expect(compliance.undetermined_taxi?).to eq(false)
      end
    end
  end

  describe '.leeds_taxi?' do
    subject(:taxi) { compliance.leeds_taxi? }

    context 'when Leeds is in licensingAuthoritiesNames' do
      it { is_expected.to be_truthy }
    end

    context 'when Leeds is NOT in licensingAuthoritiesNames' do
      let(:las) { %w[Birmingham London] }

      it { is_expected.to be_falsey }
    end

    context 'when licensingAuthoritiesNames is empty' do
      let(:las) { [] }

      it { is_expected.to be_falsey }
    end

    context 'when licensingAuthoritiesNames is nil' do
      let(:las) { nil }

      it { is_expected.to be_falsey }
    end
  end
end
