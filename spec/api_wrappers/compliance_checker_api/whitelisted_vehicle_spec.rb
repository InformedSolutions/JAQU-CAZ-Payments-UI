# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ComplianceCheckerApi.whitelisted_vehicle' do
  subject(:call) { ComplianceCheckerApi.whitelisted_vehicle(vrn) }

  let(:vrn) { 'CU57ABC' }

  context 'when call returns 200' do
    before do
      whitelisted_vehicle = file_fixture('whitelisted_vehicle_response.json').read
      stub_request(:get, /whitelisted-vehicles/).to_return(
        status: 200,
        body: whitelisted_vehicle
      )
    end

    it 'returns proper fields' do
      expect(call.keys).to include('vrn')
    end
  end

  context 'when call returns 500' do
    before do
      stub_request(:get, /whitelisted-vehicles/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error500Exception)
    end
  end

  context 'when call returns 400' do
    before do
      stub_request(:get, /whitelisted-vehicles/).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when call returns 404' do
    before do
      stub_request(:get, /whitelisted-vehicles/).to_return(
        status: 404,
        body: { 'message' => "Vehicle with registration number #{vrn} was not found" }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when call return 422' do
    before do
      stub_request(:get, /whitelisted-vehicles/).to_return(
        status: 422,
        body: { 'message' => "#{vrn} is an invalid registration number" }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
