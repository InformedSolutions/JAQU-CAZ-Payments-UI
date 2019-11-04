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
    # Build the list of dates and return them, e.g.
    # [{value: "2019-10-11", name: "Friday 11 October 2019", today: false},...]
    def call
      ((today - 1.day)..(today + 6.days)).map { |date| parse(date) }
    end

    private

    # Create hash of dates
    def parse(date)
      {
        name: date.strftime(DISPLAY_DATE_FORMAT),
        value: date.strftime(VALUE_DATE_FORMAT),
        today: date.today?,
        hint: weekly_date_hint(date)
      }
    end

    def weekly_date_hint(date)
      end_date = (date + 6.days).strftime(DISPLAY_DATE_FORMAT)
      "Your weekly ticket is valid until 11.59pm on #{end_date}"
    end
  end
end
