# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates::CheckPaidWeekly do
  subject(:service) { described_class.call(vrn: vrn, zone_id: zone_id, date: date) }

  let(:paid_dates) do
    (1..3).map { |i| (Date.current + i.day).strftime('%Y-%m-%d') }
  end
  let(:date) { Date.current.strftime('%Y-%m-%d') }
  let(:vrn) { 'CU123AB' }
  let(:zone_id) { SecureRandom.uuid }

  before do
    allow(PaymentsApi)
      .to receive(:paid_payments_dates)
      .and_return(paid_dates)
  end

  it 'calls PaymentsApi.paid_payments_dates with right params' do
    expect(PaymentsApi)
      .to receive(:paid_payments_dates)
      .with(
        vrn: vrn,
        zone_id: zone_id,
        start_date: date,
        end_date: (Date.current + 6.days).strftime('%Y-%m-%d')
      )
    service
  end

  context 'when no payments were made' do
    let(:paid_dates) { [] }

    it 'returns true' do
      expect(service).to be_truthy
    end
  end

  context 'when some payments were made' do
    it 'returns false' do
      expect(service).to be_falsey
    end
  end
end
