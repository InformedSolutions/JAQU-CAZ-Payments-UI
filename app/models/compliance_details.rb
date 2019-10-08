# frozen_string_literal: true

##
# Class is used to wrap data from ComplianceCheckerApi.vehicle_compliance API call
# and display them on +app/views/charges/daily_charge.html.haml+
#
class ComplianceDetails
  ##
  # Creates an instance of a class with attributes ued to perform the backend call.
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  # * +zone_id+ - UUID, represents id of a CAZ in the backend DB
  #
  def initialize(vrn, zone_id)
    @vrn = vrn
    @zone_id = zone_id
  end

  # Returns a string, eg. 'Birmingham'.
  def zone_name
    compliance_data[:name]
  end

  # Determines how much owner of the vehicle will have to pay in this CAZ.
  #
  # rubocop:disable Style/AsciiComments
  # Returns a string, eg. '£10.00'
  # rubocop:enable Style/AsciiComments
  def charge
    "£#{format('%<pay>.2f', pay: compliance_data[:charge].to_f)}"
  end

  # Returns a string, eg. 'www.example.com'.
  def exemption_or_discount_url
    url(:exemption_or_discount)
  end

  private

  # Attributes used to perform the backend call
  attr_reader :vrn, :zone_id

  # Helper method used to take given url from URLs hash
  #
  # ==== Attributes
  #
  # * +name+ - symbol, name of the URL field eg. :exemption_or_discount
  def url(name)
    compliance_data.dig(:information_urls, name)
  end

  # Performs a call to the backend API, transforms data and stores it in variable
  def compliance_data
    @compliance_data ||= ComplianceCheckerApi.vehicle_compliance(
      vrn, zone_id
    )['complianceOutcomes'].first.deep_transform_keys { |key| key.underscore.to_sym }
  end
end
