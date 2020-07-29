# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::CalculateTotalCharge do
  subject(:service) do
    described_class.call(session: session, dates: dates, weekly: weekly)
  end

  let(:session) do
    {
      vehicle_details: details,
      first_week_start_date: first_week_start_date,
      second_week_selected: second_week_selected
    }
  end
  let(:details) do
    {
      'vrn' => 'CU123AB',
      'country' => 'UK',
      'la_id' => SecureRandom.uuid,
      'la_name' => 'Leeds',
      'daily_charge' => 20
    }
  end
  let(:second_week_selected) { false }
  let(:first_week_start_date) { nil }

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
    let(:first_week_start_date) { '2019-11-01' }
    let(:week_dates) { ['2019-11-01'] }

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
