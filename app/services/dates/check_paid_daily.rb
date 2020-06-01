# frozen_string_literal: true

##
# Module used to build daily days as a array of hashes.
#
module Dates
  ##
  # Service used to verify if there were no payments for given dates.
  # Returns boolean.
  #
  # ==== Usage
  #
  #    Dates::CheckPaidDaily.call(vrn: vrn, zone_id: la_id, dates: ["2019-10-21"])
  #
  # ==== Params
  # * +vrn+ - the vehicle registration number, string
  # * +zone_id+ - the CAZ ID, uuid
  # * +dates+ - an array of dates in a proper format, eg. ["2019-10-21"]
  #
  class CheckPaidDaily < Base
    # Overrides default by setting start and end dates and given dates
    def initialize(vrn:, zone_id:, dates:)
      super(vrn: vrn, zone_id: zone_id)
      @dates = dates
      @start_date = today - 6.days
      @end_date = today + 6.days
    end

    # Checks if none of the given dates were already paid
    def call
      (dates & paid_dates).empty?
    end

    private

    attr_reader :dates
  end
end
