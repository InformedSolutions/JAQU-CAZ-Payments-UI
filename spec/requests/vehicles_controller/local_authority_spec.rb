# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - GET #local_authority', type: :request do
  subject { post local_authority_vehicles_path, params: { 'confirm-vehicle': confirm } }

  let(:confirm) { 'yes' }
  before { add_vrn_to_session }

  context "when user confirms the vehicle's details" do
    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end
  end

  context "when user not confirms the vehicle's details" do
    let(:confirm) { 'no' }

    it 'redirects to enter details page' do
      subject
      expect(response).to redirect_to(incorrect_details_vehicles_path)
    end
  end
end
