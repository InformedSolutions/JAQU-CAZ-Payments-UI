# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentsApi.create_payment' do
  subject(:call) do
    PaymentsApi.create_payment(
      vrn: vrn, amount: amount, zone_id: zone_id, days: days, return_url: return_url
    )
  end

  let(:vrn) { 'CU57ABC' }
  let(:amount) { 80 }
  let(:zone_id) { SecureRandom.uuid }
  let(:days) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:return_url) { 'www.wp.pl' }

  context 'when the response status is 200' do
    before do
      stub_request(:post, /payments/).to_return(
        status: 200,
        body: { 'paymentId' => SecureRandom.uuid, 'nextUrl' => 'www.wp.pl' }.to_json
      )
    end

    it 'returns proper fields' do
      expect(call.keys).to contain_exactly('paymentId', 'nextUrl')
    end

    it 'calls API with right params' do
      expect(call).to have_requested(:post, /payments/).with(body: {
        days: days, vrn: vrn, amount: amount,
        'cleanAirZoneId' => zone_id,
        'returnUrl' => return_url
      }.to_json)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:post, /payments/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
