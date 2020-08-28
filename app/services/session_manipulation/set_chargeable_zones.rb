# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to add number of zones in which a vehicle is chargeable to the session.
  #
  # ==== Usage
  #    SessionManipulation::SetChargeableZones.call(session: session, chargeable_zones: 2)
  #
  class SetChargeableZones < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 7

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +chargeable_zones+ - int, the number of zones that a vehicle is chargeable in
    #
    def initialize(session:, chargeable_zones:)
      @session = session
      @chargeable_zones = chargeable_zones
    end

    # Sets +chargeable_zones+ variable in the session. Used by the class level method +.call+
    def call
      add_fields(chargeable_zones: chargeable_zones)
    end

    private

    # Get function for the chargeable zones
    attr_reader :chargeable_zones
  end
end
