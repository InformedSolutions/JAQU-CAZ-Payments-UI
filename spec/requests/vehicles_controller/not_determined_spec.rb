# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #not_determined', type: :request do
  subject { get not_determined_vehicles_path }

  before do
    add_vrn_to_session(vrn: 'CU57ABC')
    subject
  end

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end

  it 'assigns the @vrn' do
    expect(assigns(:types)).to eq(VehicleTypes.call)
  end
end
