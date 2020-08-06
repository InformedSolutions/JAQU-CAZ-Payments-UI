# frozen_string_literal: true

##
# Module used to build weekly days as a array of hashes.
#
module Dates
  ##
  # Class is used to build the list of available weekly dates
  # and display them on +app/views/dates/select_date_weekly.html.haml+
  #
  class Weekly < Base
    include DatesHelper

    # Overrides default by setting start and end dates
    def initialize(vrn:, zone_id:, charge_start_date:, second_week_selected:, week_start_days:)
      super(vrn: vrn, zone_id: zone_id)
      @start_date = today - 6.days
      @end_date = today + 12.days
      @charge_start_date = charge_start_date
      @second_week_selected = second_week_selected
      @week_start_days = week_start_days
    end

    # Build the list of dates and return them, e.g.
    # [{value: "2019-10-11", name: "Friday 11 October 2019", today: false},...]
    def chargeable_dates
      @chargeable_dates ||= begin
        payment_window_dates = (calculated_start_date..(today + 6.days)).map { |date| parse(date) }

        if !@second_week_selected
          payment_window_dates
        else
          disable_already_chosen_dates(payment_window_dates)
        end
      end
    end

    # Checks if a week starting from today can be paid
    def pay_week_starts_today?
      return false if charge_start_date > today_date

      week_range_from_today = (today..(today + 7.days))
      paid_dates.each do |paid_day|
        parsed_paid_day = Date.parse(paid_day)
        return false if week_range_from_today.include?(parsed_paid_day)
      end
    end

    def today_date
      today.strftime(VALUE_DATE_FORMAT)
    end

    private

    # Create hash of dates
    def parse(date)
      {
        name: date.strftime(DISPLAY_DATE_FORMAT),
        value: date.strftime(VALUE_DATE_FORMAT),
        today: date.today?,
        hint: weekly_date_hint(date),
        disabled: disabled?(date)
      }
    end

    # Checks if array of the next 6 days has common elements with paid_dates array
    def disabled?(date)
      week_array = (date..(date + 6.days)).map { |d| d.strftime(VALUE_DATE_FORMAT) }
      (week_array & paid_dates).any?
    end

    def weekly_date_hint(date)
      week_end_date = (date + 6.days).strftime(DISPLAY_DATE_FORMAT)
      "Your weekly charge is valid until 11.59pm on #{week_end_date}"
    end

    # Disables dates chosen in first week during weekly payment
    # Returns array of parsed dates
    def disable_already_chosen_dates(payment_window_dates)
      session_dates = @week_start_days.map { |day| disable_week(day) }.flatten
      return payment_window_dates if session_dates.empty?

      payment_window_dates.inject([]) do |all_dates, date|
        session_dates.include?(date[:value]) && date[:disabled] = true

        all_dates << date
      end
    end
  end
end
