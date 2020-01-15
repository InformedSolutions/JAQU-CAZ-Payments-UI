# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentStatus, type: :model do
  subject(:payment_status) { described_class.new(id, 'Leeds') }

  let(:id) { SecureRandom.uuid }
  let(:status) { 'success' }
  let(:email) { 'test@example.com' }

  before do
    allow(PaymentsApi).to receive(:payment_status)
      .with(payment_id: id, caz_name: 'Leeds').and_return(
        'paymentId' => id, 'status' => status, 'userEmail' => email
      )
  end

  describe '.id' do
    it 'returns id' do
      expect(payment_status.id).to eq(id)
    end
  end

  describe '.status' do
    it 'returns the uppercase status' do
      expect(payment_status.status).to eq(status.upcase)
    end
  end

  describe '.success?' do
    context 'when status is success' do
      it 'returns true' do
        expect(payment_status.success?).to be_truthy
      end
    end

    context 'when status is failure' do
      let(:status) { 'failure' }

      it 'returns false' do
        expect(payment_status.success?).to be_falsey
      end
    end
  end

  describe '.user_email' do
    it 'returns the email' do
      expect(payment_status.user_email).to eq(email)
    end
  end
end
