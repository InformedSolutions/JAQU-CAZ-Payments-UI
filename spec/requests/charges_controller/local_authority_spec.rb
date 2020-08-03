# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - GET #local_authority', type: :request do
  subject { get local_authority_charges_path }

  let(:vrn) { 'CU57ABC' }

  context 'with VRN in the session' do
    before { add_vrn_to_session(vrn: vrn) }

    context 'with any chargeable CAZ' do
      before do
        response = read_file('vehicle_compliance_birmingham_response.json')
        dvla_response = response['complianceOutcomes'].map { |caz_data| Caz.new(caz_data) }

        allow(ChargeableZonesService)
          .to receive(:call)
          .and_return(dvla_response)
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

        context 'when the vehicle in registered in the UK' do
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
          add_to_session(vrn: vrn, country: 'UK', incorrect: true)
          subject
        end

        it 'assigns VehicleController#incorrect_details as return path' do
          expect(assigns(:return_path)).to eq(incorrect_details_vehicles_path)
        end
      end
    end

    context 'without any chargeable CAZ' do
      before do
        allow(ChargeableZonesService).to receive(:call).and_return([])
        subject
      end

      it 'returns a compliant page' do
        expect(response).to redirect_to(compliant_vehicles_path)
      end
    end
  end

  context 'without VRN in the session' do
    before { subject }

    it_behaves_like 'vrn is missing'
  end
end
