# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #incorrect_details', type: :request do
  subject(:http_request) { get incorrect_details_vehicles_path }

  before { add_vrn_to_session }

  it 'returns a success response' do
    http_request
    expect(response).to have_http_status(:success)
  end

  it 'sets incorrect in the session' do
    http_request
    expect(session[:vehicle_details]['incorrect']).to be_truthy
  end
end
