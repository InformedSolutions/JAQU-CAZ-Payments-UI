# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/vehicles/details.html.haml+.
class ConfirmationForm
  # form confirmation from the query params, values: 'yes', 'no', nil
  attr_reader :confirmation
  # error message, string
  attr_reader :message
  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +confirmation+ - string, eg. 'yes'
  # * +message+ - empty string, default error message
  def initialize(confirmation)
    @confirmation = confirmation
    @message = nil
  end

  # Validate user data.
  #
  # Returns a boolean.
  def valid?
    filled?
  end

  # Checks if +confirmation+ equality to 'yes'.
  #
  # Returns a boolean.
  def confirmed?
    confirmation == 'yes'
  end

  private

  # Checks if at least one answer was selected.
  # If not, add error message to +message+.
  #
  # Returns a boolean.
  def filled?
    return true if confirmation.present?

    @message = 'You must choose an answer'
    false
  end
end
