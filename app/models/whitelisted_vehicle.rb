# frozen_string_literal: true

##
# This class represents data returned by {CAZ API endpoint}[rdoc-ref:ComplianceCheckerApi.vehicle_details]
#
class WhitelistedVehicle
  ##
  # Creates an instance of a class, make +vrn+ uppercase and remove all whitespaces.
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  def initialize(vrn)
    @vrn = vrn.upcase.gsub(/\s+/, '')
  end

  # Performs call to ComplianceCheckerApi to fetch data. When call is successful
  # then 'true' is returned, when status 404 is returned then 'false' is returned.
  def exempt?
    whitelisted_vehicle.present?
  rescue BaseApi::Error404Exception
    false
  end

  private

  # Reader function for the vehicle registration number
  attr_reader :vrn

  ##
  # Calls +/v1/payments/whitelisted-vehicles/:vrn+ endpoint with +GET+ method
  # and returns information specifying if the provided vehicle is whitelisted.
  def whitelisted_vehicle
    @whitelisted_vehicle ||= ComplianceCheckerApi.whitelisted_vehicle(vrn)
  end
end
