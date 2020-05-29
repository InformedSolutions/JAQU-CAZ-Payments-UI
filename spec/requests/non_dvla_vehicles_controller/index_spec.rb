# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'NonDvlaVehiclesController - GET #index', type: :request do
  subject { get non_dvla_vehicles_path }

  let(:whitelisted_vehicle_instance) { instance_double 'WhitelistedVehicle', exempt?: exempt }
  let(:exempt) { false }
  before do
    allow(WhitelistedVehicle).to receive(:new)
      .and_return(whitelisted_vehicle_instance)
  end

  context 'when vehicle is not exempted' do
    context 'with VRN in the session' do
      before do
        add_vrn_to_session
        subject
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'without VRN in the session' do
      before { subject }

      it 'returns a redirect to :enter_details' do
        expect(response).to redirect_to(enter_details_vehicles_path)
      end
    end
  end

  context 'when vehicle is exempted' do
    let(:exempt) { true }

    context 'with VRN in the session' do
      before do
        add_vrn_to_session
        subject
      end

      it 'returns a redirect to :exempt_vehicles' do
        expect(response).to redirect_to(exempt_vehicles_path)
      end
    end

    context 'without VRN in the session' do
      before { subject }

      it 'returns a redirect to :enter_details' do
        expect(response).to redirect_to(enter_details_vehicles_path)
      end
    end
  end
end
