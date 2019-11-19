# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetPaymentId do
  subject(:service) { described_class.call(session: session, payment_id: id) }

  let(:session) { { vehicle_details: {} } }
  let(:id) { SecureRandom.uuid }

  it 'sets payment id' do
    service
    expect(session[:vehicle_details]['payment_id']).to eq(id)
  end
end
