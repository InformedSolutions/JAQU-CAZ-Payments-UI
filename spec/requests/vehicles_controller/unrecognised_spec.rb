# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #unrecognised', type: :request do
  subject(:http_request) { get unrecognised_vehicles_path }

  let(:vrn) { 'CU57ABC' }

  before do
    add_vrn_to_session(vrn: vrn)
    http_request
  end

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end

  it 'sets unrecognised in the session' do
    expect(session[:vehicle_details]['unrecognised']).to be_truthy
  end

  it 'assigns the @vrn' do
    expect(assigns(:vrn)).to eq(vrn)
  end
end
