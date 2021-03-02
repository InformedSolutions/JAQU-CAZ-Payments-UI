# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetComplianceDetails do
  subject { described_class.call(session: session, la_id: la_id) }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => 'CU123AB', 'country' => 'UK' } }
  let(:la_id) { SecureRandom.uuid }
  let(:la_name) { 'Taxidiscountcaz' }
  let(:daily_charge) { 12.5 }
  let(:tariff) { 'BCC01-private_car' }

  before do
    details = instance_double('ComplianceDetails',
                              zone_name: la_name,
                              charge: daily_charge,
                              tariff_code: tariff)
    allow(ComplianceDetails).to receive(:new).and_return(details)
  end

  it 'creates instance of ComplianceDetails with right params' do
    subject
    expect(ComplianceDetails).to have_received(:new).with(details.merge('la_id' => la_id))
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

    it 'sets weekly_possible to false' do
      expect(session[:vehicle_details]['weekly_possible']).to be_falsey
    end

    it 'sets tariff_code' do
      expect(session[:vehicle_details]['tariff_code']).to eq(tariff)
    end

    context 'when vehicle is a taxi in Taxidiscountcaz' do
      let(:session) { { vehicle_details: details.merge('weekly_taxi' => true) } }

      it 'sets weekly_possible to true' do
        expect(session[:vehicle_details]['weekly_possible']).to be_truthy
      end
    end

    context 'when there are more details in session' do
      let(:session) do
        { vehicle_details: details.merge('dates' => ['2019-11-11']) }
      end

      it 'clears keys from next steps' do
        expect(session[:vehicle_details].keys).to contain_exactly(
          'vrn', 'country', 'la_id', 'la_name', 'daily_charge', 'weekly_possible', 'tariff_code'
        )
      end
    end
  end
end
