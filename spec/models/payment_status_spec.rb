# frozen_string_literal: true

require 'rails_helper'

describe PaymentStatus, type: :model do
  subject { described_class.new(id) }

  let(:id) { SecureRandom.uuid }
  let(:status) { 'success' }
  let(:email) { 'test@example.com' }
  let(:payment_reference) { SecureRandom.uuid }
  let(:external_id) { SecureRandom.uuid }

  before do
    allow(PaymentsApi).to receive(:payment_status)
      .with(payment_id: id).and_return(
        'paymentId' => id,
        'status' => status,
        'userEmail' => email,
        'referenceNumber' => payment_reference,
        'externalPaymentId' => external_id
      )
  end

  describe '.id' do
    it 'returns id' do
      expect(subject.id).to eq(id)
    end
  end

  describe '.status' do
    it 'returns the uppercase status' do
      expect(subject.status).to eq(status.upcase)
    end
  end

  describe '.payment_reference' do
    it 'returns a proper value' do
      expect(subject.payment_reference).to eq(payment_reference)
    end
  end

  describe '.external_id' do
    it 'returns a proper value' do
      expect(subject.external_id).to eq(external_id)
    end
  end

  describe '.success?' do
    context 'when status is success' do
      it 'returns true' do
        expect(subject).to be_success
      end
    end

    context 'when status is failure' do
      let(:status) { 'failure' }

      it 'returns false' do
        expect(subject).not_to be_success
      end
    end
  end

  describe '.user_email' do
    it 'returns the email' do
      expect(subject.user_email).to eq(email)
    end
  end
end
