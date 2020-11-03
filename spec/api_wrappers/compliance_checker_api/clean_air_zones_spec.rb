# frozen_string_literal: true

require 'rails_helper'

describe 'ComplianceCheckerApi.clean_air_zones' do
  subject { ComplianceCheckerApi.clean_air_zones }

  context 'when the response status is 200' do
    before do
      stub_request(:get, /clean-air-zones/).to_return(
        status: 200,
        body: file_fixture('caz_list_response.json').read
      )
    end

    it 'returns an array' do
      expect(subject).to be_a(Array)
    end

    it 'returns an array of CAZ objects' do
      expect(subject.first.keys).to contain_exactly(
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
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
