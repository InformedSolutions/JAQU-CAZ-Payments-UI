# frozen_string_literal: true

class ComplianceDetails
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

  attr_reader :vrn, :zone_id

  def url(name)
    compliance_data.dig(:information_urls, name)
  end

  def compliance_data
    @compliance_data ||= ComplianceCheckerApi.vehicle_compliance(
      vrn, zone_id
    )['complianceOutcomes'].first.deep_transform_keys { |key| key.underscore.to_sym }
  end
end
