# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to confirm registration number correct.
  #
  # ==== Usage
  #    SessionManipulation::SetConfirmVehicle.call(session: session, confirm_vehicle: true)
  #
  class SetConfirmVehicle < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 4

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +confirm_vehicle+ - a boolean
    #
    def initialize(session:, confirm_vehicle:)
      @session = session
      @confirm_vehicle = confirm_vehicle
    end

    # Sets +confirm_vehicle+ in the session. Used by the class level method +.call+
    def call
      add_fields(confirm_vehicle: @confirm_vehicle)
    end
  end
end
