# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #confirm_details', type: :request do
  subject(:http_request) { get confirm_details_vehicles_path }

  before { add_vrn_to_session }

  before do
    http_request
  end

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end
end
