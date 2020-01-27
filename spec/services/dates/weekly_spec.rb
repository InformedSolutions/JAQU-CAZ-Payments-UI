# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates::Weekly do
  subject(:dates) { described_class.call(vrn: vrn, zone_id: zone_id) }

  let(:vrn) { 'CU123AB' }
  let(:zone_id) { SecureRandom.uuid }

  describe '.call' do
    it 'returns eight days' do
      expect(subject.count).to eq(8)
    end

    describe 'date object' do
      let(:yesterday) { Date.current.yesterday }

      it 'returns right display date' do
        expect(dates.first[:name]).to eq(yesterday.strftime('%A %d %B %Y'))
      end

      it 'returns right value date' do
        expect(dates.first[:value]).to eq(yesterday.strftime('%Y-%m-%d'))
      end

      it 'marks six days ago as not today' do
        expect(dates.first[:today]).to be_falsey
      end

      it 'marks today as today' do
        expect(dates[1][:today]).to be_truthy
      end
    end
  end
end
