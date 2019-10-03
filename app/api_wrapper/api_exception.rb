# frozen_string_literal: true

##
# This is an abstract class used as a base for all API exceptions.

class ApiException < StandardError
  ##
  # HTTP error status as integer
  attr_reader :status

  ##
  # HTTP error message
  attr_reader :status_message

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +status+ - string or integer, HTTP error status
  # * +status_message+ - string, HTTP error message
  # * +body+ - request body
  def initialize(status, status_message, body)
    @status         = status.to_i
    @status_message = status_message
    @message        = body.is_a?(Hash) ? body['message'] : status_message
    @body           = body
  end

  ##
  # Displays error message from body with a status
  #
  # ==== Example
  #
  #    "Status: 404; Message: 'Vehicle was not found'"
  def message
    "Error status: #{status}; Message: #{@message || 'not received'}"
  end

  ##
  # Returns request body or an empty hash if there was no body
  def body
    @body || {}
  end
end
