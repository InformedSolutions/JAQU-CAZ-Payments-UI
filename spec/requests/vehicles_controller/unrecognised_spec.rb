# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #unrecognised', type: :request do
  subject(:http_request) { get unrecognised_vehicles_path }

  before { add_vrn_to_session }

  it 'returns a success response' do
    http_request
    expect(response).to have_http_status(:success)
  end
end
