# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #unrecognised', type: :request do
  subject { get unrecognised_vehicles_path }

  let(:vrn) { 'CU57ABC' }

  before do
    add_vrn_to_session(vrn: vrn)
    subject
  end

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end

  it 'assigns the @vrn' do
    expect(assigns(:vrn)).to eq(vrn)
  end
end
