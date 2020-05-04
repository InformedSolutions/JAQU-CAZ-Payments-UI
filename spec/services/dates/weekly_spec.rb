# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates::Weekly do
  subject(:dates) do
    described_class.call(
      vrn: vrn,
      zone_id: zone_id,
      charge_start_date: active_charge_start_date
    )
  end

  let(:vrn) { 'CU123AB' }
  let(:zone_id) { SecureRandom.uuid }
  let(:paid_dates) { [] }
  let(:value_format) { '%Y-%m-%d' }
  let(:active_charge_start_date) { 10.days.ago.to_s }

  before do
    allow(PaymentsApi)
      .to receive(:paid_payments_dates)
      .and_return(paid_dates)
  end

  context 'when #active_charge_start_date is not considered' do
    context 'when #active_charge_start_date is nil' do
      let(:active_charge_start_date) { nil }

      it 'returns a whole range - thirteen days' do
        expect(dates.count).to eq(13)
      end
    end

    context 'when #active_charge_start_date is today' do
      let(:active_charge_start_date) { Date.current.to_s }

      it 'returns 7 days' do
        expect(dates.count).to eq(7)
      end

      it 'returns collection starting with the present day' do
        expect(dates.first[:today]).to be_truthy
      end
    end

    context 'when #active_charge_start_date is more than a week in the future' do
      let(:active_charge_start_date) { 10.days.from_now.to_s }

      it 'returns an empty collection' do
        expect(dates.count).to eq(0)
      end
    end
  end

  context 'when #active_charge_start_date is considered' do
    describe '.call' do
      it 'returns thirteen days' do
        expect(subject.count).to eq(13)
      end

      it 'calls PaymentsApi.paid_payments_dates with right params' do
        expect(PaymentsApi)
          .to receive(:paid_payments_dates)
          .with(
            vrn: vrn,
            zone_id: zone_id,
            start_date: (Date.current - 6.days).strftime(value_format),
            end_date: (Date.current + 12.days).strftime(value_format)
          )
        dates
      end

      describe 'date object' do
        let(:start) { (Date.current - 6.days) }

        it 'returns right display date' do
          expect(dates.first[:name]).to eq(start.strftime('%A %d %B %Y'))
        end

        it 'returns right value date' do
          expect(dates.first[:value]).to eq(start.strftime(value_format))
        end

        it 'marks six days ago as not today' do
          expect(dates.first[:today]).to be_falsey
        end

        it 'marks today as today' do
          expect(dates[6][:today]).to be_truthy
        end
      end

      describe 'disabled' do
        it 'returns no disabled dates' do
          expect(dates.filter { |date| date[:disabled] }.length).to eq(0)
        end

        context 'when the payment for today was done' do
          let(:paid_dates) { [Date.current.strftime(value_format)] }

          it 'returns 2 disabled dates' do
            expect(dates.filter { |date| date[:disabled] }.length).to eq(7)
          end
        end
      end
    end
  end
end
