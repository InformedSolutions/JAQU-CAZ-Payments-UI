# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to calculate the total charge for the payment
  # based on selected dates and vehicle compliance details.
  #
  # ==== Usage
  #    dates = ['2019-11-01', '2019-11-03']
  #    SessionManipulation::CalculateTotalCharge.call(session: session, dates: dates)
  #
  class CalculateTotalCharge < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 13

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +dates+ - array of strings, selected dates in the proper format, eg. ['2019-11-01', '2019-11-03']
    # * +weekly+ - boolean, determines if weekly taxi discount discount is used
    #
    def initialize(session:, dates: session[SESSION_KEY]['weekly_dates'], weekly: false)
      @session = session
      @dates = dates
      @weekly = weekly
    end

    # Sets +dates+, +total_charge+, +weekly+ based on the submitted data.
    # It chooses the algorithm based on weekly param.
    # Used by the class level method +.call+
    #
    def call
      weekly ? weekly_total_charge : daily_total_charge
    end

    private

    # It calculates total charge by multiplying daily charge by number of selected dates.
    # Used for the normal (not-discounted) path.
    def daily_total_charge
      total_charge = session[SESSION_KEY]['daily_charge'] * dates.length
      add_fields(dates: dates, total_charge: total_charge, weekly: false)
    end

    # It sets total_charge to equal Taxidiscountcaz discounted price of:
    #   50 (if one week is selected)
    #   100 (if two are selected).
    def weekly_total_charge
      merged_weeks_dates = week_dates.map { |date| weekly_dates(date) }.flatten
      add_fields(dates: merged_weeks_dates, total_charge: 50 * week_dates.length, weekly: true)
      add_week_dates
    end

    # It populates a given start date to return a whole week of weekly taxi discounted path
    def weekly_dates(start_date)
      selected_date = Date.strptime(start_date, Dates::Base::VALUE_DATE_FORMAT)
      selected_date
        .upto(selected_date + 6.days)
        .map { |date| date.strftime(Dates::Base::VALUE_DATE_FORMAT) }
    end

    # Returns array of dates in string format
    # .first is first week start date, .second is second week start date
    def week_dates
      if @session[:second_week_selected]
        [session[:first_week_start_date], dates.first]
      else
        [dates.first]
      end
    end

    # Sets chosen week start dates to session
    def add_week_dates
      session[:first_week_start_date] = week_dates.first
      session[:second_week_start_date] = week_dates.second
    end

    # Get function for dates and weekly
    attr_reader :dates, :weekly
  end
end
