# frozen_string_literal: true

##
# Module used to build daily days as a array of hashes.
#
module Dates
  ##
  # Class is used to build the list of available daily dates
  # and display them on +app/views/dates/select_daily_date.html.haml+
  #
  class Daily < Base
    # Build the list of dates and return them, e.g.
    # [{value: "2019-10-11", name: "Friday 11 October 2019", today: false},...]
    def call
      ((today - 6.days)..(today + 6.days)).map { |date| parse(date) }
    end

    private

    # Create hash of dates
    def parse(date)
      {
        name: date.strftime(DISPLAY_DATE_FORMAT),
        value: date.strftime(VALUE_DATE_FORMAT),
        today: date.today?
      }
    end
  end
end
