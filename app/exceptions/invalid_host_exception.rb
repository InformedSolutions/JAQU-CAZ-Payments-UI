# frozen_string_literal: true

##
# Raises exception if checked host header was modified.
#
class InvalidHostException < StandardError
  ##
  # Initializer method for the class.
  #
  def initialize
    super('Invalid host header')
  end
end
