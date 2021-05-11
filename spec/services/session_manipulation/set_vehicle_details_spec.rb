# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetVehicleDetails do
  subject do
    described_class.call(session: session, weekly_taxi: weekly_taxi, undetermined: undetermined,
                         undetermined_taxi: undetermined_taxi,
                         dvla_vehicle_type: dvla_vehicle_type)
  end

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => vrn, 'country' => country } }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }
  let(:weekly_taxi) { false }
  let(:undetermined) { true }
  let(:undetermined_taxi) { false }
  let(:dvla_vehicle_type) { 'Car' }

  it 'sets weekly_taxi' do
    subject
    expect(session[:vehicle_details]['weekly_taxi']).to eq(weekly_taxi)
  end

  it 'sets undetermined' do
    subject
    expect(session[:vehicle_details]['undetermined']).to eq(undetermined)
  end

  it 'sets undetermined_taxi' do
    subject
    expect(session[:vehicle_details]['undetermined_taxi']).to eq(undetermined_taxi)
  end

  it 'sets dvla_vehicle_type' do
    subject
    expect(session[:vehicle_details]['dvla_vehicle_type']).to eq(dvla_vehicle_type)
  end

  context 'when session is already filled with more data' do
    let(:details) do
      {
        'vrn' => vrn,
        'country' => country,
        'unrecognised' => true,
        'payment_id' => SecureRandom.uuid
      }
    end

    it 'clears keys from next steps' do
      subject
      expect(session[:vehicle_details].keys)
        .to contain_exactly('country', 'dvla_vehicle_type', 'undetermined',
                            'undetermined_taxi', 'vrn', 'weekly_taxi')
    end
  end
end
