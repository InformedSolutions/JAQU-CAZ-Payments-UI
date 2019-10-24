# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentsController - POST #create', type: :request do
  subject(:http_request) { post payments_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:dates) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:charge) { 10 }
  let(:payment_id) { 'XYZ123ABC' }
  let(:redirect_url) { 'https://www.payments.service.gov.uk' }

  before do
    add_vrn_to_session(vrn: vrn)
    add_la_to_session(zone_id: zone_id)
    add_dates_to_session(dates: dates)
    add_daily_charge_to_session(charge: charge)
    allow(Payment).to receive(:new).and_return(
      OpenStruct.new(payment_id: payment_id, gov_uk_pay_url: redirect_url)
    )
  end

  skip it 'redirects to the link from Payments API' do
    http_request
    expect(response).to redirect_to(redirect_url)
  end

  skip it 'calls Payment model with right params' do
    expect(Payment).to receive(:new).with(
      {
        'vrn' => vrn,
        'la' => zone_id,
        'daily_charge' => charge,
        'dates' => dates,
        'country' => anything,
        'la_name' => anything
      }, payments_url
    )
    http_request
  end

  it 'sets payment_id in the session' do
    http_request
    expect(session[:vehicle_details]['payment_id']).to eq(payment_id)
  end

  context 'when called twice' do
    let(:repeated_request) { post payments_path }
    before { http_request }

    it 'does not call Payment model second time' do
      expect(Payment).not_to receive(:new)
      repeated_request
    end

    it 'redirects to :index' do
      repeated_request
      expect(response).to redirect_to(payments_path)
    end
  end
end
