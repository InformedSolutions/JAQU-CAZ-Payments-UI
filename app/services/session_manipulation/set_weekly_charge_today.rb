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
    LEVEL = 10

    # Sets +weekly_charge_today+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(weekly_charge_today: true)
    end
  end
end
