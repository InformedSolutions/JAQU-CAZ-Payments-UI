# frozen_string_literal: true

require 'rails_helper'

describe DatesHelper do
  let(:date) { '2019-11-03' }

  describe '.checked_daily?' do
    subject(:method) { helper.checked_daily?(date) }

    let(:date) { '2019-11-01' }

    context 'when there is no date in the session' do
      it { is_expected.to be_falsey }
    end

    context 'when date is in the session' do
      before { session[:vehicle_details] = { 'dates' => [date] } }

      it { is_expected.to be_truthy }
    end

    context 'when date is not in the session' do
      before { session[:vehicle_details] = { 'dates' => ['2019-11-05'] } }

      it { is_expected.to be_falsey }
    end
  end

  describe '.checked_weekly?' do
    subject(:method) { helper.checked_weekly?(date) }

    context 'when there is no date in the session' do
      it { is_expected.to be_falsey }
    end

    context 'when the date is the beginning of the period in the session' do
      before do
        session[:vehicle_details] = { 'dates' => (3..9).map { |day| "2019-11-0#{day}" } }
      end

      it { is_expected.to be_truthy }
    end

    context 'when the date is not the beginning of the period in the session' do
      before do
        session[:vehicle_details] = { 'dates' => (1..7).map { |day| "2019-11-0#{day}" } }
      end

      it { is_expected.to be_falsey }
    end
  end
end
