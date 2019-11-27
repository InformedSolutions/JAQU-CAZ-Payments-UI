# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates::Daily do
  subject(:dates) { described_class.call }

  describe '.call' do
    it 'returns thirteen days' do
      expect(subject.count).to eq(13)
    end

    describe 'date object' do
      let(:six_days_ago) { Date.current - 6.days }

      it 'returns right display date' do
        expect(dates.first[:name]).to eq(six_days_ago.strftime('%A %d %B %Y'))
      end

      it 'returns right value date' do
        expect(dates.first[:value]).to eq(six_days_ago.strftime('%Y-%m-%d'))
      end

      it 'marks six days ago as not today' do
        expect(dates.first[:today]).to be_falsey
      end

      it 'marks today as today' do
        expect(dates[6][:today]).to be_truthy
      end
    end
  end
end
