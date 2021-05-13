# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to set the vehicle's type from the DVLA database.
  #
  # ==== Usage
  #    SessionManipulation::SetVehicleDetails.call(session: session, dvla_vehicle_type: 'Car')
  #
  class SetVehicleDetails < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 3

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +dvla_vehicle_type+ - string, vehicle type from DVLA, eg. 'Car'
    #
    def initialize(session:, weekly_taxi:, undetermined:, undetermined_taxi:,
                   dvla_vehicle_type:)
      @session = session
      @weekly_taxi = weekly_taxi
      @undetermined = undetermined
      @undetermined_taxi = undetermined_taxi
      @dvla_vehicle_type = dvla_vehicle_type
    end

    # Adds the +dvla_vehicle_type+ to the session. Used by the class level method +.call+
    def call
      add_fields(weekly_taxi: weekly_taxi, undetermined: undetermined,
                 undetermined_taxi: undetermined_taxi, dvla_vehicle_type: dvla_vehicle_type)
    end

    private

    # Get function for the weekly_taxi, undetermined, undetermined_taxi and
    # dvla_vehicle_type
    attr_reader :weekly_taxi, :undetermined, :undetermined_taxi, :dvla_vehicle_type
  end
end
