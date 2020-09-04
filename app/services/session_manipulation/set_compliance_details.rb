# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to set compliance details of the vehicle for the selected CAZ.
  # It sets CAZ Id and name, daily charge for the vehicle
  # and marks if Leeds weekly discount in possible for this payment.
  #
  # Service calls backend APi compliance endpoint by using ComplianceDetails model.
  #
  # ==== Usage
  #    clean_air_zone_id = "05ad4eaa-aa09-459b-9aeb-9ab90bf23636"
  #    SessionManipulation::SetComplianceDetails.call(session: session, la_id: clean_air_zone_id)
  #
  class SetComplianceDetails < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 8

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +la_id+ - UUID, id of the Clean Air Zone
    #
    def initialize(session:, la_id:)
      @session = session
      @la_id = la_id
    end

    # Sets +la_id+, +la_name+, +daily_charge+, +weekly_possible+ based on the data returned by the backend API.
    # Used by the class level method +.call+
    #
    def call
      compliance_details = ComplianceDetails.new(session[SESSION_KEY].merge('la_id' => la_id))
      add_fields(
        la_id: la_id,
        la_name: compliance_details.zone_name,
        daily_charge: compliance_details.charge,
        tariff_code: compliance_details.tariff_code,
        weekly_possible:
          session[SESSION_KEY]['leeds_taxi'] && compliance_details.zone_name == 'Leeds'
      )
    end

    private

    # Get function for the LA ID
    attr_reader :la_id
  end
end
