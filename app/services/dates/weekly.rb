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
    # Overrides default by setting start and end dates
    def initialize(vrn:, zone_id:)
      super(vrn: vrn, zone_id: zone_id)
      @start_date = today - 1.day
      @end_date = today + 12.days
    end

    # Build the list of dates and return them, e.g.
    # [{value: "2019-10-11", name: "Friday 11 October 2019", today: false},...]
    def call
      (start_date..(today + 6.days)).map { |date| parse(date) }
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
      "Your weekly ticket is valid until 11.59pm on #{week_end_date}"
    end
  end
end
