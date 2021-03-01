# frozen_string_literal: true

require 'rails_helper'

describe 'ChargesController - GET #local_authority', type: :request do
  subject { get local_authority_charges_path }

  let(:transaction_id) { SecureRandom.uuid }
  let(:vrn) { 'CU57ABC' }

  context 'with VRN in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vrn_to_session(vrn: vrn)
    end

    context 'with any chargeable CAZ' do
      before do
        response = read_file('vehicle_compliance_birmingham_response.json')
        dvla_response = response['complianceOutcomes'].map { |caz_data| Caz.new(caz_data) }

        allow(ChargeableZonesService).to receive(:call).and_return(dvla_response)
      end

      context 'when the vehicle has correct data' do
        context 'when the vehicle in registered in the UK' do
          before { subject }

          it 'returns a success response' do
            expect(response).to have_http_status(:success)
          end

          it 'assigns VehicleController#details as return path' do
            expect(assigns(:return_path)).to eq(details_vehicles_path)
          end
        end

        context 'when the vehicle in registered in the Non-UK' do
          before do
            add_vrn_to_session(vrn: vrn, country: 'Non-UK')
            subject
          end

          it 'assigns NonDvlaVehicleController#choose_type as return path' do
            expect(assigns(:return_path)).to eq(choose_type_non_dvla_vehicles_path)
          end
        end
      end

      context 'when the vehicle has incorrect data' do
        before do
          add_vehicle_details_to_session(vrn: vrn, country: 'UK', incorrect: true)
          subject
        end

        it 'assigns VehicleController#incorrect_details as return path' do
          expect(assigns(:return_path)).to eq(incorrect_details_vehicles_path)
        end
      end

      context 'when the vehicle is undetermined' do
        before do
          add_vehicle_details_to_session(vrn: vrn, country: 'UK', undetermined: true)
          subject
        end

        it 'assigns VehicleController#not_determined as return path' do
          expect(assigns(:return_path)).to eq(not_determined_vehicles_path)
        end
      end

      context 'when the vehicle is possible_fraud' do
        before do
          add_vehicle_details_to_session(vrn: vrn, country: 'UK', possible_fraud: true)
          subject
        end

        it 'assigns VehicleController#uk_registered as return path' do
          expect(assigns(:return_path)).to eq(uk_registered_details_vehicles_path)
        end
      end

      context 'when back button was used' do
        let(:history_vehicle_details) { { 'vrn' => 'TST004', 'country' => 'UK' } }

        before do
          url_id ||= SecureRandom.uuid
          add_to_session({ history: { url_id.to_s => { vehicle_details: history_vehicle_details } } })
          get local_authority_charges_path(id: url_id)
        end

        it 'returns a found response' do
          expect(response).to have_http_status(:found)
        end
      end

      context 'when session history is too big' do
        before do
          Rails.configuration.x.max_history_size = 0
          add_to_session({ history: { vehicle_details: {} } })
          subject
        end

        it 'returns a internal_server_error status' do
          expect(response).to have_http_status(:internal_server_error)
        end

        it 'renders :internal_server_error view' do
          expect(response).to render_template('errors/internal_server_error')
        end
      end
    end

    context 'without any chargeable CAZ' do
      before do
        allow(ChargeableZonesService).to receive(:call).and_return([])
        subject
      end

      it 'returns a compliant page' do
        expect(response).to redirect_to(compliant_vehicles_path(id: transaction_id))
      end
    end

    context 'when api raise `Error422Exception` exception' do
      before do
        allow(ChargeableZonesService).to receive(:call).and_raise(
          BaseApi::Error422Exception.new(422, '', '')
        )
        subject
      end

      it 'redirects to not_determined page' do
        expect(response).to redirect_to(not_determined_vehicles_path(id: transaction_id))
      end
    end
  end

  context 'without VRN in the session' do
    before { subject }

    it_behaves_like 'vrn is missing'
  end
end
