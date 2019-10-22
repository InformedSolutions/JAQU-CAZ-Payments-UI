# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - GET #local_authority', type: :request do
  subject(:http_request) { get local_authority_charges_path }

  let(:vrn) { 'CU57ABC' }
  let(:caz_data) do
    {
      'cleanAirZoneId' => '5cd7441d-766f-48ff-b8ad-1809586fea37',
      'name' => 'Birmingham',
      'boundaryUrl' => 'https://www.wp.pl'
    }
  end

  context 'with VRN in the session' do
    before { add_vrn_to_session(vrn: vrn) }

    context 'with any chargeable CAZ' do
      before do
        caz_list = read_file('caz_list_response.json')
        allow(ChargeableZonesService).to receive(:call).and_return(caz_list['cleanAirZones'])
        http_request
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'without any chargeable CAZ' do
      before do
        allow(ChargeableZonesService).to receive(:call).and_return([])
        http_request
      end

      it 'returns a compliant page' do
        expect(response).to redirect_to(compliant_vehicles_path)
      end
    end
  end

  context 'without VRN in the session' do
    before { http_request }

    it_behaves_like 'vrn is missing'
  end
end
