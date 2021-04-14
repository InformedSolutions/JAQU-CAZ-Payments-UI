# frozen_string_literal: true

require 'rails_helper'

describe 'ComplianceCheckerApi.unrecognised_compliance' do
  subject { ComplianceCheckerApi.unrecognised_compliance(type, zones) }

  let(:type) { 'car' }
  let(:zones) { %w[birmingham Taxidiscountcaz] }
  let(:url) { %r{/vehicles/unrecognised/#{type}/compliance\?zones=} }

  context 'when call returns 200' do
    before do
      stub_request(:get, url).to_return(
        status: 200,
        body: file_fixture('unrecognised_vehicle_response.json').read
      )
    end

    it 'returns an array of charges' do
      expect(subject['charges']).to be_a(Array)
    end

    it 'returns proper fields' do
      expect(subject['charges'].first.keys).to contain_exactly(
        'cleanAirZoneId',
        'name',
        'charge',
        'tariffCode'
      )
    end

    it 'calls API with right params' do
      expect(subject).to have_requested(:get, url).with(query: { zones: zones.join(',') })
    end
  end

  context 'when call returns 500' do
    before do
      stub_request(:get, url).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end

  context 'when call returns 400' do
    before do
      stub_request(:get, url).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end
end
