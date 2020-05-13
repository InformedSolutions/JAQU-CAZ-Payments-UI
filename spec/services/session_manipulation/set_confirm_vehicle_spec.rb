# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetConfirmVehicle do
  subject(:service) { described_class.call(session: session, confirm_vehicle: true) }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => vrn, 'country' => country } }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }

  it 'sets confirm vehicle' do
    service
    expect(session[:vehicle_details]['confirm_vehicle']).to be_truthy
  end

  context 'when session is already filled with more data' do
    let(:details) do
      {
        'vrn' => vrn,
        'country' => country,
        'payment_id' => SecureRandom.uuid,
        'type' => 'Car',
        'charge_period' => 'daily-period'
      }
    end

    it 'clears keys from next steps' do
      service
      expect(session[:vehicle_details].keys)
        .to contain_exactly('vrn', 'country', 'confirm_vehicle')
    end
  end
end
