# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::CalculateTotalCharge do
  subject do
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
      'la_name' => 'Taxidiscountcaz',
      'daily_charge' => 20
    }
  end
  let(:second_week_selected) { false }
  let(:first_week_start_date) { nil }

  context 'when normal path is selected' do
    let(:weekly) { false }
    let(:dates) { %w[2019-11-01 2019-11-02 2019-11-03] }

    before { subject }

    it 'sets total_charge' do
      expect(session[:vehicle_details]['total_charge']).to eq(60)
    end

    it 'sets dates' do
      expect(session[:vehicle_details]['dates']).to eq(dates)
    end

    it 'sets weekly to false' do
      expect(session[:vehicle_details]['weekly']).to be_falsey
    end
  end

  context 'when Taxidiscountcaz path is selected' do
    let(:weekly) { true }
    let(:dates) { ['2019-11-01'] }
    let(:expected_dates) { (1..7).map { |day| "2019-11-0#{day}" } }

    before { subject }

    it 'sets total_charge' do
      expect(session[:vehicle_details]['total_charge']).to eq(50)
    end

    it 'sets dates' do
      expect(session[:vehicle_details]['dates']).to eq(expected_dates)
    end

    it 'sets weekly to true' do
      expect(session[:vehicle_details]['weekly']).to be_truthy
    end

    context 'when second week is selected' do
      let(:second_week_selected) { true }
      let(:first_week_start_date) { '2019-11-01' }
      let(:dates) { ['2019-11-08'] }
      let(:expected_dates) do
        first_date = Date.parse(first_week_start_date)
        first_date.upto(first_date + 13.days).map { |d| d.strftime('%Y-%m-%d') }
      end

      before { subject }

      it 'sets total_charge' do
        expect(session[:vehicle_details]['total_charge']).to eq(100)
      end

      it 'sets dates' do
        expect(session[:vehicle_details]['dates']).to eq(expected_dates)
      end

      it 'sets weekly to true' do
        expect(session[:vehicle_details]['weekly']).to be_truthy
      end
    end
  end
end
