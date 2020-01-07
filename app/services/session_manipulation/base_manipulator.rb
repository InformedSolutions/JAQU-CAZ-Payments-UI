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
      2 => %w[leeds_taxi unrecognised incorrect],
      3 => %w[type chargeable_zones],
      4 => %w[la_id daily_charge la_name weekly_possible],
      5 => %w[dates total_charge weekly],
      6 => %w[payment_id],
      7 => %w[user_email]
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
