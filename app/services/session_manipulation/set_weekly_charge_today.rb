# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to allow user to choose weekly charge period
  #
  # ==== Usage
  #    SessionManipulation::SetWeeklyChargePeriod.call(session: session)
  #
  class SetWeeklyChargeToday < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 12

    # Initializer function
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +weekly_charge_today+ - boolean, user can starting paid for a week from today
    # * +today+ - array, today date e.g. ["2020-06-02"]
    #
    def initialize(session:, weekly_charge_today:, today: nil)
      @session = session
      @weekly_charge_today = weekly_charge_today
      @today = today
    end

    # Sets +weekly_dates+ and +weekly_charge_today+ to the session
    def call
      add_fields(weekly_dates: @today, weekly_charge_today: @weekly_charge_today)
    end
  end
end
