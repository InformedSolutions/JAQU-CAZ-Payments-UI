# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates::ValidateSelectedWeeklyDate do
  subject(:service) { described_class.new(params: date_partials) }

  context 'when date is in correct format and is in range' do
    year = Time.current.year
    month = Time.current.month
    day = Time.current.day

    let(:date_partials) do
      {
        date_year: year,
        date_month: month,
        date_day: day
      }
    end

    it 'assigns correct value to @start_date variable' do
      expect(service.start_date).to eq("#{year}-#{month}-#{day}")
    end

    it 'returns true for .date_in_range?' do
      expect(service.date_in_range?).to eq(true)
    end

    it 'returns true for .valid?' do
      expect(service.valid?).to eq(true)
    end

    it 'returns correct error if the date is already paid for' do
      expect(service.error).to eq(I18n.t('paid', scope: 'dates.weekly'))
    end
  end

  context 'when date is in correct format but is out of range' do
    year = '1842'
    month = '5'
    day = '14'

    let(:date_partials) do
      {
        date_year: year,
        date_month: month,
        date_day: day
      }
    end

    it 'parses the date' do
      expect(service.parse_date(date_partials)).to eq('1842-5-14')
    end

    it 'returns false for .date_in_range?' do
      expect(service.date_in_range?).to eq(false)
    end

    it 'returns false for .valid?' do
      expect(service.valid?).to eq(false)
    end

    it 'returns correct error message' do
      start_day = (Date.current - 6.days).strftime('%d %m %Y')
      end_day = (Date.current + 6.days).strftime('%d %m %Y')

      expect(service.error).to eq("Select a start date between #{start_day} and #{end_day}")
    end
  end

  context 'when no date is provided' do
    let(:date_partials) do
      {
        date_year: '',
        date_month: '',
        date_day: ''
      }
    end

    it_behaves_like 'an invalid weekly selection date'
  end

  context 'when provided date contains non-numeric characters' do
    let(:date_partials) do
      {
        date_year: '2020',
        date_month: 'a',
        date_day: '%'
      }
    end

    it_behaves_like 'an invalid weekly selection date'
  end

  context 'when provided date is in incorrect format' do
    let(:date_partials) do
      {
        date_year: '2020',
        date_month: '6',
        date_day: '150'
      }
    end

    it_behaves_like 'an invalid weekly selection date'
  end
end
