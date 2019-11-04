# frozen_string_literal: true

##
# This is an abstract class used as a base for dates service classes.
module Dates
  ##
  # Class is used to build the list of available weekly dates
  # and display them on +app/views/dates/select_date_weekly.html.haml+
  #
  class Base < BaseService
    # date format used to display on the UI, eg. 'Friday 11 October 2019'
    DISPLAY_DATE_FORMAT = '%A %d %B %Y'
    # date format used to communicate with backend API, eg. '2019-05-14'
    VALUE_DATE_FORMAT = '%Y-%m-%d'

    ##
    # ==== Attributes
    # * +today+ - current date
    #
    def initialize(*)
      @today = Date.current
    end

    # Build the list of dates and return them, e.g.
    # [{value: "2019-10-11", name: "Friday 11 October 2019", today: false},...]
    def call
      ((today - 1.day)..(today + 6.days)).map { |date| parse(date) }
    end

    private

    # today get function
    attr_reader :today
  end
end
