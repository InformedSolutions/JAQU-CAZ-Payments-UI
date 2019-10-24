# frozen_string_literal: true

##
# Class is used to build the list of available dates
# and display them on +app/views/charges/dates.html.haml+
#
class Dates
  # date format used to display on the UI, eg. 'Friday 11 October 2019'
  DISPLAY_DATE_FORMAT = '%A %d %B %Y'
  # date format used to communicate with backend API, eg. '2019-05-14'
  VALUE_DATE_FORMAT = '%Y-%m-%d'

  ##
  # ==== Attributes
  # * +today+ - current date
  #
  def initialize
    @today = Date.current
  end

  # Build the list of dates and return them, e.g.
  # [{value: "2019-10-11", name: "Friday 11 October 2019", today: false},...]
  def build
    ((today - 6.days)..(today + 6.days)).map { |date| parse(date) }
  end

  private

  # today get function
  attr_reader :today

  # Create hash of dates
  def parse(date)
    {
      name: date.strftime(DISPLAY_DATE_FORMAT),
      value: date.strftime(VALUE_DATE_FORMAT),
      today: date.today?
    }
  end
end
