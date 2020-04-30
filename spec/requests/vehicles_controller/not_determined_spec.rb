# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #not_determined', type: :request do
  subject(:http_request) { get not_determined_vehicles_path }

  let(:vrn) { 'CU57ABC' }

  before do
    add_vrn_to_session(vrn: vrn)
    http_request
  end

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end

  it 'assigns the @vrn' do
    expect(assigns(:types)).to eq(VehicleTypes.call)
  end
end
