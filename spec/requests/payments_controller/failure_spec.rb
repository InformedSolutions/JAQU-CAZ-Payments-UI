# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentsController - GET #success', type: :request do
  subject { get failure_payments_path }

  let(:payment_id) { 'XYZ123ABC' }
  let(:vrn) { 'CU57ABC' }

  before do
    add_to_session(payment_id: payment_id, vrn: vrn)
    subject
  end

  it 'returns http success' do
    expect(response).to have_http_status(:success)
  end

  it 'clears payment details in session' do
    expect(session[:vehicle_details]['payment_id']).to be_nil
  end

  it 'does not clear other details in session' do
    expect(session[:vehicle_details]['vrn']).to eq(vrn)
  end
end
