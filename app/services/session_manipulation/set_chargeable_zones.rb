# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to mark vehicle as a taxi of PHV registered in Leeds.
  #
  # ==== Usage
  #    SessionManipulation::SetLeedsTaxi.call(session: session)
  #
  class SetChargeableZones < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 3

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +la_id+ - UUID, id of the Clean Air Zone
    #
    def initialize(session:, chargeable_zones:)
      @session = session
      @chargeable_zones = chargeable_zones
    end

    # Sets +leeds_taxi+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(chargeable_zones: chargeable_zones)
    end

    private

    # Get function for the chargeable zones
    attr_reader :chargeable_zones
  end
end
