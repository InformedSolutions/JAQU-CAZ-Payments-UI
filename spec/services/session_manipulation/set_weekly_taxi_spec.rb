# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetWeeklyTaxi do
  subject { described_class.call(session: session) }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => vrn, 'country' => country } }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }

  it 'sets taxi' do
    subject
    expect(session[:vehicle_details]['weekly_taxi']).to be_truthy
  end

  context 'when session is already filled with more data' do
    let(:details) do
      { 'vrn' => vrn, 'country' => country, 'payment_id' => SecureRandom.uuid, 'type' => 'Car' }
    end

    it 'clears keys from next steps' do
      subject
      expect(session[:vehicle_details].keys).to contain_exactly('vrn', 'country', 'weekly_taxi')
    end
  end
end
