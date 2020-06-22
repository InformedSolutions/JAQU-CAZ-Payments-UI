# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to allow user to choose weekly charge period
  #
  # ==== Usage
  #    SessionManipulation::SetWeeklyChargePeriod.call(session: session)
  #
  class SetConfirmWeeklyChargeToday < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 12

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +confirm_weekly_charge_today+ - string, confirmation which will be used for back links flow, e.g. 'true '
    #
    def initialize(session:, confirm_weekly_charge_today:)
      @session = session
      @confirm_weekly_charge_today = confirm_weekly_charge_today
    end

    # Sets +confirm_weekly_charge_today+ to the session
    def call
      add_fields(confirm_weekly_charge_today: @confirm_weekly_charge_today)
    end
  end
end
