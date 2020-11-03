# frozen_string_literal: true

require 'rails_helper'

describe 'ComplianceCheckerApi.register_details' do
  subject { ComplianceCheckerApi.register_details(vrn) }

  let(:vrn) { 'CAS310' }

  context 'when call returns 200' do
    before do
      stub_request(:get, /register-details/).to_return(
        status: 200,
        body: file_fixture('register_details_response.json').read
      )
    end

    it 'returns proper fields' do
      expect(subject.keys).to contain_exactly(
        'registerCompliant',
        'registerExempt',
        'registeredMOD',
        'registeredGPW',
        'registeredNTR',
        'registeredRetrofit'
      )
    end
  end

  context 'when call returns 500' do
    before do
      stub_request(:get, /register-details/).to_return(
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
      stub_request(:get, /register-details/).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises Error400Exception' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when call returns 404' do
    before do
      stub_request(:get, /register-details/).to_return(
        status: 404,
        body: { 'message' => "Vehicle with registration number #{vrn} was not found" }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when call returns 422' do
    before do
      stub_request(:get, /register-details/).to_return(
        status: 422,
        body: { 'message' => "#{vrn} is an invalid registration number" }.to_json
      )
    end

    it 'raises Error422Exception' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
