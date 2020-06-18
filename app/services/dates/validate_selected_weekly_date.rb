# frozen_string_literal: true

module Dates
  ##
  # Class is used to parse and verify if the selected week start date is in correct format.
  #
  # ==== Params
  # * +params+ - request parameters
  #
  class ValidateSelectedWeeklyDate < Base
    ##
    # Start date of selected week in YYYY-MM-DD format
    # eg 2020-6-1
    attr_reader :start_date

    def initialize(params:)
      @start_date = parse_date(params)
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
    # Validates the date.
    # Returns boolean.
    def valid?
      @start_date && date_in_range?
    end

    ##
    # Sets correct error message
    def error
      if date_in_range?
        I18n.t(@start_date ? 'paid' : 'empty', scope: 'dates.weekly')
      else
        out_of_range_error
      end
    end

    ##
    # Generates error message for out of range error
    def out_of_range_error
      start_day = (Date.current - 6.days).strftime('%d %m %Y')
      end_day = (Date.current + 6.days).strftime('%d %m %Y')

      "Select a start date between #{start_day} and #{end_day}"
    end
  end
end
