# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetSelectedWeek do
  subject(:service) { described_class.call(session: session, week_selected: week_selected) }

  let(:session) { {} }
  let(:week_selected) { 'first' }

  context 'when first week is selected' do
    it 'sets correct value to session' do
      service
      expect(session[:first_week_dates_selected]).to eq(true)
    end
  end

  context 'when second week is selected' do
    let(:week_selected) { 'second' }

    it 'sets correct value to session' do
      service
      expect(session[:second_week_selected]).to eq(true)
    end
  end

  context 'when clearing both weeks' do
    let(:week_selected) { '' }

    it 'clears both values' do
      service
      expect(session[:first_week_dates_selected]).to eq(false)
      expect(session[:second_week_selected]).to eq(false)
    end
  end
end
