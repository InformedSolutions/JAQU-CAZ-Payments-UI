# frozen_string_literal: true

##
# Controls the flow for calling Payments API.
#
class PaymentsController < ApplicationController
  before_action :clear_payment_in_session, only: :create
  before_action :check_payment_details, except: :create

  ##
  # The page used as a landing point after the GOV.UK payment process
  #
  # Calls +/payments/:id+ backend endpoint to get payment status
  #
  # Redirects to either success or failure payments path
  #
  # ==== Path
  #    GET /payments
  #
  # ==== Params
  # * +payment_id+ - vehicle registration number, required in the session
  #
  def index
    payment = PaymentStatus.new(vehicle_details('payment_id'))
    save_payment_details(payment)
    if payment.success?
      redirect_to success_payments_path
    else
      redirect_to failure_payments_path
    end
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
  # * +la_id+ - selected local authority, required in the session
  # * +dates+ - selected dates, required in the session
  # * +charge+ - daily charge for selected vehicle, required in the session
  #
  def create
    payment = Payment.new(session[:vehicle_details], payments_url)
    SessionManipulation::SetPaymentId.call(session: session, payment_id: payment.payment_id)
    redirect_to payment.gov_uk_pay_url
  end

  ##
  # Renders page after successful payment
  #
  # ==== Path
  #    GET /payments/success
  #
  # ==== Params
  # * +external_id+ - payment ID , required in the session
  # * +user_email+ - user email address, required in the session
  # * +payment_reference+ - payment reference number, required in the session
  # * +vrn+ - vehicle registration number, required in the session
  # * +la_name+ - selected local authority, required in the session
  # * +dates+ - selected dates, required in the session
  # * +total_charge+ - total charge for selected dates, required in the session
  # * +chargeable_zones+ - number of zones in which the vehicle is chargeable, required in the session
  #
  def success
    @payment_details = PaymentDetails.new(session[:vehicle_details])
    clear_payment_in_session
  end

  ##
  # Renders page after unsuccessful payment
  #
  # ==== Path
  #    GET /payments/failure
  #
  # ==== Params
  # * +payment_reference+ - payment reference, required in the session
  # * +external_id+ - external payment id, required in the session
  #
  def failure
    @payment_details = PaymentDetails.new(session[:vehicle_details])
    clear_payment_in_session
  end

  private

  ##
  # Checks if payment id is present in the session
  #
  # If it is not, redirects to beginning of the payment process
  #
  def check_payment_details
    payment_id = vehicle_details('payment_id')
    return if payment_id

    redirect_to_enter_details('Payment')
  end

  # Clears details of the payment in the session
  def clear_payment_in_session
    SessionManipulation::ClearSessionDetails.call(session: session, key: 14)
  end

  # Save payment details using SessionManipulation::SetPaymentDetails
  def save_payment_details(payment)
    SessionManipulation::SetPaymentDetails.call(
      session: session,
      email: payment.user_email,
      payment_reference: payment.payment_reference,
      external_id: payment.external_id
    )
  end
end
