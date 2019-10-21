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
    ((today - 6.days)..(today + 6.days)).map { |date| parse(date) }
  end

  private

  # today and dates getters
  attr_reader :today

  # Create hash of dates
  def parse(date)
    {
      name: date.strftime(DATE_FORMAT),
      today: date.today?
    }
  end
end
