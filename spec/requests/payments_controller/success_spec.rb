# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentsController - GET #success', type: :request do
  subject(:http_request) { get success_payments_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:dates) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:charge) { 10 }
  let(:payment_id) { 'XYZ123ABC' }
  let(:user_email) { 'user_email@example.com' }

  before do
    add_to_session(
      vrn: vrn,
      payment_id: payment_id,
      user_email: user_email,
      la_name: 'Leeds',
      dates: dates,
      total_charge: charge
    )
    subject
  end

  it 'returns http success' do
    expect(response).to have_http_status(:success)
  end

  it 'clears details in session' do
    expect(session[:vehicle_details]).to be_nil
  end
end
