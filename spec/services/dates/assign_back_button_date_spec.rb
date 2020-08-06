# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates::AssignBackButtonDate do
  include DatesHelper

  subject(:service) { described_class.call(session: session, second_week_selected: second_week_selected) }

  let(:session) do
    {
      first_week_start_date: first_week_start_date,
      second_week_start_date: second_week_start_date,
      first_week_back_button: first_week_back_button,
      second_week_back_button: second_week_back_button,
      vehicle_details: {
        'dates' => ['1980-12-28']
      }
    }
  end

  let(:first_week_start_date) { '2020-05-01' }
  let(:second_week_start_date) { nil }
  let(:first_week_back_button) { nil }
  let(:second_week_back_button) { nil }

  let(:second_week_selected) { false }

  context 'when back button takes the user to first week' do
    before { service }

    it 'sets correct back button date' do
      expect(session[:first_week_back_button]).to eq('2020-05-01')
    end

    it 'clears first week start date' do
      expect(session[:first_week_start_date]).to eq(nil)
    end

    it 'clears paid dates' do
      expect(session[:vehicle_details]['dates']).to eq([])
    end
  end

  context 'when back button takes the user to second week' do
    let(:second_week_selected) { true }
    let(:second_week_start_date) { '2020-05-08' }

    before { service }

    it 'sets correct back button date' do
      expect(session[:second_week_back_button]).to eq('2020-05-08')
    end

    it 'clears second week start date' do
      expect(session[:second_week_start_date]).to eq(nil)
    end

    it 'sets paid dates to include only first week' do
      expect(session[:vehicle_details]['dates']).to eq(disable_week(first_week_start_date))
    end
  end

  context 'when both back button dates should be cleared' do
    let(:second_week_selected) { nil }
    let(:first_week_back_button) { '2020-05-01' }
    let(:second_week_back_button) { '2020-05-08' }

    before { service }

    it 'clears both dates' do
      expect(session[:first_week_back_button]).to eq(nil)
      expect(session[:second_week_back_button]).to eq(nil)
    end
  end
end
