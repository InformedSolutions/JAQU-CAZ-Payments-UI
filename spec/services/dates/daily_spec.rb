# frozen_string_literal: true

require 'rails_helper'

describe Dates::Daily do
  subject(:service) do
    described_class.new(vrn: vrn, zone_id: zone_id, charge_start_date: active_charge_start_date)
  end

  let(:paid_dates) { [six_days_ago + 1.day, six_days_ago + 3.days].map { |date| date.strftime('%Y-%m-%d') } }
  let(:vrn) { 'CU123AB' }
  let(:zone_id) { SecureRandom.uuid }
  let(:six_days_ago) { Date.current - 6.days }
  let(:active_charge_start_date) { 10.days.ago.to_s }

  before { allow(PaymentsApi).to receive(:paid_payments_dates).and_return(paid_dates) }

  describe '.chargeable_dates' do
    subject { service.chargeable_dates }

    context 'when #active_charge_start_date is considered' do
      context 'and #active_charge_start_date is nil' do
        let(:active_charge_start_date) { nil }

        it 'returns a whole range - thirteen days' do
          expect(subject.count).to eq(13)
        end
      end

      context 'and #active_charge_start_date is today' do
        let(:active_charge_start_date) { Date.current.to_s }

        it 'returns 7 days' do
          expect(subject.count).to eq(7)
        end

        it 'returns collection starting with the present day' do
          expect(subject.first[:today]).to be_truthy
        end
      end

      context 'and #active_charge_start_date is more than a week in the future' do
        let(:active_charge_start_date) { 10.days.from_now.to_s }

        it 'returns an empty collection' do
          expect(subject.count).to eq(0)
        end
      end
    end

    context 'when #active_charge_start_date is not considered' do
      it 'returns thirteen days' do
        expect(subject.count).to eq(13)
      end

      it 'calls PaymentsApi.paid_payments_dates with right params' do
        subject
        expect(PaymentsApi).to have_received(:paid_payments_dates)
          .with(
            vrn: vrn,
            zone_id: zone_id,
            start_date: six_days_ago.strftime('%Y-%m-%d'),
            end_date: (Date.current + 6.days).strftime('%Y-%m-%d')
          )
      end

      describe 'date object' do
        it 'returns right display date' do
          expect(subject.first[:name]).to eq(six_days_ago.strftime('%A %d %B %Y'))
        end

        it 'returns right value date' do
          expect(subject.first[:value]).to eq(six_days_ago.strftime('%Y-%m-%d'))
        end

        it 'marks six days ago as not today' do
          expect(subject.first[:today]).to be_falsey
        end

        it 'marks today as today' do
          expect(subject[6][:today]).to be_truthy
        end

        it 'sets disabled if was already paid' do
          expect(subject[1][:disabled]).to be_truthy
        end

        it 'does not set disabled if was not aid' do
          expect(subject[0][:disabled]).to be_falsey
        end
      end
    end

    describe '.d_day_notice' do
      before { subject }

      context 'when #active_charge_start_date is nil' do
        let(:active_charge_start_date) { nil }

        it 'returns a nil' do
          expect(service.d_day_notice).to be_nil
        end
      end

      context 'and #active_charge_start_date is today' do
        let(:active_charge_start_date) { Date.current.to_s }

        it 'returns true' do
          expect(service.d_day_notice).to be_truthy
        end
      end

      context 'and #active_charge_start_date is more than a week in the future' do
        let(:active_charge_start_date) { 6.days.from_now.to_s }

        it 'returns false' do
          expect(service.d_day_notice).to be_falsey
        end
      end

      context 'when #active_charge_start_date is not considered' do
        it 'returns false' do
          expect(service.d_day_notice).to be_falsey
        end
      end
    end
  end
end
