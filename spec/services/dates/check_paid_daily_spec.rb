# frozen_string_literal: true

require 'rails_helper'

describe Dates::CheckPaidDaily do
  subject { described_class.call(vrn: vrn, zone_id: zone_id, dates: dates) }

  let(:paid_dates) do
    (1..3).map { |i| (Date.current - i.day).strftime('%Y-%m-%d') }
  end
  let(:dates) do
    (1..3).map { |i| (Date.current + i.day).strftime('%Y-%m-%d') }
  end

  let(:vrn) { 'CU123AB' }
  let(:zone_id) { SecureRandom.uuid }

  before do
    allow(PaymentsApi)
      .to receive(:paid_payments_dates)
      .and_return(paid_dates)
  end

  it 'returns true when dates are not in paid dates' do
    expect(subject).to be_truthy
  end

  it 'calls PaymentsApi.paid_payments_dates with right params' do
    subject
    expect(PaymentsApi).to have_received(:paid_payments_dates)
      .with(
        vrn: vrn,
        zone_id: zone_id,
        start_date: (Date.current - 6.days).strftime('%Y-%m-%d'),
        end_date: (Date.current + 6.days).strftime('%Y-%m-%d')
      )
  end

  context 'when dates in paid dates' do
    let(:dates) do
      (3..5).map { |i| (Date.current - i.day).strftime('%Y-%m-%d') }
    end

    it 'returns false' do
      expect(subject).to be_falsey
    end
  end
end
