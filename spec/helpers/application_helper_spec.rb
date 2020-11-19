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

  describe '.determinate_payment_for_path' do
    let(:new_id) { SecureRandom.uuid }

    it 'returns a proper value' do
      expect(helper.determinate_payment_for_path(
               true,
               true,
               new_id
             )).to eq("/dates/select_weekly_period?id=#{new_id}&new=true")
    end
  end
end
