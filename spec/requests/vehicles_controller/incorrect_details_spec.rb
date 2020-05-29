# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #incorrect_details', type: :request do
  subject { get incorrect_details_vehicles_path }

  before { add_vrn_to_session }

  it 'returns a success response' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'sets incorrect in the session' do
    subject
    expect(session[:vehicle_details]['incorrect']).to be_truthy
  end
end
