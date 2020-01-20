# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentsController - GET #index', type: :request do
  subject(:http_request) { get payments_path }

  let(:payment_id) { 'XYZ123ABC' }
  let(:success) { true }
  let(:user_email) { 'user_email@example.com' }
  let(:payment_reference) { 1 }
  let(:external_id) { 'external_id' }

  context 'with payment id' do
    before do
      add_to_session(payment_id: payment_id)
      allow(PaymentStatus).to receive(:new).and_return(
        instance_double('PaymentStatus',
                        success?: success,
                        user_email: user_email,
                        payment_reference: payment_reference,
                        external_id: external_id)
      )
      http_request
    end

    context 'when payment status is SUCCESS' do
      it 'redirects to the success page' do
        expect(response).to redirect_to(success_payments_path)
      end

      it 'sets user email in the session' do
        expect(session[:vehicle_details]['user_email']).to eq(user_email)
      end

      it 'sets payment reference in the session' do
        expect(session[:vehicle_details]['payment_reference']).to eq(payment_reference)
      end

      it 'sets external id in the session' do
        expect(session[:vehicle_details]['external_id']).to eq(external_id)
      end
    end

    context 'when payment status is FAILURE' do
      let(:success) { false }

      it 'redirects to the failure page' do
        expect(response).to redirect_to(failure_payments_path)
      end

      it 'doesn\'t set user email in the session' do
        expect(session[:vehicle_details]['user_email']).to be_nil
      end

      it 'doesn\'t set payment reference in the session' do
        expect(session[:vehicle_details]['payment_reference']).to be_nil
      end

      it 'doesn\'t set external id in the session' do
        expect(session[:vehicle_details]['external_id']).to be_nil
      end
    end
  end

  context 'when payment id is missing' do
    it 'redirects to the :enter_details' do
      http_request
      expect(response).to redirect_to(enter_details_vehicles_path)
    end
  end
end
