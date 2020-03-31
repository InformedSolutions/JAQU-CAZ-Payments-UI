# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetConfirmExempt do
  subject(:service) { described_class.call(session: session) }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => vrn, 'country' => country } }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }

  it 'sets confirm exempt' do
    service
    expect(session[:vehicle_details]['confirm_exempt']).to be_truthy
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
        .to contain_exactly('vrn', 'country', 'type', 'charge_period', 'confirm_exempt')
    end
  end
end
