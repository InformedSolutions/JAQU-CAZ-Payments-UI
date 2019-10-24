# frozen_string_literal: true

##
# Controls the flow for calling Payments API.
#
class PaymentsController < ApplicationController
  before_action :check_payment_id, only: :create

  def index
    @payment_id = vehicle_details('payment_id')
  end

  ##
  # Creates a new payment from data stored in the session.
  # Sets in the session payment id returned from the backend.
  #
  # ==== Path
  #    POST /payments
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +la+ - selected local authority, required in the session
  # * +dates+ - selected dates, required in the session
  # * +daily_charge+ - daily charge for selected vehicle, required in the session
  #
  def create
    payment = Payment.new(session[:vehicle_details], payments_url)
    session[:vehicle_details]['payment_id'] = payment.payment_id
    redirect_to payments_path
  end

  private

  ##
  # Checks if payment id is present in the session
  #
  # If it is, redirects to payments index view
  #
  def check_payment_id
    payment_id = vehicle_details('payment_id')
    return unless payment_id

    Rails.logger.warn "Payment with id: #{payment_id} was already created"
    redirect_to payments_path
  end
end
