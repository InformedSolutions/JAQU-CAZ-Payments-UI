# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentsApi.payment_status' do
  subject(:call) { PaymentsApi.payment_status(payment_id: id) }

  let(:id) { SecureRandom.uuid }
  let(:status) { 'success' }
  let(:email) { 'test@example.com' }

  context 'when the response status is 200' do
    before do
      stub_request(:put, /payments/).to_return(
        status: 200,
        body: { 'paymentId' => id, 'status' => status, 'userEmail' => email }.to_json
      )
    end

    it 'returns proper fields' do
      expect(call.keys).to contain_exactly('paymentId', 'status', 'userEmail')
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:put, /payments/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
