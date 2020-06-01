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
    # ==== Params
    #
    # * +vrn+ - Vehicle registration number
    # * +zone_id+ - ID of the selected CAZ
    #
    # ==== Attributes
    # * +today+ - current date
    #
    def initialize(vrn:, zone_id:)
      @today = Date.current
      @vrn = vrn
      @zone_id = zone_id
    end

    private

    # Readers functions
    attr_reader :today, :vrn, :zone_id, :start_date, :end_date

    # Calls PaymentsApi.paid_payments_dates for already paid dates in a given time-frame
    def paid_dates
      @paid_dates ||= PaymentsApi.paid_payments_dates(
        vrn: vrn,
        zone_id: zone_id,
        start_date: start_date.strftime(VALUE_DATE_FORMAT),
        end_date: end_date.strftime(VALUE_DATE_FORMAT)
      )
    end
  end
end
