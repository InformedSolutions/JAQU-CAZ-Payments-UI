# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - POST #confirm_details', type: :request do
  subject { post confirm_details_vehicles_path, params: { 'confirm-vehicle' => confirmation } }

  let(:transaction_id) { SecureRandom.uuid }
  let(:confirmation) { 'yes' }

  context 'when vehicle is recognized' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vrn_to_session
      subject
    end

    context 'when user confirms details' do
      it 'redirects to select LA page' do
        expect(response).to redirect_to(local_authority_charges_path(id: transaction_id))
      end
    end

    context 'when user does not confirm details' do
      let(:confirmation) { 'no' }

      it 'redirects to incorrect details page' do
        expect(response).to redirect_to(incorrect_details_vehicles_path(id: transaction_id))
      end
    end

    context 'when confirmation is empty' do
      let(:confirmation) { '' }

      it 'redirects to confirm details page' do
        expect(response).to redirect_to(details_vehicles_path(id: transaction_id))
      end
    end
  end

  context 'when vehicle is undetermined' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vehicle_details_to_session(vrn: 'CU57ABC', country: 'UK', undetermined: true)
      subject
    end

    it 'redirects to not determined vehicle page' do
      expect(response).to redirect_to(not_determined_vehicles_path(id: transaction_id))
    end
  end
end
