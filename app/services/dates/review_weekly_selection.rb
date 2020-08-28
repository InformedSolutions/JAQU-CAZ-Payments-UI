# frozen_string_literal: true

##
# Module used to build weekly selection dates as an array.
# Inherits from Dates::Weekly service
#
module Dates
  ##
  # Class is used to review, format and display weekly selection dates
  # on +app/views/charges/review_payment.html.haml+
  #
  # second_week_selected set to true to check whether dates are available for second week
  #
  class ReviewWeeklySelection < Weekly
    def initialize(vrn:, zone_id:, session:)
      @session = session
      @zone_id = zone_id
      super(vrn: vrn,
            zone_id: zone_id,
            second_week_selected: true,
            week_start_days: week_start_days,
            charge_start_date: charge_start_date
      )
    end

    # Checks if second week is available to be selected
    # Returns boolean
    def second_week_available?
      all_paid = chargeable_dates.all? { |date| date[:disabled] }

      !all_paid && week_start_days.second.nil?
    end

    # Formats the weekly selection start and end dates for selected weeks
    # Returns an array
    #   [
    #     ['28/07/2020', '03/08/2020'], // first week
    #     ['09/08/2020', '15/08/2020']  // second week
    #   ]
    #
    def format_week_selection
      week_start_days.map do |week_start|
        start_date = Date.parse(week_start)
        end_date = start_date + 6.days

        [format_date(start_date), format_date(end_date)]
      end
    end

    private

    # Formats the date to DD/MM/YYYY format
    def format_date(date)
      date.strftime('%d/%m/%Y')
    end

    # Returns array of selected week dates for weekly selection
    def week_start_days
      [@session[:first_week_start_date], @session[:second_week_start_date]].compact
    end

    # Fetches charge_start_date for selected CAZ
    def charge_start_date
      FetchSingleCazData.call(zone_id: @zone_id)&.active_charge_start_date
    end
  end
end
