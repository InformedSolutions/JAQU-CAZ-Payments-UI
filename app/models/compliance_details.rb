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
  # * +vehicle_details+ - hash with string keys
  #   * +vrn+ - string, eg. 'CU57ABC'
  #   * +country+ - string, country of the vehicle registration - UK or non-UK
  #   * +type+ - string, vehicle type, eg. 'Car', 'Bus'
  # * +zone_id+ - UUID, represents id of a CAZ in the backend DB
  #
  def initialize(vehicle_details)
    @vrn = vehicle_details['vrn']
    @type = vehicle_details['type'] || ''
    @zone_id = vehicle_details['la_id']
    @non_dvla = vehicle_details['country'] != 'UK' || vehicle_details['unrecognised']
    @leeds_taxi = vehicle_details['leeds_taxi'] || false
  end

  # Returns a string, eg. 'Birmingham'.
  def zone_name
    compliance_data[:name]
  end

  # Determines how much owner of the vehicle will have to pay in this CAZ.
  #
  # Returns a float, eg. '8.0'
  def charge
    compliance_data[:charge]
  end

  # Returns a string eg. 'BCC01-private_car'
  def tariff_code
    compliance_data[:tariff_code]
  end

  # Displays CAZ dedicated link for checking exemptions and discounts.
  #
  # Returns an URL, eg. 'www.example.com'.
  def exemption_or_discount_url
    url(:exemption_or_discount)
  end

  # Displays CAZ dedicated link for becoming compliant.
  #
  # Returns an URL, eg. 'www.example.com'.
  def compliance_url
    url(:become_compliant)
  end

  # Displays root path to the CAZ campaign site
  #
  # Returns an URL, eg. 'www.example.com'.
  def main_info_url
    url(:main_info)
  end

  # Returns a string, eg. 'www.example.com'.
  def public_transport_options_url
    url(:public_transport_options)
  end

  def dynamic_compliance_url
    if (leeds_taxi && zone_name == 'Leeds') || (type.include?('car') && zone_name == 'Birmingham')
      return compliance_url
    end

    additional_urls_file[zone_name.downcase]['fleet']
  end

  private

  # Attributes used to perform the backend call
  attr_reader :vrn, :zone_id, :non_dvla, :type, :leeds_taxi

  # Helper method used to take given url from URLs hash
  #
  # ==== Attributes
  #
  # * +name+ - symbol, name of the URL field eg. :exemption_or_discount
  def url(name)
    compliance_data.dig(:information_urls, name)
  end

  # Based on selected country, performs a call to the backend API, transforms data and stores it in variable
  def compliance_data
    @compliance_data ||=
      if non_dvla
        non_dvla_compliance_data
      else
        dvla_compliance_data
      end.first.deep_transform_keys { |key| key.underscore.to_sym }
  end

  # Get compliance data for DVLA registered vehicle
  def dvla_compliance_data
    ComplianceCheckerApi.vehicle_compliance(vrn, [zone_id])['complianceOutcomes']
  end

  # Get compliance data for non-DVLA registered vehicle
  def non_dvla_compliance_data
    ComplianceCheckerApi.unrecognised_compliance(type, [zone_id])['charges']
  end

  def additional_urls_file
    YAML.load_file('additional_url.yml')
  end
end
