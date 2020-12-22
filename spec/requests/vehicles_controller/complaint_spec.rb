# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #compliant', type: :request do
  subject { get compliant_vehicles_path }

  before { add_vrn_to_session }

  it 'returns http success' do
    subject
    expect(response).to be_successful
  end
end
