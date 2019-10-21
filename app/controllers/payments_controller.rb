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
  # Creates a new payment with data stored in the session
  def create
    payment = Payment.new(session[:vehicle_details])
    session[:vehicle_details]['payment_id'] = payment.payment_id
    redirect_to payments_path
  end

  private

  def check_payment_id
    payment_id = vehicle_details('payment_id')
    return unless payment_id

    Rails.logger.warn "Payment with id: #{payment_id} was already created"
    redirect_to payments_path
  end
end
