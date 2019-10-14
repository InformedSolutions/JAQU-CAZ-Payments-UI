# frozen_string_literal: true

##
# Class is used to build the list of available dates
# and display them on +app/views/charges/dates.html.haml+
#
class Dates
  # date format, e.g. 'Friday 11 October 2019'
  DATE_FORMAT = '%A %d %B %Y'
  ##
  #
  #
  # ==== Attributes
  # * +today+ - current date
  #
  def initialize
    @today = Date.current
  end

  # Build the list of dates and return them, e.g.
  # [{:value=>"2019-10-11", :name=>"Friday 11 October 2019"},...]
  def build
    (today.prev_weekday..six_weekdays_from_today).map { |date| parse(date) }
  end

  private

  # today and dates getters
  attr_reader :today

  # Calculate the next six working days with all weekends.
  def six_weekdays_from_today
    day = today
    6.times { day = day.next_weekday }
    day
  end

  # Create hash of dates
  def parse(date)
    {
      value: date.strftime('%F'),
      name: date.strftime(DATE_FORMAT),
      today: date.today?
    }
  end
end
