# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetPossibleFraud do
  subject { described_class.call(session: session) }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => vrn, 'country' => country } }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }

  before { subject }

  it 'sets possible fraud' do
    expect(session[:vehicle_details]['possible_fraud']).to be_truthy
  end

  context 'when session is already filled with more data' do
    let(:details) do
      {
        'vrn' => vrn,
        'country' => country,
        'payment_id' => SecureRandom.uuid,
        'type' => 'Car',
        'taxi' => true
      }
    end

    it 'clears keys from next steps' do
      expect(session[:vehicle_details].keys)
        .to contain_exactly('vrn', 'country', 'possible_fraud')
    end
  end
end
