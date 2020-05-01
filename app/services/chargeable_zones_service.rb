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
  #   * +type+ - string, type of the vehicle selected by the user
  #
  def initialize(vehicle_details:)
    @vrn = vehicle_details['vrn']
    @type = vehicle_details['type']
    @non_dvla = vehicle_details['country'] != 'UK' || vehicle_details['unrecognised'] ||
                vehicle_details['undetermined']
  end

  # The caller method for the service.
  # It checks which country was chosen or vehicle is unrecognised.
  # If non_dvla is equals to true, returns all zones.
  # If not, calls +ComplianceCheckerApi.clean_air_zones+ and then calls
  # +ComplianceCheckerApi.vehicle_compliance+
  #
  # Returns an array of Caz objects
  def call
    chargeable_ids = non_dvla ? non_dvla_data : dvla_data
    # TODO: charge to filter_map when updated to ruby 2.7
    # https://blog.saeloun.com/2019/05/25/ruby-2-7-enumerable-filter-map.html
    zone_data
      .select { |zone| zone['cleanAirZoneId'].in?(chargeable_ids) }
      .map { |zone| Caz.new(zone) }
  end

  private

  # Calls +ComplianceCheckerApi.clean_air_zones+ and then calls
  # +ComplianceCheckerApi.vehicle_compliance+ to check if any of zones has charge price
  def dvla_data
    vehicle_compliance_response = ComplianceCheckerApi.vehicle_compliance(vrn, zone_ids)
    select_chargeable(vehicle_compliance_response['complianceOutcomes'])
  end

  def non_dvla_data
    vehicle_compliance_response = ComplianceCheckerApi.unrecognised_compliance(type, zone_ids)
    select_chargeable(vehicle_compliance_response['charges'])
  end

  # Variable used internally by the service
  attr_reader :vrn, :non_dvla, :type

  # Calling API and returns the list of the available local authorities.
  def zone_data
    @zone_data ||= ComplianceCheckerApi.clean_air_zones
  end

  # Returns an array of IDS of the available local authorities.
  def zone_ids
    zone_data.map { |zone| zone['cleanAirZoneId'] }
  end

  def select_chargeable(data)
    # TODO: charge to filter_map when updated to ruby 2.7
    # https://blog.saeloun.com/2019/05/25/ruby-2-7-enumerable-filter-map.html
    data.select { |zone| zone['charge'].to_i.positive? }.map { |zone| zone['cleanAirZoneId'] }
  end
end
