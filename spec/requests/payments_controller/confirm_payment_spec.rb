# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentsController - GET #confirm_payment', type: :request do
  subject(:http_request) { get confirm_payment_payments_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:dates) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:charge) { 10 }
  let(:payment_id) { 'XYZ123ABC' }
  let(:user_email) { 'user_email' }

  before do
    add_vrn_to_session(vrn: vrn)
    add_la_to_session(zone_id: zone_id)
    add_dates_to_session(dates: dates)
    add_daily_charge_to_session(charge: charge)
    add_payment_id_to_session
  end

  it 'returns http success' do
    subject
    expect(response).to have_http_status(:success)
  end
end
