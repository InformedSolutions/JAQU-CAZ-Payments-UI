# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates::Daily do
  subject(:dates) { described_class.call(vrn: vrn, zone_id: zone_id) }

  let(:paid_dates) do
    [six_days_ago + 1.day, six_days_ago + 3.days].map { |date| date.strftime('%Y-%m-%d') }
  end
  let(:vrn) { 'CU123AB' }
  let(:zone_id) { SecureRandom.uuid }
  let(:six_days_ago) { Date.current - 6.days }

  before do
    allow(PaymentsApi)
      .to receive(:paid_payments_dates)
      .and_return(paid_dates)
  end

  describe '.call' do
    it 'returns thirteen days' do
      expect(dates.count).to eq(13)
    end

    it 'calls PaymentsApi.paid_payments_dates with right params' do
      expect(PaymentsApi)
        .to receive(:paid_payments_dates)
        .with(
          vrn: vrn,
          zone_id: zone_id,
          start_date: six_days_ago.strftime('%Y-%m-%d'),
          end_date: (Date.current + 6.days).strftime('%Y-%m-%d')
        )
      dates
    end

    describe 'date object' do
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

      it 'sets disabled if was already paid' do
        expect(dates[1][:disabled]).to be_truthy
      end

      it 'does not set disabled if was not aid' do
        expect(dates[0][:disabled]).to be_falsey
      end
    end
  end
end
