# frozen_string_literal: true

##
# This class wraps calls being made to the VCCS backend API.
# The base URL for the calls is configured by +COMPLIANCE_CHECKER_API_URL+ environment variable.
#
# All calls will automatically have the correlation ID and JSON content type added to the header.
#
# All methods are on the class level, so there is no initializer method.

class ComplianceCheckerApi < BaseApi
  base_uri ENV.fetch('CHECK_AIR_STANDARD_URL', '') + '/v1/compliance-checker'

  headers(
    'Content-Type' => 'application/json',
    'X-Correlation-ID' => SecureRandom.uuid
  )

  class << self
    ##
    # Calls +/v1/compliance-checker/vehicles/:vrn/details+ endpoint with +GET+ method
    # and returns details of the requested vehicle.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number parsed using {Parser}[rdoc-ref:VrnParser]
    #
    # ==== Example
    #
    #    ComplianceCheckerApi.vehicle_details('0009-AA')
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +registrationNumber+
    # * +type+ - string, eg. 'car'
    # * +make+ - string, eg. 'Audi'
    # * +colour+ - string, eg. 'red'
    # * +fuelType+ - string, eg. 'diesel'
    # * +taxiOrPhv+ - boolean, determines if the vehicle is a taxi or a PHV
    # * +exempt+ - boolean, determines if the vehicle is exempt from charges
    #
    # ==== Serialization
    #
    # {Vehicle details model}[rdoc-ref:VehicleDetails]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found in the DVLA db
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error

    def vehicle_details(vrn)
      log_action "Getting vehicle details, vrn: #{vrn}"
      MockVrnResponse.new(vrn).response
      # request(:get, "/vehicles/#{vrn}/details")
    end

    # TODO: replace by call to /compliance and checking returned charge value
    def chargeable_zones(vrn, type = nil)
      log_action "Getting chargeable CAZ, vrn: #{type ? "#{vrn}, type: #{type}" : vrn}"
      MockCazResponse.new(vrn).response
    end

    def vehicle_compliance(vrn, zone = nil)
      log_action "Getting vehicle compliance, vrn: #{vrn}, zone: #{zone || 'all'}"
      MockComplianceResponse.new(vrn, zone).response
      # request(:get, "/vehicles/#{vrn}/compliance", query: { zones: zones })
    end
  end
end
