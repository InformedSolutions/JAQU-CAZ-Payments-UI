# frozen_string_literal: true

module Dates
  ##
  # Service used to verify if there were no payments for the week starting at the given date.
  # Returns boolean.
  #
  # ==== Usage
  #
  #    Dates::CheckPaidWeekly.call(vrn: vrn, zone_id: la_id, dates: ["2019-10-21"])
  #
  # ==== Params
  # * +vrn+ - the vehicle registration number, string
  # * +zone_id+ - the CAZ ID, uuid
  # * +date+ - a date in a proper format, eg. "2019-10-21"
  #
  class CheckPaidWeekly < Base
    # Overrides default by setting start and end dates and the given date
    def initialize(vrn:, zone_id:, date:)
      super(vrn: vrn, zone_id: zone_id)
      @start_date = date.to_date
      @end_date = start_date + 6.days
    end

    # Checks if PaymentsApi.paid_payments_dates returns any dates in the given time-frame
    def call
      paid_dates.empty?
    end
  end
end
