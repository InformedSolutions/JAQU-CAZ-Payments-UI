# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to set compliance details for the unrecognized taxi vehicle
  # for the selected CAZ.
  # It sets CAZ Id, CAZ name and daily charge for the vehicle.
  #
  # Service calls backend API compliance endpoint by using UnrecorgnisedComplianceDetails model.
  #
  # ==== Usage
  #    clean_air_zone_id = "05ad4eaa-aa09-459b-9aeb-9ab90bf23636"
  #    SessionManipulation::SetUnrecognisedCompliance.call(session: session, la_id: clean_air_zone_id)
  #
  class SetUnrecognisedCompliance < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 8

    # Initializer method. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +la_id+ - UUID, if of the Clean Air Zone
    #
    def initialize(session:, la_id:)
      @session = session
      @la_id = la_id
    end

    # Sets +la_id+, +la_name+, +daily_charge+ based on the data returned by the backend API.
    # Used by the class level method +.call+
    def call
      compliance_details = UnrecognisedComplianceDetails.new(la_id: la_id)
      add_fields(
        la_id: la_id,
        la_name: compliance_details.zone_name,
        daily_charge: compliance_details.charge,
        tariff_code: compliance_details.tariff_code
      )
    end

    private

    # Get function for the LA ID
    attr_reader :la_id
  end
end
