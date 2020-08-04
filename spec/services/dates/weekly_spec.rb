# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates::Weekly do
  subject(:service) do
    described_class.new(
      vrn: vrn,
      zone_id: zone_id,
      charge_start_date: active_charge_start_date,
      second_week_selected: second_week_selected,
      week_start_days: week_start_days
    )
  end

  let(:vrn) { 'CU123AB' }
  let(:zone_id) { SecureRandom.uuid }
  let(:paid_dates) { [] }
  let(:value_format) { '%Y-%m-%d' }
  let(:active_charge_start_date) { 10.days.ago.to_s }
  let(:second_week_selected) { false }
  let(:week_start_days) { [] }

  before { allow(PaymentsApi).to receive(:paid_payments_dates).and_return(paid_dates) }

  describe '.chargeable_dates' do
    subject { service.chargeable_dates }

    context 'when #active_charge_start_date is not considered' do
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

    context 'when #active_charge_start_date is considered' do
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
        subject
      end

      describe 'date object' do
        let(:start) { (Date.current - 6.days) }

        it 'returns right display date' do
          expect(subject.first[:name]).to eq(start.strftime('%A %d %B %Y'))
        end

        it 'returns right value date' do
          expect(subject.first[:value]).to eq(start.strftime(value_format))
        end

        it 'marks six days ago as not today' do
          expect(subject.first[:today]).to be_falsey
        end

        it 'marks today as today' do
          expect(subject[6][:today]).to be_truthy
        end
      end

      describe 'disabled' do
        it 'returns no disabled subject' do
          expect(subject.filter { |date| date[:disabled] }.length).to eq(0)
        end

        context 'when the payment for today was done' do
          let(:paid_dates) { [Date.current.strftime(value_format)] }

          it 'returns 2 disabled subject' do
            expect(subject.filter { |date| date[:disabled] }.length).to eq(7)
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
          let(:active_charge_start_date) { 8.days.from_now.to_s }

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

  context 'when second week is being selected' do
    let(:second_week_selected) { true }
    first_week_start = Time.zone.now.strftime(Dates::Base::VALUE_DATE_FORMAT)
    second_week_start = 8.days.from_now.strftime(Dates::Base::VALUE_DATE_FORMAT)
    let(:week_start_days) { [first_week_start, second_week_start] }

    describe '.chargeable_dates' do
      it 'returns 13 dates' do
        expect(service.chargeable_dates.count).to eq(13)
      end

      it 'disables whole payment window' do
        disabled_dates = service.chargeable_dates.map { |date| date[:disabled] }.select(&:present?)

        expect(disabled_dates.count).to eq(13)
      end

      it 'sets correct dates' do
        first_day = 6.days.ago.strftime(Dates::Base::VALUE_DATE_FORMAT)
        last_day = 6.days.from_now.strftime(Dates::Base::VALUE_DATE_FORMAT)

        expect(service.chargeable_dates.first[:value]).to eq(first_day)
        expect(service.chargeable_dates.last[:value]).to eq(last_day)
      end
    end
  end
end
