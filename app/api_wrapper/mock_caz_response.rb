# frozen_string_literal: true

# rubocop:disable all
# :nodoc: all
class MockCazResponse
  COMPLIANT = ['CDE345'].freeze
  ONLY_LEEDS = ['ABC123'].freeze

  def initialize(vrn)
    @vrn = vrn
  end

  def response
    case
      when vrn.in?(COMPLIANT)
        []
      when vrn.in?(ONLY_LEEDS)
        [leeds]
      else
        [birmingham, leeds]
      end
  end

  private

  attr_reader :vrn

  def leeds
    {
        "cleanAirZoneId" => "39e54ed8-3ed2-441d-be3f-38fc9b70c8d3",
        "name" => "Leeds",
        "boundaryUrl" => "https://www.arcgis.com/home/webmap/viewer.html?webmap=de0120ae980b473982a3149ab072fdfc&extent=-1.733%2c53.7378%2c-1.333%2c53.8621"
    }
  end

  def birmingham
    {
        "cleanAirZoneId" => "5cd7441d-766f-48ff-b8ad-1809586fea37",
        "name" => "Birmingham",
        "boundaryUrl" => "https://www.birmingham.gov.uk/info/20076/pollution/1763/a_clean_air_zone_for_birmingham/3"
    }
  end
end
