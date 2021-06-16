# frozen_string_literal: true

##
# This class wraps calls associated with getting Clean Air Zones data
# and returns Caz objects.
#
class CazDataProvider
  # Returns a single Caz object
  def single(zone_id:)
    Caz.new(selected_clean_air_zone(zone_id: zone_id))
  end

  # Returns collection of CAZes which has display_from attribute today or in the past
  def displayable
    clean_air_zones.map { |zone| Caz.new(zone) }.reject { |caz| Date.parse(caz.display_from).future? }
  end

  private

  # Finds the expected clean air zone data based on provided zone id
  def selected_clean_air_zone(zone_id:)
    clean_air_zones.find { |zone| zone['cleanAirZoneId'] == zone_id }
  end

  # Fetches clean air zones data
  def clean_air_zones
    @clean_air_zones = ComplianceCheckerApi.clean_air_zones
  end
end
