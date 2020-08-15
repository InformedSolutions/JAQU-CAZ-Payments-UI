# frozen_string_literal: true

##
# Module used to see vehicle and payment details in the session
#
module SessionManipulation
  ##
  # Base service for this module.
  #
  class BaseManipulator < BaseService
    # Name of the details hash in the session
    SESSION_KEY = :vehicle_details

    # Subkeys of vehicle values in order of setting
    SUBKEYS = {
      1 => %w[vrn country confirm_vehicle],
      2 => %w[possible_fraud],
      3 => %w[unrecognised leeds_taxi confirm_registration undetermined],
      4 => %w[confirm_vehicle incorrect],
      5 => %w[type],
      6 => %w[la_id],
      7 => %w[chargeable_zones],
      8 => %w[daily_charge la_name weekly_possible tariff_code],
      9 => %w[charge_period],
      10 => %w[confirm_exempt],
      11 => %w[confirm_weekly_charge_today weekly_dates weekly_charge_today],
      12 => %w[confirm_weekly_charge_today weekly_dates weekly_charge_today],
      13 => %w[dates total_charge weekly second_week_selected],
      14 => %w[payment_id],
      15 => %w[user_email payment_reference external_id]
    }.freeze

    # Base initializer for the service
    #
    # ==== Attributes
    # * +session+ - the user's session
    #
    def initialize(session:)
      @session = session
    end

    private

    # Reader for the user's session
    attr_reader :session

    # Returns an array of subkeys based on service LEVEL.
    def previous_keys
      SUBKEYS.select { |key| key < self.class::LEVEL }.values.flatten
    end

    # Add passed values to the session.
    # It transforms keys to strings and removes keys from next levels.
    def add_fields(values = {})
      log_action("Adding keys: #{values.keys} to the session")
      session[SESSION_KEY] = session[SESSION_KEY].slice(*previous_keys).merge(values.stringify_keys)
      log_action("Current session keys: #{session[SESSION_KEY].keys}")
    end
  end
end
