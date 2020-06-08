# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe 'GET #build_id' do
    subject { get build_id_path }

    context 'when BUILD_ID is not defined' do
      before { subject }

      it 'returns a ok response' do
        expect(response).to be_successful
      end

      it 'returns undefined body response' do
        expect(response.body).to eq('undefined')
      end
    end

    context 'when BUILD_ID is defined' do
      let(:build_id) { '50.0' }

      before do
        allow(ENV).to receive(:fetch).with('BUILD_ID', 'undefined').and_return(build_id)
        subject
      end

      it 'returns BUILD_ID' do
        expect(response.body).to eq(build_id)
      end
    end
  end
end
