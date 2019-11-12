# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe '.parse_charge' do
    it 'returns parsed value in pounds' do
      expect(helper.parse_charge(50)).to eq('£50.00')
    end
  end

  describe '.parse_dates' do
    let(:array) { ['2019-10-11'] }

    it 'returns a parsed date in right format' do
      expect(helper.parse_dates(array).first).to eq('Friday 11 October 2019')
    end

    it 'returns an array' do
      expect(helper.parse_dates(array)).to be_a(Array)
    end
  end

  describe '.parse_weekly_dates' do
    it 'returns 7 next days' do
      expect(helper.parse_weekly_dates('2019-11-01')).to eq('01/11/19 - 07/11/19')
    end
  end
end
