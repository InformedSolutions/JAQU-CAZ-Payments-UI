# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetComplianceDetails do
  subject(:service) { described_class.call(session: session, la_id: la_id) }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => 'CU123AB', 'country' => 'UK' } }
  let(:la_id) { SecureRandom.uuid }
  let(:la_name) { 'Leeds' }
  let(:daily_charge) { 12.5 }

  before do
    details = instance_double('ComplianceDetails')
    allow(details).to receive(:zone_name).and_return(la_name)
    allow(details).to receive(:charge).and_return(daily_charge)
    allow(ComplianceDetails).to receive(:new).and_return(details)
  end

  it 'creates instance of ComplianceDetails with right params' do
    expect(ComplianceDetails)
      .to receive(:new)
      .with(details.merge('la_id' => la_id))
    service
  end

  describe 'adding fields' do
    before { service }

    it 'sets la_id' do
      expect(session[:vehicle_details]['la_id']).to eq(la_id)
    end

    it 'sets la_id' do
      expect(session[:vehicle_details]['la_name']).to eq(la_name)
    end

    it 'sets daily_charge' do
      expect(session[:vehicle_details]['daily_charge']).to eq(daily_charge)
    end

    it 'sets weekly_possible to false' do
      expect(session[:vehicle_details]['weekly_possible']).to be_falsey
    end

    context 'when vehicle is a taxi' do
      let(:session) { { vehicle_details: details.merge('taxi' => true) } }

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
          'vrn', 'country', 'la_id', 'la_name', 'daily_charge', 'weekly_possible'
        )
      end
    end
  end
end