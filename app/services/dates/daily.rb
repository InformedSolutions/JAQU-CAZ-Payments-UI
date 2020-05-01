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
    # Overrides default by setting start and end dates
    def initialize(vrn:, zone_id:, charge_start_date:)
      super(vrn: vrn, zone_id: zone_id)
      @start_date = today - 6.days
      @end_date = today + 6.days
      @charge_start_date = charge_start_date
    end

    # Build the list of dates and return them, e.g.
    # [{value: "2019-10-11", name: "Friday 11 October 2019", today: false, disabled: false},...]
    def call
      (calculated_start_date..end_date).map { |date| parse(date) }
    end

    # Finds the expected start_date considering the zone charge activation date
    def calculated_start_date
      return start_date unless charge_start_date

      parsed_charge_start_date = Date.parse(charge_start_date)
      parsed_charge_start_date > start_date ? parsed_charge_start_date : start_date
    end

    private

    attr_reader :charge_start_date

    # Create hash of dates
    def parse(date)
      value = date.strftime(VALUE_DATE_FORMAT)
      {
        name: date.strftime(DISPLAY_DATE_FORMAT),
        value: value,
        today: date.today?,
        disabled: value.in?(paid_dates)
      }
    end
  end
end
