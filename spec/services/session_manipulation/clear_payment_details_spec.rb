# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::ClearPaymentDetails do
  subject(:service) { described_class.call(session: session) }

  let(:session) { { vehicle_details: details } }
  let(:details) do
    {
      'vrn' => 'CU123AB',
      'country' => 'UK',
      'taxi' => true,
      'unrecognised' => true,
      'type' => 'car',
      'incorrect' => true,
      'la_id' => SecureRandom.uuid,
      'daily_charge' => 12.5,
      'la_name' => 'Leeds',
      'weekly_possible' => true,
      'dates' => ['2019-11-01'],
      'total_charge' => 50,
      'weekly' => true,
      'payment_id' => SecureRandom.uuid,
      'user_email' => 'test@example.com'
    }
  end

  it 'clears details from steps above vehicle details' do
    service
    expect(session[:vehicle_details].keys).to contain_exactly(
      'vrn', 'country', 'taxi', 'unrecognised', 'type', 'incorrect'
    )
  end
end
