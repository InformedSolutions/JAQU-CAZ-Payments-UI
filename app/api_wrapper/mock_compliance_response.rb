# frozen_string_literal: true

# rubocop:disable all
class MockComplianceResponse
  # Initializer for the mock
  #
  # ==== Attributes
  # * +vrn+ - string, vehicle registration number
  # * +zone_id+ - UUID, Clean Air Zone ID from backend DB
  #
  def initialize(vrn, zone_id)
    @vrn = vrn
    @zone_id = zone_id
  end

  # Returns mocked response
  def response
    {
      'registrationNumber' => vrn,
      'retrofitted' => false,
      'exempt' => false,
      'complianceOutcomes' => [birmingham, leeds].select { |zone| zone['cleanAirZoneId'] == zone_id }
    }
  end

  private

  attr_reader :vrn, :zone_id

  def birmingham
    {
      'cleanAirZoneId' => '5cd7441d-766f-48ff-b8ad-1809586fea37',
      'name' => 'Birmingham',
      'charge' => 8.0,
      'informationUrls' => urls
    }
  end

  def leeds
    {
      "cleanAirZoneId" => '39e54ed8-3ed2-441d-be3f-38fc9b70c8d3',
      "name" => "Leeds",
      'charge' => 12.5,
      'informationUrls' => urls
    }
  end

  def urls
    {
      'emissionsStandards' => 'http://test.com',
      'mainInfo' => 'http://test.com',
      'hoursOfOperation' => 'http://test.com',
      'pricing' => 'http://test.com',
      'exemptionOrDiscount' => 'http://test.com',
      'payCaz' => 'http://test.com',
      'becomeCompliant' => 'http://test.com',
      'financialAssistance' => 'http://test.com',
      'boundary' => 'http://test.com'
    }
  end
end
