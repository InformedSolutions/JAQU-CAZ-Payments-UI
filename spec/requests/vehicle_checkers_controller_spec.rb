# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehicleCheckersController, type: :request do
  describe 'GET #enter_details' do
    subject { get enter_details_vehicle_checkers_path }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
