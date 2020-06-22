# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to confirm charge period.
  #
  # ==== Usage
  #    SessionManipulation::SetChargePeriod.call(session: session)
  #
  class SetChargePeriod < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 9

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +confirm_vehicle+ - a boolean
    #
    def initialize(session:, charge_period:)
      @session = session
      @charge_period = charge_period
    end

    # Sets +confirm_vehicle+ in the session. Used by the class level method +.call+
    def call
      add_fields(charge_period: @charge_period)
    end
  end
end
