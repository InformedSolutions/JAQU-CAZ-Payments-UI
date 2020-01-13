# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject(:payment) do
    Payment.new({
                  'vrn' => vrn,
                  'dates' => dates,
                  'la_id' => zone_id,
                  'total_charge' => total_charge,
                  'tariff_code' => tariff
                },
                url)
  end

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:dates) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:total_charge) { 25 }
  let(:tariff) { 'BCC01-private_car' }

  let(:payment_id) { SecureRandom.uuid }
  let(:url) { 'www.wp.pl' }

  before do
    allow(PaymentsApi)
      .to receive(:create_payment)
      .and_return('paymentId' => payment_id, 'nextUrl' => url)
  end

  it 'calls PaymentsApi.create_payment with proper params' do
    expect(PaymentsApi)
      .to receive(:create_payment)
      .with(
        vrn: vrn,
        zone_id: zone_id,
        return_url: url,
        payment_details: {
          amount: total_charge,
          days: dates,
          tariff: tariff
        }
      )
    payment.payment_id
  end

  describe '.payment_id' do
    it 'returns id' do
      expect(payment.payment_id).to eq(payment_id)
    end
  end

  describe '.gov_uk_pay_url' do
    it 'returns URL' do
      expect(payment.gov_uk_pay_url).to eq(url)
    end
  end
end
