# frozen_string_literal: true

require 'rails_helper'

describe Dates::ReviewWeeklySelection do
  subject do
    described_class.new(
      vrn: 'CU123AB',
      zone_id: '7d0c4240-1618-446b-bde2-2f3458c8a520',
      session: session
    )
  end

  let(:session) { { first_week_start_date: '2020-05-01', second_week_start_date: '2020-05-08' } }

  before do
    allow(PaymentsApi).to receive(:paid_payments_dates).and_return([])
    mock_single_caz('2020-03-01')
  end

  describe 'when second week date is in session' do
    it '.second_week_available? returns false' do
      expect(subject.second_week_available?).to eq(false)
    end

    it '.format_week_selection formats the dates correctly' do
      formatted_dates = [%w[01/05/2020 07/05/2020], %w[08/05/2020 14/05/2020]]
      expect(subject.format_week_selection).to eq(formatted_dates)
    end
  end

  describe 'when second week date is not in session' do
    let(:session) { { first_week_start_date: '2020-05-01' } }

    it '.second_week_available? returns true' do
      expect(subject.second_week_available?).to eq(true)
    end

    it '.format_week_selection formats the dates correctly' do
      formatted_dates = [%w[01/05/2020 07/05/2020]]
      expect(subject.format_week_selection).to eq(formatted_dates)
    end
  end
end
