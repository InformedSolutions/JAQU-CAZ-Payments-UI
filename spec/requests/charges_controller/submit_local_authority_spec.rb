# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - POST #submit_local_authority', type: :request do
  subject(:http_request) do
    post submit_local_authority_charges_path, params: { 'local-authority': zone_id }
  end

  let(:zone_id) { SecureRandom.uuid }

  context 'with VRN set' do
    before { add_vrn_to_session }

    context 'with selected zone' do
      it 'returns redirect to #daily_charge' do
        expect(http_request).to redirect_to(daily_charge_charges_path)
      end

      it 'sets LA in the session' do
        http_request
        expect(session.dig(:vehicle_details, 'la')).to eq(zone_id)
      end
    end

    context 'without selected zone' do
      let(:zone_id) { nil }

      it 'returns redirect to #local_authority' do
        expect(http_request).to redirect_to(local_authority_charges_path)
      end
    end
  end
end
