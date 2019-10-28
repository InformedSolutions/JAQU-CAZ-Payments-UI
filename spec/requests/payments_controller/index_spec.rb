# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentsController - GET #index', type: :request do
  subject(:http_request) { get payments_path }

  let(:payment_id) { 'XYZ123ABC' }
  let(:success) { true }
  let(:user_email) { 'user_email@example.com' }

  context 'with payment id' do
    before do
      add_to_session(payment_id: payment_id)
      allow(PaymentStatus).to receive(:new).and_return(
        OpenStruct.new(success?: success, user_email: user_email)
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
    end

    context 'when payment status is FAILURE' do
      let(:success) { false }

      it 'redirects to the failure page' do
        expect(response).to redirect_to(failure_payments_path)
      end

      it "doesn't sets user email in the session" do
        expect(session[:vehicle_details]['user_email']).to be_nil
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
