# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetSelectedWeek do
  subject(:service) { described_class.call(session: session, second_week_selected: second_week_selected) }

  let(:session) { {} }
  let(:second_week_selected) { false }

  context 'when first week is selected' do
    it 'sets correct value to session' do
      service
      expect(session[:second_week_selected]).to eq(false)
    end
  end

  context 'when second week is selected' do
    let(:second_week_selected) { true }

    it 'sets correct value to session' do
      service
      expect(session[:second_week_selected]).to eq(true)
    end
  end

  context 'when clearing both weeks' do
    let(:second_week_selected) { nil }

    it 'clears both values' do
      service
      expect(session[:second_week_selected]).to eq(nil)
    end
  end
end
