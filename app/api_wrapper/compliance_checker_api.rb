# frozen_string_literal: true

##
# This class wraps calls being made to the Payments backend API related to Vehicle Compliance.
# The base URL for the calls is configured by +PAYMENTS_API_URL+ environment variable.
#
# All calls will automatically have the correlation ID and JSON content type added to the header.
#
# All methods are on the class level, so there is no initializer method.

class ComplianceCheckerApi < BaseApi
  base_uri ENV.fetch('PAYMENTS_API_URL', 'localhost:3001') + '/v1/payments'

  class << self
    ##
    # Calls +/v1/payments/vehicles/:vrn/details+ endpoint with +GET+ method
    # and returns details of the requested vehicle.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number
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
    # * +licensingAuthoritiesNames+ - array of strings, list of LA where vehicle is registered as a taxi
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
    #
    def vehicle_details(vrn)
      log_action('Getting vehicle details')
      request(:get, "/vehicles/#{vrn}/details")
    end

    ##
    # Calls +/v1/payments/vehicles/:vrn/compliance+ endpoint with +GET+ method
    # and returns compliance details of the requested vehicle for requested zones.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number parsed using {Parser}[rdoc-ref:VrnParser]
    # * +zones+ - Array of zones IDs which vehicle compliance is check against
    #
    # ==== Example
    #
    #    ComplianceCheckerApi.vehicle_compliance('0009-AA', ['3c3e1631-c478-42db-8422-63f608f71efd'])
    #
    # ==== Result
    #
    # Returned compliance details will have following fields:
    # * +registrationNumber+
    # * +retrofitted+ - boolean
    # * +exempt+ - boolean, determines if the vehicle is exempt from charges
    # * +complianceOutcomes+ - array of objects
    #   * +cleanAirZoneId+ - UUID, this represents CAZ ID in the DB
    #   * +name+ - string, eg. "Birmingham"
    #   * +charge+ - number, determines how much owner of the vehicle will have to pay in this CAZ
    #   * +informationUrls+ - object containing CAZ dedicated info links
    #     * +mainInfo+
    #     * +exemptionOrDiscount+
    #     * +becomeCompliant+
    #     * +boundary+
    #
    # ==== Serialization
    #
    # {Compliance model}[rdoc-ref:Compliance]
    # can be used to wrap the call and
    # {Compliance details model}[rdoc-ref:ComplianceDetails]
    # for each zone.
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found in the DVLA db
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def vehicle_compliance(vrn, zones)
      zones = zones.join(',')
      log_action('Getting vehicle compliance')
      request(:get, "/vehicles/#{vrn}/compliance", query: { zones: zones })
    end

    ##
    # Calls +/v1/payments/clean-air-zones+ endpoint with +GET+ method
    # and returns the list of available Clean Air Zones.
    #
    # ==== Example
    #
    #    ComplianceCheckerApi.clean_air_zones
    #
    # ==== Result
    #
    # Each returned CAZ will have following fields:
    # * +name+ - string, eg. "Birmingham"
    # * +cleanAirZoneId+ - UUID, this represents CAZ ID in the DB
    # * +boundaryUrl+ - URL, this represents a link to eg. a map with CAZ boundaries
    #
    # ==== Serialization
    #
    # {Caz model}[rdoc-ref:Caz] can be used to create an instance of Clean Air Zone
    #
    # ==== Exceptions
    #
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def clean_air_zones
      log_action 'Getting clean air zones'
      request(:get, '/clean-air-zones')['cleanAirZones']
    end

    ##
    # Calls +/v1/payments/vehicles/unrecognised/:type/compliance+ endpoint with +GET+ method
    # and returns compliance details for non DVLA vehicle on requested zone.
    #
    # ==== Attributes
    #
    # * +type+ - string, eg. 'car'
    # * +zones+ - Array of zones IDs which vehicle compliance is check against
    #
    # ==== Result
    #
    # Returned compliance details will for non-dvla have following fields:
    # * +charges+ - array of objects
    #   * +cleanAirZoneId+ - UUID, this represents CAZ ID in the DB
    #   * +name+ - string, eg. "Birmingham"
    #   * +charge+ - number, determines how much owner of the vehicle will have to pay in this CAZ
    #
    def unrecognised_compliance(type, zones)
      zones = zones.join(',')
      log_action "Getting vehicle unrecognised type compliance, type: #{type}, zones: #{zones}"
      request(
        :get,
        "/vehicles/unrecognised/#{type}/compliance",
        query: { zones: zones }
      )
    end

    ##
    # Calls +/v1/compliance-checker/vehicles/:vrn/register-details endpoint with +GET+ method
    # and returns information about vehicle existence on specific registers.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number parsed using {Parser}[rdoc-ref:VrnParser]
    #
    # ==== Example
    #
    #    ComplianceCheckerApi.register_details('0009-AA')
    #
    # ==== Result
    #
    # Returned response will have the following attributes:
    # * +registerCompliant+ - boolean, states if vehicle features in Retrofit or is compliant in GPW
    # * +registerExempt+ - boolean, states if vehicle features in MOD or is exempt in GPW
    # * +registeredMOD+ - boolean, states if vehicle features in MOD
    # * +registeredGPW+ - boolean, states if vehicle features in GPW
    # * +registeredNTR+ - boolean, states if vehicle features in NTR
    # * +registeredRetrofit+ - boolean, states if vehicle features in Retrofit
    #
    # ==== Serialization
    #
    # {Register details model}[rdoc-ref:RegisterDetails]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error

    def register_details(vrn)
      log_action 'Making request for vehicle presence on specific registers'
      request(:get, "/vehicles/#{vrn}/register-details")
    end
  end
end
