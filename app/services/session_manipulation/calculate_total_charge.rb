# frozen_string_literal: true

module SessionManipulation
  class CalculateTotalCharge < BaseManipulator
    LEVEL = 5

    def initialize(session:, dates:, weekly: false)
      @session = session
      @dates = dates
      @weekly = weekly
    end

    def call
      weekly ? weekly_total_charge : daily_total_charge
    end

    private

    def daily_total_charge
      total_charge = session[SESSION_KEY]['daily_charge'] * dates.length
      add_fields(dates: dates, total_charge: total_charge, weekly: false)
    end

    def weekly_total_charge
      add_fields(dates: weekly_dates, total_charge: 50, weekly: true)
    end

    def weekly_dates
      selected_date = Date.strptime(dates.first, Dates::Base::VALUE_DATE_FORMAT)
      selected_date
        .upto(selected_date + 6.days)
        .map { |date| date.strftime(Dates::Base::VALUE_DATE_FORMAT) }
    end

    attr_reader :dates, :weekly
  end
end
