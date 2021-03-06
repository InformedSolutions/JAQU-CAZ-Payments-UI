# frozen_string_literal: true

require 'rails_helper'

describe Dates::ValidateSelectedWeeklyDate do
  subject { described_class.new(params: params, charge_start_date: charge_start_date, session: session) }

  let(:params) do
    {
      date_year: year,
      date_month: month,
      date_day: day
    }
  end
  let(:year) { Time.current.year }
  let(:month) { Time.current.month }
  let(:day) { Time.current.day }
  let(:formatted_date) { "#{year}-#{month}-#{day}" }
  let(:charge_start_date) { '2020-01-01' }
  let(:session) do
    {
      vehicle_details: { 'dates' => dates },
      second_week_selected: second_week_selected,
      first_week_start_date: first_week_start_date
    }
  end
  let(:dates) { nil }
  let(:second_week_selected) { false }
  let(:first_week_start_date) { nil }

  context 'when date is in correct format and is in range' do
    before { allow(SessionManipulation::CalculateTotalCharge).to receive(:call).and_return(true) }

    it 'assigns correct value to @start_date variable' do
      expect(subject.start_date).to eq(formatted_date)
    end

    it 'returns true for .valid?' do
      expect(subject.valid?).to eq(true)
    end

    it 'returns correct error if the date is already paid for' do
      expect(subject.error).to eq(I18n.t('not_available', scope: 'dates.weekly'))
    end

    it 'calls CalculateTotalCharge session manipulator' do
      subject.add_dates_to_session
      expect(SessionManipulation::CalculateTotalCharge).to have_received(:call)
    end
  end

  context 'when date is in correct format but was already selected in previous week' do
    let(:second_week_selected) { true }
    let(:first_week_start_date) { formatted_date }
    let(:dates) { Date.current.upto(Date.current + 6.days).map { |d| d.strftime('%Y-%m-%d') } }

    it 'parses the date' do
      expect(subject.start_date).to eq(formatted_date)
    end

    it 'returns false for .valid?' do
      expect(subject.valid?).to eq(false)
    end

    it 'returns correct error message' do
      expect(subject.error).to eq(I18n.t('already_selected', scope: 'dates.weekly'))
    end
  end

  context 'when date is in correct format and in default range, but d-day is in two days' do
    let(:charge_start_date) do
      charge_start = Time.current + 2.days
      "#{charge_start.year}-#{charge_start.month}-#{charge_start.day}"
    end

    it 'returns false for .valid?' do
      expect(subject.valid?).to eq(false)
    end

    it 'returns correct error if the date is already paid for' do
      expect(subject.error).to eq(I18n.t('not_available', scope: 'dates.weekly'))
    end
  end

  context 'when date is in correct format but is out of range' do
    let(:year) { '1842' }
    let(:month) { '5' }
    let(:day) { '14' }

    it 'parses the date' do
      expect(subject.start_date).to eq(formatted_date)
    end

    it 'returns false for .valid?' do
      expect(subject.valid?).to eq(false)
    end

    it 'returns correct error message' do
      expect(subject.error).to eq('Select an available start date')
    end
  end

  context 'when provided date contains non-numeric characters' do
    let(:month) { '%' }

    it_behaves_like 'an invalid weekly selection date'
  end

  context 'when provided date is in incorrect format' do
    let(:day) { '150' }

    it_behaves_like 'an invalid weekly selection date'
  end

  context 'when no date is provided' do
    let(:year) { '' }
    let(:month) { '' }
    let(:day) { '' }

    it_behaves_like 'an invalid weekly selection date'
  end
end
