# frozen_string_literal: true

##
# This is an abstract class used as a base for all service classes.

class BaseService
  ##
  # Creates an instance of a service and calls its +call+ method passing all the arguments.
  #
  # ==== Attributes
  #
  # Accepts all arguments and passes them to the service initializer

  def self.call(**args)
    new(args).call
  end
end
