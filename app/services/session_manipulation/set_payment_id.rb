# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to set payment ID returned by the API.
  #
  # ==== Usage
  #    payment = Payment.new(session[:vehicle_details], 'www.wp.pl')
  #    SessionManipulation::SetPaymentId.call(session: session, payment_id: payment.payment_id)
  #
  class SetPaymentId < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 14

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +payment_id+ - UUID, id returned by the backend API
    #
    def initialize(session:, payment_id:)
      @session = session
      @payment_id = payment_id
    end

    # Adds the +payment_id+ to the session. Used by the class level method +.call+
    def call
      add_fields(payment_id: payment_id)
    end

    private

    # Get function for the payment ID
    attr_reader :payment_id
  end
end
