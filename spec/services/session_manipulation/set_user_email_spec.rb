# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetUserEmail do
  subject(:service) { described_class.call(session: session, email: email) }

  let(:session) { { vehicle_details: {} } }
  let(:email) { 'test@example.com' }

  it 'sets email' do
    service
    expect(session[:vehicle_details]['user_email']).to eq(email)
  end
end
