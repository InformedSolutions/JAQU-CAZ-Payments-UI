# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #vehicle_type', type: :request do
  subject { get choose_vehicle_vehicles_path }

  before { add_vrn_to_session }

  it 'returns a success response' do
    subject
    expect(response).to be_successful
  end
end
