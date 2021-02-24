# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetUnrecognisedCompliance do
  subject { described_class.call(session: session, la_id: la_id) }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => 'CU123AB', 'country' => 'UK' } }
  let(:la_id) { SecureRandom.uuid }
  let(:la_name) { 'Bath' }
  let(:daily_charge) { 9.0 }
  let(:tariff) { 'BCC01-private_car' }

  before do
    details = instance_double('UnrecognisedComplianceDetails',
                              zone_name: la_name,
                              charge: daily_charge,
                              tariff_code: tariff)
    allow(UnrecognisedComplianceDetails).to receive(:new).and_return(details)
  end

  it 'creates instance of ComplianceDetails with right params' do
    subject
    expect(UnrecognisedComplianceDetails).to have_received(:new).with(la_id: la_id)
  end

  describe 'adding fields' do
    before { subject }

    it 'sets la_id' do
      expect(session[:vehicle_details]['la_id']).to eq(la_id)
    end

    it 'sets la_name' do
      expect(session[:vehicle_details]['la_name']).to eq(la_name)
    end

    it 'sets daily_charge' do
      expect(session[:vehicle_details]['daily_charge']).to eq(daily_charge)
    end

    it 'sets tariff_code' do
      expect(session[:vehicle_details]['tariff_code']).to eq(tariff)
    end

    context 'when there are more details in session' do
      let(:session) do
        { vehicle_details: details.merge('dates' => ['2019-11-11']) }
      end

      it 'clears keys from next steps' do
        expect(session[:vehicle_details].keys).to contain_exactly(
          'vrn', 'country', 'la_id', 'la_name', 'daily_charge', 'tariff_code'
        )
      end
    end
  end
end
