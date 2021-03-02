# frozen_string_literal: true

##
# Class is used to wrap data from ComplianceCheckerApi.unrecognised_compliance API call
# and display them on +app/views/charges/daily_charge.html.haml+
#
class UnrecognisedComplianceDetails
  ##
  # Creates an instance of a class with attributes ued to perform the backend call.
  #
  # ==== Attributes
  # * +la_id+ - UUID, represents id of a CAZ in the backend DB
  #
  def initialize(la_id:)
    @la_id = la_id
  end

  # Returns a string, eg. 'Birmingham'.
  def zone_name
    unrecognised_compliance['name'].humanize
  end

  # Determines how much owner of the vehicle will have to pay in this CAZ.
  #
  # Returns a float, eg. '8.0'
  def charge
    unrecognised_compliance['charge']
  end

  # Returns a string eg. 'BCC01-private_car'
  def tariff_code
    unrecognised_compliance['tariffCode']
  end

  # Displays root path to the CAZ campaign site
  #
  # Returns an URL, eg. "https://beta.bathnes.gov.uk/bath-clean-air-zone"
  def main_info_url
    url('mainInfo')
  end

  # Displays CAZ dedicated link for checking exemptions and discounts.
  #
  # Returns an URL, eg. 'www.example.com'.
  def exemption_or_discount_url
    url('exemptionOrDiscount')
  end

  # Displays CAZ dedicated link for becoming compliant.
  #
  # Returns an URL, eg. 'www.example.com'.
  def compliance_url
    url('becomeCompliant')
  end

  # Returns a string, eg. 'www.example.com'.
  def public_transport_options_url
    url('publicTransportOptions')
  end

  # Returns compliance url based or additional_compliance_url or compliance_url
  def dynamic_compliance_url
    compliance_url
  end

  private

  # Attributes used to perform the backend call
  attr_reader :la_id

  # Get compliance data for non-DVLA registered vehicle
  def unrecognised_compliance
    @unrecognised_compliance ||= ComplianceCheckerApi.unrecognised_compliance(
      'TAXI_OR_PHV', [la_id]
    )['charges'].first
  end

  # Helper method used to take given url from URLs hash
  #
  # ==== Attributes
  #
  # * +name+ - symbol, name of the URL field eg. :exemption_or_discount
  def url(name)
    unrecognised_compliance.dig('informationUrls', name)
  end
end
