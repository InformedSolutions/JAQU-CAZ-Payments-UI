# frozen_string_literal: true

##
# Controls selecting LAs where the user wants to pay for.
#
class LocalAuthoritiesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn

  ##
  # Renders the list of available local authorities.
  #
  # ==== Path
  #    GET /local_authorities
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def index
    @return_path = request.referer || enter_details_vehicles_path
  end
end
