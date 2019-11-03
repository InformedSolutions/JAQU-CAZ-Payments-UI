# frozen_string_literal: true

##
# Class is used to build the list of available dates
# and display them on +app/views/dates/dates.html.haml+
#
class Dates < BaseDates
  # Build the list of dates and return them, e.g.
  # [{value: "2019-10-11", name: "Friday 11 October 2019", today: false},...]
  def build
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
