# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject(:payment) do
    Payment.new({
                  'vrn' => vrn,
                  'dates' => dates,
                  'la_id' => zone_id,
                  'daily_charge' => charge,
                  'total_charge' => total_charge,
                  'tariff_code' => tariff,
                  'weekly' => weekly
                },
                url)
  end

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:dates) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:charge) { 25 }
  let(:total_charge) { charge * dates.length }
  let(:tariff) { 'BCC01-private_car' }
  let(:weekly) { false }

  let(:payment_id) { SecureRandom.uuid }
  let(:url) { 'www.wp.pl' }
  let(:payment_reference) { '1056' }
  let(:external_id) { '0ntoo845dhr52v8dcmqoulbam9' }

  before do
    allow(PaymentsApi)
      .to receive(:create_payment)
      .and_return('paymentId' => payment_id, 'centralReference' => payment_reference,
                  'paymentProviderId' => external_id, 'nextUrl' => url)
  end

  describe '.payment_id' do
    it 'returns id' do
      expect(payment.payment_id).to eq(payment_id)
    end
  end

  describe '.payment_reference' do
    it 'returns reference' do
      expect(payment.payment_reference).to eq(payment_reference)
    end
  end

  describe '.external_id' do
    it 'returns id' do
      expect(payment.external_id).to eq(external_id)
    end
  end

  describe '.gov_uk_pay_url' do
    it 'returns URL' do
      expect(payment.gov_uk_pay_url).to eq(url)
    end
  end

  describe 'transactions' do
    context 'when daily flow is selected' do
      let(:expected_transactions) do
        [
          {
            vrn: vrn,
            travelDate: dates.first,
            tariffCode: tariff,
            charge: (charge.to_f * 100).to_i
          },
          {
            vrn: vrn,
            travelDate: dates.last,
            tariffCode: tariff,
            charge: (charge.to_f * 100).to_i
          }
        ]
      end

      it 'calls PaymentsApi.create_payment with proper params' do
        expect(PaymentsApi)
          .to receive(:create_payment)
          .with(
            vrn: vrn,
            zone_id: zone_id,
            return_url: url,
            transactions: expected_transactions
          )
        payment.payment_id
      end
    end

    context 'when weekly flow is selected' do
      let(:weekly) { true }
      let(:dates) do
        (1..7).map { |i| (Date.current + i.days).to_s }
      end

      it 'returns total charge of 50' do
        expect(payment.send(:weekly_transactions).sum { |t| t[:charge] }).to eq(5000)
      end

      context 'API call' do
        let(:dates) { [Date.current.to_s] }
        let(:expected_transactions) do
          [
            {
              vrn: vrn,
              travelDate: dates.first,
              tariffCode: tariff,
              charge: 716
            }
          ]
        end

        it 'calls PaymentsApi.create_payment with proper params' do
          expect(PaymentsApi)
            .to receive(:create_payment)
            .with(
              vrn: vrn,
              zone_id: zone_id,
              return_url: url,
              transactions: expected_transactions
            )
          payment.payment_id
        end
      end
    end
  end
end
