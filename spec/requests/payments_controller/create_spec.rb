# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - POST #create', type: :request do
  subject { post payments_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:dates) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:charge) { 10 }
  let(:payment_id) { 'XYZ123ABC' }
  let(:redirect_url) { 'https://www.payments.service.gov.uk' }

  before do
    add_vehicle_details_to_session(
      vrn: vrn,
      country: 'UK',
      la_id: zone_id,
      la_name: 'Taxidiscountcaz',
      dates: dates,
      total_charge: charge
    )
  end

  context 'when call to API is successful' do
    before do
      allow(Payment).to receive(:new).and_return(
        OpenStruct.new(payment_id: payment_id, gov_uk_pay_url: redirect_url)
      )
    end

    it 'redirects to the link from Payments API' do
      subject
      expect(response).to redirect_to(redirect_url)
    end

    it 'calls Payment model with right params' do
      subject
      expect(Payment).to have_received(:new).with(
        {
          'vrn' => vrn,
          'la_id' => zone_id,
          'total_charge' => charge,
          'dates' => dates,
          'country' => anything,
          'la_name' => anything
        }, payments_url
      )
    end

    it 'sets payment_id in the session' do
      subject
      expect(session[:vehicle_details]['payment_id']).to eq(payment_id)
    end

    context 'when called twice' do
      let(:repeated_request) { post payments_path }
      let(:second_payment_id) { 'LOREM01234IPSUM' }

      before do
        subject
        allow(Payment).to receive(:new).and_return(
          OpenStruct.new(payment_id: second_payment_id, gov_uk_pay_url: redirect_url)
        )
      end

      it 'calls the Payment model a second time' do
        repeated_request
        expect(Payment).to have_received(:new).with(
          {
            'vrn' => vrn,
            'la_id' => zone_id,
            'total_charge' => charge,
            'dates' => dates,
            'country' => anything,
            'la_name' => anything
          }, payments_url
        ).twice
      end

      it 'sets payment_id in the session' do
        repeated_request
        expect(session[:vehicle_details]['payment_id']).to eq(second_payment_id)
      end
    end
  end

  context 'when call is not successful' do
    before do
      allow(PaymentsApi).to receive(:create_payment).and_raise(
        BaseApi::Error500Exception.new(500, 'internal error', message: 'Boom')
      )
    end

    it_behaves_like 'an unsuccessful API call'
  end
end
