# frozen_string_literal: true

##
# This class wraps calls being made to the VCCS backend API.
# The base URL for the calls is configured by +VEHICLE_CHECKER_API_URL+ environment variable.
#
# All calls will automatically have the correlation ID and JSON content type added to the header.
#
# All methods are on the class level, so there is no initializer method.
class VehiclesCheckerApi < BaseApi
  base_uri "#{ENV.fetch('COMPLIANCE_CHECKER_API_URL', 'localhost:3001')}/v1/compliance-checker"

  class << self
    ##
    # Calls +/v1/compliance-checker/vehicles/:vrn/external-details+ endpoint with +GET+ method
    # and returns details of the requested vehicle.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number
    #
    # ==== Example
    #
    #    VehiclesCheckerApi.external_details('0009-AA')
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +registrationNumber+ - string, eg. 'CAS123'
    # * +colour+ - string, eg. 'Black'
    # * +dateOfFirstRegistration+ - string, eg '2018-02-03'
    # * +euroStatus+ - string, eg 'EURO V'
    # * +fuelType+ - string, eg 'Diesel'
    # * +make+ - string, eg. 'Audi'
    # * +typeApproval+ - string, eg 'N3'
    # * +revenueWeight+ - integer
    # * +unladenWeight+ - integer
    # * +bodyType+ - string, eg 'Car'
    # * +model+ - string, eg 'Ciato'
    # * +seatingCapacity+ - integer
    # * +standingCapacity+ - integer
    # * +taxClass+ - string, eg 'SPECIAL VEHICLE'
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

    def external_details(vrn)
      log_action('Making request for getting external vehicle details')
      request(:get, "/vehicles/#{vrn}/external-details")
    end
  end
end
