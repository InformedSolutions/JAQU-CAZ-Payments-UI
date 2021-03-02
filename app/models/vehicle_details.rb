# frozen_string_literal: true

##
# This class represents data returned by {CAZ API endpoint}[rdoc-ref:ComplianceCheckerApi.vehicle_details]
# and is used to display data in +app/views/vehicles/details.html.haml+.
class VehicleDetails
  ##
  # Creates an instance of a class, make +vrn+ uppercase and remove all spaces.
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  def initialize(vrn)
    @vrn = vrn.upcase.gsub(/\s+/, '')
  end

  # Returns a string, eg. 'CU57ABC'.
  def registration_number
    vrn
  end

  # Returns a string, eg. 'Car'.
  def type
    string_field('type')
  end

  # Returns a string, eg. 'Peugeot'.
  def make
    string_field('make')
  end

  # Returns a string, eg. 'Grey'.
  def colour
    string_field('colour')
  end

  # Returns a string, eg. 'Diesel'.
  def fuel_type
    string_field('fuelType')
  end

  # Check 'taxiOrPhv' value.
  #
  # Returns a string 'Yes' if value is true.
  # Returns a string 'No' if value is false.
  def taxi_private_hire_vehicle
    details_api['taxiOrPhv'] ? 'Yes' : 'No'
  end

  ##
  # Calls +/v1/compliance-checker/vehicles/:vrn/compliance+ endpoint with +GET+ method
  # and returns compliance details of the requested vehicle for all zones.
  # Call raises an exception when vehicle is undetermined. Based on that,
  # a proper boolean value is returned.
  def undetermined
    @undetermined ||= !ComplianceCheckerApi.vehicle_compliance(vrn, caz_ids)
  rescue BaseApi::Error422Exception
    true
  end

  # Check if at least one attributes value is present
  def undetermined_taxi?
    return false unless taxi?

    undetermined
  end

  # Returns a string, eg. 'M1'.
  def type_approval
    string_field('typeApproval')
  end

  # Returns a string, eg. 'i20'.
  def model
    string_field('model')
  end

  # Returns information if vehicle is exempted - boolean
  def exempt?
    details_api['exempt']
  end

  # Returns if vehicle is register in placeholder discount enabled CAZ as taxi or PHV
  def weekly_taxi?
    details_api['licensingAuthoritiesNames']&.include?('Taxidiscountcaz')
  end

  # Returns if vehicle is a taxi or PHV - boolean.
  def taxi?
    details_api['taxiOrPhv']
  end

  private

  # Reader function for the vehicle registration number
  attr_reader :vrn

  ##
  # Converts the first character of +key+ value to uppercase.
  #
  # ==== Attributes
  #
  # * +key+ - string, eg. 'type'
  #
  # ==== Result
  # Returns a nil if +key+ value is blank or equal to 'null'.
  # Returns a string, eg. 'Car' if +key+ value is present.
  # Returns a nil if +key+ value is not present.
  def string_field(key)
    return nil if details_api[key].blank? || details_api[key].downcase == 'null'

    details_api[key]&.capitalize
  end

  ##
  # Calls +/v1/payments/vehicles/:vrn/details+ endpoint with +GET+ method
  # and returns details of the requested vehicle.
  #
  def details_api
    @details_api ||= ComplianceCheckerApi.vehicle_details(vrn)
  end

  ##
  # Calls +/v1/payments/clean-air-zones+ endpoint with +GET+ method
  # and returns the list of available Clean Air Zones.
  #
  def caz_ids
    @caz_ids ||= ComplianceCheckerApi.clean_air_zones.map { |e| e['cleanAirZoneId'] }
  end
end
