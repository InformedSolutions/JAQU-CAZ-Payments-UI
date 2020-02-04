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
      1 => %w[vrn country],
      2 => %w[leeds_taxi unrecognised],
      3 => %w[type],
      4 => %w[incorrect],
      5 => %w[chargeable_zones],
      6 => %w[la_id daily_charge la_name weekly_possible tariff_code],
      7 => %w[dates total_charge weekly],
      8 => %w[payment_id],
      9 => %w[user_email payment_reference external_id]
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
      log_action "Adding #{values} to session"
      values.stringify_keys!
      session[SESSION_KEY] = session[SESSION_KEY].slice(*previous_keys).merge(values)
      log_action "User's current session: #{session[SESSION_KEY]}"
    end
  end
end
