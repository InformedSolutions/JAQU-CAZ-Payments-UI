# frozen_string_literal: true

require 'rails_helper'

describe 'NonDvlaVehiclesController - GET #index', type: :request do
  subject { get non_dvla_vehicles_path }

  let(:transaction_id) { SecureRandom.uuid }
  let(:register_compliant) { false }
  let(:register_exempt) { false }

  before do
    stub = instance_double('RegisterDetails', register_compliant?: register_compliant,
                                              register_exempt?: register_exempt)
    allow(RegisterDetails).to receive(:new).and_return(stub)
  end

  context 'when vehicle is neither exempted nor compliant' do
    context 'with VRN in the session' do
      before do
        add_transaction_id_to_session(transaction_id)
        add_vrn_to_session
        subject
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'does not perform redirect' do
        expect(response).not_to be_redirect
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
    let(:register_exempt) { true }

    context 'with VRN in the session' do
      before do
        add_transaction_id_to_session(transaction_id)
        add_vrn_to_session
        subject
      end

      it 'returns a redirect to :exempt_vehicles' do
        expect(response).to redirect_to(exempt_vehicles_path(id: transaction_id))
      end
    end

    context 'without VRN in the session' do
      before { subject }

      it 'returns a redirect to :enter_details' do
        expect(response).to redirect_to(enter_details_vehicles_path)
      end
    end
  end

  context 'when vehicle is compliant' do
    let(:register_compliant) { true }

    context 'with VRN in the session' do
      before do
        add_transaction_id_to_session(transaction_id)
        add_vrn_to_session
        subject
      end

      it 'returns a redirect to :exempt_vehicles' do
        expect(response).to redirect_to(exempt_vehicles_path(id: transaction_id))
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
