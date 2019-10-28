# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject(:payment) do
    Payment.new({
                  'vrn' => vrn,
                  'dates' => dates,
                  'la' => zone_id,
                  'daily_charge' => charge
                },
                url,
                total_charge)
  end

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:dates) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:charge) { 10 }
  let(:total_charge) { charge * dates.length }

  let(:payment_id) { SecureRandom.uuid }
  let(:url) { 'www.wp.pl' }

  before do
    allow(PaymentsApi)
      .to receive(:create_payment)
      .with(vrn: vrn, zone_id: zone_id, amount: total_charge, days: dates, return_url: url)
      .and_return('paymentId' => payment_id, 'nextUrl' => url)
  end

  it 'calls PaymentsApi.create_payment with proper params' do
    expect(PaymentsApi)
      .to receive(:create_payment)
      .with(vrn: vrn, zone_id: zone_id, amount: total_charge, days: dates, return_url: url)
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
