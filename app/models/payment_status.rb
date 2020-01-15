# frozen_string_literal: true

##
# Class used to serialize data from PUT /payments/:id backend API endpoint.
# Calls PaymentsApi.payment_status
#
class PaymentStatus
  # Getter for payment ID
  attr_reader :id, :caz_name

  # Initializer method for the class
  #
  # ==== Attributes
  #
  # * +id+ - uuid, payment ID set by the backend API
  #
  def initialize(id, caz_name)
    @id = id
    @caz_name = caz_name
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

  # Returns the central reference number of the payment.
  def payment_reference
    payment_data['referenceNumber']
  end

  # Returns the external payment ID.
  def external_id
    payment_data['externalPaymentId']
  end

  # Checks if payment was successful. Return boolean
  def success?
    status.eql?('SUCCESS')
  end

  private

  # Calls backend API endpoint
  def payment_data
    @payment_data ||= PaymentsApi.payment_status(payment_id: id, caz_name: caz_name)
  end
end
