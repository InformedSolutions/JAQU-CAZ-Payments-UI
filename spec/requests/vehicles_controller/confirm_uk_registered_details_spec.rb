# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - POST #confirm_uk_registered_details', type: :request do
  subject do
    post confirm_uk_registered_details_vehicles_path, params: { 'confirm-vehicle': confirmation }
  end

  let(:transaction_id) { SecureRandom.uuid }
  let(:confirmation) { 'yes' }

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

    it 'redirects to confirm uk registered details page' do
      expect(response).to redirect_to(uk_registered_details_vehicles_path(id: transaction_id))
    end
  end
end
