# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #enter_details', type: :request do
  subject { get enter_details_vehicles_path, headers: { HTTP_REFERER: referer } }

  let(:referer) { '' }

  it 'returns a success response' do
    subject
    expect(response).to have_http_status(:success)
  end

  context 'user clicking Pay for another vehicle from the Success payment page' do
    let(:referer) { 'http://www.example.com/payments/success' }

    it 'assigns @hide_session_values' do
      subject
      expect(assigns(:hide_session_values)).to be_truthy
    end
  end
end
