# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates::Weekly do
  subject(:dates) { described_class.call(vrn: vrn, zone_id: zone_id) }

  let(:vrn) { 'CU123AB' }
  let(:zone_id) { SecureRandom.uuid }
  let(:paid_dates) { [] }
  let(:value_format) { '%Y-%m-%d' }

  before do
    allow(PaymentsApi)
      .to receive(:paid_payments_dates)
      .and_return(paid_dates)
  end

  describe '.call' do
    it 'returns eight days' do
      expect(subject.count).to eq(8)
    end

    it 'calls PaymentsApi.paid_payments_dates with right params' do
      expect(PaymentsApi)
        .to receive(:paid_payments_dates)
        .with(
          vrn: vrn,
          zone_id: zone_id,
          start_date: Date.yesterday.strftime(value_format),
          end_date: (Date.current + 12.days).strftime(value_format)
        )
      dates
    end

    describe 'date object' do
      let(:yesterday) { Date.current.yesterday }

      it 'returns right display date' do
        expect(dates.first[:name]).to eq(yesterday.strftime('%A %d %B %Y'))
      end

      it 'returns right value date' do
        expect(dates.first[:value]).to eq(yesterday.strftime(value_format))
      end

      it 'marks six days ago as not today' do
        expect(dates.first[:today]).to be_falsey
      end

      it 'marks today as today' do
        expect(dates[1][:today]).to be_truthy
      end
    end

    describe 'disabled' do
      it 'returns no disabled dates' do
        expect(dates.filter { |date| date[:disabled] }.length).to eq(0)
      end

      context 'when the payment for today was done' do
        let(:paid_dates) { [Date.current.strftime(value_format)] }

        it 'returns 2 disabled dates' do
          expect(dates.filter { |date| date[:disabled] }.length).to eq(2)
        end
      end
    end
  end
end
