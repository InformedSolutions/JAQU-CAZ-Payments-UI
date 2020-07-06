# frozen_string_literal: true

module Dates
  ##
  # Class is used to parse and verify if the selected week start date is in correct format.
  #
  # ==== Params
  # * +params+ - request parameters
  # * +charge_start_date+ - d-day date
  #
  class ValidateSelectedWeeklyDate < Base
    ##
    # Start date of selected week in YYYY-MM-DD format
    # eg 2020-6-1
    attr_reader :start_date

    def initialize(params:, charge_start_date:)
      @start_date = parse_date(params)
      @charge_start_date = charge_start_date
    end

    ##
    # Validates and parses the date
    #
    # Returns date in YYYY-MM-DD format without the preceding zero
    # eg 2020-6-1
    #
    # Returns false if date is in invalid format
    def parse_date(params)
      year = params[:date_year].to_i
      month = params[:date_month].to_i
      day = params[:date_day].to_i

      return unless Date.valid_date?(year, month, day)

      "#{year}-#{month}-#{day}"
    end

    ##
    # Checks if date is in payment window
    # Returns boolean
    def date_in_range?
      return unless @start_date

      start_day = Time.zone.today - 6.days
      end_day = Time.zone.today + 6.days

      selected_date = Time.zone.parse(@start_date).to_date
      selected_date.between?(start_day, end_day)
    end

    ##
    # Checks if date is after the d-day
    # Returns boolean
    def date_chargeable?
      return unless @start_date

      Time.zone.parse(@start_date) >= Time.zone.parse(@charge_start_date)
    end

    ##
    # Validates the date.
    # Returns boolean.
    def valid?
      @start_date && date_in_range? && date_chargeable?
    end

    ##
    # Sets correct error message.
    # Returns string.
    def error
      if valid?
        I18n.t('paid', scope: 'dates.weekly')
      elsif !@start_date && !date_in_range?
        I18n.t('empty', scope: 'dates.weekly')
      elsif @start_date && !date_in_range?
        out_of_range_error
      else
        I18n.t('not_available', scope: 'dates.weekly')
      end
    end

    ##
    # Generates error message for out of range error
    def out_of_range_error
      start = Date.current - 6.days
      d_day = Date.parse(@charge_start_date)

      start_day = start > d_day ? start.strftime('%d %m %Y') : d_day.strftime('%d %m %Y')
      end_day = (Date.current + 6.days).strftime('%d %m %Y')

      "Select a start date between #{start_day} and #{end_day}"
    end
  end
end
