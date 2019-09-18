# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #enter_details', type: :request do
  subject(:http_request) { get enter_details_vehicles_path }

  it 'returns a success response' do
    http_request
    expect(response).to have_http_status(:success)
  end
end
