# frozen_string_literal: true

##
# This class is used to get data about a single clean air zone id.
#
class FetchSingleCazData < BaseService
  ##
  # Initializer method
  #
  # ==== Attributes
  # * +zone_id+ - the CAZ ID, uuid
  #
  def initialize(zone_id:)
    @zone_id = zone_id
  end

  # Returns Caz object
  def call
    Caz.new(selected_clean_air_zone)
  end

  private

  attr_reader :zone_id

  # Fetches clean air zones data
  def clean_air_zones_data
    ComplianceCheckerApi.clean_air_zones
  end

  # Finds the expected clean air zone data based on provided zone id
  def selected_clean_air_zone
    clean_air_zones_data.find { |zone| zone['cleanAirZoneId'] == zone_id }
  end
end
