# frozen_string_literal: true

##
# This is an abstract class used as a base for dates service classes.
module Dates
  ##
  # Class is used to build the list of available dates and display them
  # on the +select_weekly_date.html.haml+ and +select_daily_date.html.haml+ pages
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

    # Checks if D-Day notice should be shown
    def d_day_notice
      return unless charge_start_date

      Date.parse(charge_start_date).between?(Time.zone.today - 6.days, Time.zone.today)
    end

    private

    # Readers functions
    attr_reader :today, :vrn, :zone_id, :start_date, :end_date, :charge_start_date

    # Calls PaymentsApi.paid_payments_dates for already paid dates in a given time-frame
    def paid_dates
      @paid_dates ||= PaymentsApi.paid_payments_dates(
        vrn: vrn,
        zone_id: zone_id,
        start_date: start_date.strftime(VALUE_DATE_FORMAT),
        end_date: end_date.strftime(VALUE_DATE_FORMAT)
      )
    end

    # Finds the expected start_date considering the zone charge activation date
    def calculated_start_date
      return start_date unless charge_start_date

      parsed_charge_start_date = Date.parse(charge_start_date)
      parsed_charge_start_date > start_date ? parsed_charge_start_date : start_date
    end
  end
end
