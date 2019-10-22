# frozen_string_literal: true

##
# This class is used to get all chargeable zones and check if any of them have charge price
# for a current vehicle
#
class ChargeableZonesService < BaseService
  ##
  # Initializer method.
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  # * +country+ - string, eg. 'UK'
  def initialize(vrn:, country:)
    @vrn = vrn
    @country = country
  end

  # The caller method for the service.
  # It checks which country was chosen.
  # If Non-UK, returns mocked response.
  # If UK, calls +ComplianceCheckerApi.chargeable_zones+ and then calls
  # +ComplianceCheckerApi.vehicle_compliance+ to check if any of zones has charge price
  #
  # Returns an array
  def call
    return MockCazesForNonukResponse.new.response['complianceOutcomes'] if country == 'Non-UK'

    zone_ids = zone_data.map { |caz_data| caz_data['cleanAirZoneId'] }
    vehicle_compliance_response = ComplianceCheckerApi.vehicle_compliance(vrn, zone_ids)
    vehicle_compliance_response['complianceOutcomes'].select do |zone|
      zone['charge'].to_i.positive?
    end
  end

  private

  # Variable used internally by the service
  attr_reader :vrn, :country

  # Calling API and returns the list of available local authorities.
  def zone_data
    @zone_data ||= ComplianceCheckerApi.chargeable_zones(vrn)
  end
end
