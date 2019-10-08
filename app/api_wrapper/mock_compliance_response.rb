# frozen_string_literal: true

# rubocop:disable all
class MockComplianceResponse
  def initialize(vrn, zone_id)
    @vrn = vrn
    @zone_id = zone_id

  end

  def response
    {
      'registrationNumber' => vrn,
      'retrofitted' => false,
      'exempt' => false,
      'complianceOutcomes' =>
          zone_id ?
              [birmingham, leeds].select { |zone| zone['cleanAirZoneId'] == zone_id } :
              [birmingham, leeds]
    }
  end

  private

  COMPLIANT = ['CDE345'].freeze
  ONLY_LEEDS = ['ABC123'].freeze

  attr_reader :vrn, :zone_id

  def birmingham
    {
      'cleanAirZoneId' => '5cd7441d-766f-48ff-b8ad-1809586fea37',
      'name' => 'Birmingham',
      'charge' => vrn.in?([*COMPLIANT, *ONLY_LEEDS]) ? 0.0 : 8.0,
      'informationUrls' => urls
    }
  end

  def leeds
    {
      "cleanAirZoneId" => '39e54ed8-3ed2-441d-be3f-38fc9b70c8d3',
      "name" => "Leeds",
      'charge' => vrn.in?([COMPLIANT]) ? 0.0 : 12.5,
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
