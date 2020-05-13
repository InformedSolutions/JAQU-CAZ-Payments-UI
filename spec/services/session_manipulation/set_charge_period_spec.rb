# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetChargePeriod do
  subject(:service) { described_class.call(session: session, charge_period: 'daily-period') }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => vrn, 'country' => country } }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }

  it 'sets charge period' do
    service
    expect(session[:vehicle_details]['charge_period']).to eq('daily-period')
  end

  context 'when session is already filled with more data' do
    let(:details) do
      {
        'vrn' => vrn,
        'country' => country,
        'payment_id' => SecureRandom.uuid,
        'type' => 'Car',
        'confirm_exempt' => true
      }
    end

    it 'clears keys from next steps' do
      service
      expect(session[:vehicle_details].keys)
        .to contain_exactly('vrn', 'country', 'type', 'charge_period')
    end
  end
end
