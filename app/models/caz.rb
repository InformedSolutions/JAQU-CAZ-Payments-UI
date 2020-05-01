# frozen_string_literal: true

##
# This class represents data returned by CAZ API endpoint
#
class Caz
  ##
  # Creates an instance of a form class, make keys underscore and transform to symbols.
  #
  # ==== Attributes
  #
  # * +data+ - hash
  #   * +vrn+ - string, eg. 'CU57ABC'
  #   * +zones+ - array, eg. '["39e54ed8-3ed2-441d-be3f-38fc9b70c8d3"]'
  #   * +name+ - string, eg. 'Birmingham'
  #   * +clean_air_zone_id+ - UUID
  #   * +boundary_url+ - string, eg. 'www.example.com'
  #   * +active_charge_start_date+ - string, eg. '2020-05-01'
  #
  def initialize(data)
    @caz_data = data.transform_keys { |key| key.underscore.to_sym }
  end

  # Represents CAZ ID in the backend API database.
  def id
    caz_data[:clean_air_zone_id]
  end

  # Returns a string, eg. 'Birmingham'.
  def name
    caz_data[:name]
  end

  # Returns a string, eg. 'www.example.com'.
  def boundary_url
    caz_data[:boundary_url]
  end

  # Returns a string with a date, eg. '2020-05-01'
  def active_charge_start_date
    caz_data[:active_charge_start_date]
  end

  private

  attr_reader :caz_data
end
