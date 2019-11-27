# frozen_string_literal: true

##
# Class used to serialize data from GET /payments/:id backend API endpoint.
# Calls PaymentsApi.payment_status
#
class PaymentStatus
  # Getter for payment ID
  attr_reader :id

  # Initializer method for the class
  #
  # ==== Attributes
  #
  # * +id+ - uuid, payment ID set by the backend API
  #
  def initialize(id)
    @id = id
  end

  # Returns the payment status.
  #
  # Eg. 'SUCCESS'
  def status
    payment_data['status']&.upcase
  end

  # Returns an email that was submitted by the user during the payment process.
  def user_email
    payment_data['userEmail']
  end

  # Checks if payment was successful. Return boolean
  def success?
    status.eql?('SUCCESS')
  end

  private

  # Calls backend API endpoint
  def payment_data
    @payment_data ||= PaymentsApi.payment_status(payment_id: id)
  end
end
