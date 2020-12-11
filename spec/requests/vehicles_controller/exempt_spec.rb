# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #exempt', type: :request do
  subject { get exempt_vehicles_path }

  context 'with VRN in session' do
    before do
      add_vrn_to_session
    end

    it 'returns http success' do
      subject
      expect(response).to be_successful
    end
  end

  context 'without VRN' do
    it 'redirects to enter details page' do
      subject
      expect(response).to redirect_to(enter_details_vehicles_path)
    end
  end
end
