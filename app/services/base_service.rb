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
  #
  def self.call(**args)
    new(args).call
  end

  ##
  # Default initializer. May be overridden in each service
  #
  def initialize(_options = {}); end

  private

  # Logs msg on +info+ level
  def log_action(msg)
    Rails.logger.info "[#{self.class.name}] #{msg}"
  end
end
