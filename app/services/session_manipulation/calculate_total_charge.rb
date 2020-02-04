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
    LEVEL = 7

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +dates+ - array of strings, selected dates in the proper format, eg. ['2019-11-01', '2019-11-03']
    # * +weekly+ - boolean, determines if Leeds weekly discount is used
    #
    def initialize(session:, dates:, weekly: false)
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

    # It sets total_charge to equal Leeds discounted price of 50.
    def weekly_total_charge
      add_fields(dates: weekly_dates, total_charge: 50, weekly: true)
    end

    # It populates a given start date to return a whole week of Leeds discounted path
    def weekly_dates
      selected_date = Date.strptime(dates.first, Dates::Base::VALUE_DATE_FORMAT)
      selected_date
        .upto(selected_date + 6.days)
        .map { |date| date.strftime(Dates::Base::VALUE_DATE_FORMAT) }
    end

    # Get function for dates and weekly
    attr_reader :dates, :weekly
  end
end
