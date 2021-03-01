# frozen_string_literal: true

##
# This class represents data returned by {CAZ API endpoint}[rdoc-ref:ComplianceCheckerApi.register_details]
class RegisterDetails
  ##
  # Creates an instance of a class
  #
  # ==== Attributes
  #
  # *+vrn+ - string, eg. 'CU57ABC'
  def initialize(vrn)
    @vrn = vrn
  end

  # Returns a boolean
  def register_compliant?
    register_details['registerCompliant']
  end

  # Returns a boolean
  def register_exempt?
    register_details['registerExempt']
  end

  # Returns a boolean
  def register_taxi?
    register_details['registeredNTR']
  end

  private

  attr_reader :vrn

  ##
  # Calls +/v1/compliance-checker/vehicles/:vrn/register-details endpoint with +GET+ method
  # and returns information about vehicle existence on specific registers.
  #
  # ==== Result
  #
  # Returned response will have the following attributes:
  # * +registerComplaint+ - boolean, states if vehicle features in Retrofit or is compliant in GPW
  # * +registerExempt+ - boolean, states if vehicle features in MOD or is exempt in GPW
  # * +registeredMOD+ - boolean, states if vehicle features in MOD
  # * +registeredGPW+ - boolean, states if vehicle features in GPW
  # * +registeredNTR+ - boolean, states if vehicle features in NTR
  # * +registeredRetrofit+ - boolean, states if vehicle features in Retrofit
  #
  def register_details
    @register_details ||= ComplianceCheckerApi.register_details(vrn)
  end
end
