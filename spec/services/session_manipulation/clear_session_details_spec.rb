# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::ClearSessionDetails do
  subject(:service) { described_class.call(session: session, key: 8) }

  let(:session) { { vehicle_details: details } }
  let(:details) do
    {
      'vrn' => 'CU123AB',
      'country' => 'UK',
      'confirm_vehicle' => true,
      'leeds_taxi' => true,
      'unrecognised' => true,
      'confirm_registration' => true,
      'type' => 'car',
      'incorrect' => true,
      'chargeable_zones' => 2,
      'la_id' => SecureRandom.uuid,
      'daily_charge' => 12.5,
      'la_name' => 'Leeds',
      'weekly_possible' => true,
      'tariff_code' => 'test',
      'charge_period' => 'daily-charge',
      'dates' => ['2019-11-01'],
      'total_charge' => 50,
      'weekly' => true,
      'payment_id' => SecureRandom.uuid,
      'user_email' => 'test@example.com',
      'payment_reference' => 1,
      'external_id' => 'external reference'
    }
  end

  it 'clears details from steps above vehicle details' do
    service
    expect(session[:vehicle_details].keys).to contain_exactly(
      'vrn',
      'country',
      'confirm_vehicle',
      'leeds_taxi',
      'unrecognised',
      'confirm_registration',
      'type',
      'incorrect',
      'la_id',
      'chargeable_zones'
    )
  end
end
