# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetConfirmWeeklyChargeToday do
  subject { described_class.call(session: session, confirm_weekly_charge_today: confirmation) }

  let(:session) { { vehicle_details: details } }
  let(:confirmation) { true }
  let(:details) { { 'vrn' => vrn, 'country' => country } }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }

  it 'sets confirm_weekly_charge_today' do
    subject
    expect(session[:vehicle_details]['confirm_weekly_charge_today']).to be_truthy
  end

  context 'when session is already filled with more data' do
    let(:details) do
      {
        'vrn' => vrn,
        'country' => country,
        'type' => 'Car',
        'charge_period' => 'daily-period',
        'payment_id' => SecureRandom.uuid
      }
    end

    it 'clears keys from next steps' do
      subject
      expect(session[:vehicle_details].keys).to be_exclude('payment_id')
    end
  end
end
