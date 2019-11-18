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
  # * +vehicle_details+ - hash with string keys
  #   * +vrn+ - string, eg. 'CU57ABC'
  #   * +country+ - string, country of the vehicle registration - UK or non-UK
  #   * +unrecognised+ - boolean, unrecognised vehicle's registration
  def initialize(vehicle_details:)
    @vrn = vehicle_details['vrn']
    @non_dvla = vehicle_details['country'] != 'UK' || vehicle_details['unrecognised']
    @taxi = vehicle_details['taxi']
  end

  # The caller method for the service.
  # It checks which country was chosen or vehicle is unrecognised.
  # If non_dvla is equals to true, returns all zones.
  # If not, calls +ComplianceCheckerApi.chargeable_zones+ and then calls
  # +ComplianceCheckerApi.vehicle_compliance+ to check if any of zones has charge price
  #
  # Returns an array
  def call
    return zone_data if non_dvla

    zone_ids = zone_data.map { |caz_data| caz_data['cleanAirZoneId'] }
    vehicle_compliance_response = ComplianceCheckerApi.vehicle_compliance(vrn, zone_ids)
    vehicle_compliance_response['complianceOutcomes'].select do |zone|
      zone['charge'].to_i.positive?
    end
  end

  private

  # Variable used internally by the service
  attr_reader :vrn, :non_dvla

  # Calling API and returns the list of available local authorities.
  def zone_data
    @zone_data ||= ComplianceCheckerApi.clean_air_zones
  end
end
