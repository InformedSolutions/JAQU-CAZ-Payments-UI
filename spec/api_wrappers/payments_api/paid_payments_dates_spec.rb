# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentsApi.paid_payments_dates' do
  subject(:call) do
    PaymentsApi.paid_payments_dates(
      vrn: vrn, zone_id: id, start_date: start_date, end_date: end_date
    )
  end

  let(:vrn) { 'CU123AA' }
  let(:id) { SecureRandom.uuid }
  let(:start_date) { Time.current.strftime('%Y-%m-%d') }
  let(:end_date) { Time.current.next_day(7).strftime('%Y-%m-%d') }
  let(:url) { %r{payments/paid} }

  context 'when the response status is 200' do
    before do
      stub_request(:post, url).to_return(
        status: 200,
        body: read_raw_file('paid_payments_response.json')
      )
    end

    it 'returns an array of dates' do
      expect(call).to all(be_a_date_string)
    end

    it 'calls API with right params' do
      expect(call)
        .to have_requested(:post, url)
        .with(body: {
                startDate: start_date,
                endDate: end_date,
                vrns: [vrn],
                cleanAirZoneId: id
              })
    end
  end
end
