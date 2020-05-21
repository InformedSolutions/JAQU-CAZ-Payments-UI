# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ComplianceCheckerApi.clean_air_zones' do
  subject(:call) { ComplianceCheckerApi.clean_air_zones }

  context 'when the response status is 200' do
    before do
      caz_details = file_fixture('caz_list_response.json').read
      stub_request(:get, /clean-air-zones/).to_return(
        status: 200,
        body: caz_details
      )
    end

    it 'returns an array' do
      expect(call).to be_a(Array)
    end

    it 'returns an array of CAZ objects' do
      expect(call.first.keys).to contain_exactly(
        'cleanAirZoneId',
        'name',
        'boundaryUrl',
        'activeChargeStartDate'
      )
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:get, /clean-air-zones/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
