# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::ClearPaymentDetails do
  subject(:service) { described_class.call(session: session) }

  let(:session) { { vehicle_details: details } }
  let(:details) do
    {
      'vrn' => 'CU123AB',
      'country' => 'UK',
      'leeds_taxi' => true,
      'unrecognised' => true,
      'type' => 'car',
      'incorrect' => true,
      'chargeable_zones' => 2,
      'la_id' => SecureRandom.uuid,
      'daily_charge' => 12.5,
      'la_name' => 'Leeds',
      'weekly_possible' => true,
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
      'vrn', 'country', 'leeds_taxi', 'unrecognised', 'type', 'incorrect', 'chargeable_zones'
    )
  end
end
