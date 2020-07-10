# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'NonDvlaVehiclesController - POST #confirm_registration', type: :request do
  subject do
    post confirm_registration_non_dvla_vehicles_path, params: { 'confirm-registration': confirm }
  end

  let(:confirm) { 'yes' }

  before do
    add_vrn_to_session
    subject
  end

  context 'when user confirms the registration' do
    it 'redirects to the choose type page' do
      expect(response).to redirect_to(choose_type_non_dvla_vehicles_path)
    end
  end

  context 'when user not confirms the registration' do
    let(:confirm) { nil }

    it 'redirects to the non_dvla_vehicles index page' do
      expect(response).to redirect_to(non_dvla_vehicles_path)
    end
  end
end
