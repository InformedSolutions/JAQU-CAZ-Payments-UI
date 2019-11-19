# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::CalculateTotalCharge do
  subject(:service) do
    described_class.call(session: session, dates: dates, weekly: weekly)
  end

  let(:session) { { vehicle_details: details } }
  let(:details) do
    {
      'vrn' => 'CU123AB',
      'country' => 'UK',
      'la_id' => SecureRandom.uuid,
      'la_name' => 'Leeds',
      'daily_charge' => 20
    }
  end

  context 'when normal path is selected' do
    let(:weekly) { false }
    let(:dates) { %w[2019-11-01 2019-11-02 2019-11-03] }

    it 'sets total_charge' do
      service
      expect(session[:vehicle_details]['total_charge']).to eq(60)
    end

    it 'sets dates' do
      service
      expect(session[:vehicle_details]['dates']).to eq(dates)
    end

    it 'sets weekly to false' do
      service
      expect(session[:vehicle_details]['weekly']).to be_falsey
    end
  end

  context 'when discounted Leeds path is selected' do
    let(:weekly) { true }
    let(:dates) { ['2019-11-01'] }
    let(:expected_dates) { (1..7).map { |day| "2019-11-0#{day}" } }

    it 'sets total_charge' do
      service
      expect(session[:vehicle_details]['total_charge']).to eq(50)
    end

    it 'sets dates' do
      service
      expect(session[:vehicle_details]['dates']).to eq(expected_dates)
    end

    it 'sets weekly to true' do
      service
      expect(session[:vehicle_details]['weekly']).to be_truthy
    end
  end
end
