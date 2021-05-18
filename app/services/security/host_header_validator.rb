# frozen_string_literal: true

##
# Module used for security checks.
module Security
  ##
  # Service used to chcek if host from the request is valid and has not been modified over the request.
  #
  class HostHeaderValidator < BaseService
    ##
    # Initializer method.
    #
    # ==== Attributes
    # * +request+ - request details
    # * +allowed_hosts+ - allowed hosts from the configuration
    #
    def initialize(request:, allowed_hosts:)
      @allowed_hosts = sanitize_hosts(allowed_hosts)
      @origin_host = request.get_header('HTTP_HOST').to_s.sub(/:\d+\z/, '')
      @x_forwarded_host = load_header_value(request.x_forwarded_host)
      @x_forwarded_server = load_header_value(request.get_header('HTTP_X_FORWARDED_SERVER'))
      @x_host = load_header_value(request.get_header('HTTP_X_HOST'))
    end

    # Main class used to check if the hosts were not manipulated.
    def call
      return if hosts_allowed?

      raise InvalidHostException
    end

    private

    # Loads host value from the header
    def load_header_value(header)
      header.to_s.split(/,\s?/).last.to_s.sub(/:\d+\z/, '')
    end

    # Checks if host is allowed
    def allowed?(host)
      return true if host.blank?

      allowed_hosts.any? { |allowed_host| allowed_host.match?(host) }
    end

    # Checks if all provided hosts are allowed
    def hosts_allowed?
      allowed?(@origin_host) && allowed?(@x_forwarded_host) && allowed?(@x_forwarded_server) &&
        allowed?(@x_host)
    end

    # Sanitize list of hosts from the configuration
    def sanitize_hosts(hosts)
      hosts.split(',').map { |host| sanitize_host(host) }
    end

    # Sanitize single host string
    def sanitize_host(host)
      if host.start_with?('.')
        /\A(.+\.)?#{Regexp.escape(host[1..])}\z/i
      else
        /\A#{host}\z/i
      end
    end

    # Attributes reader
    attr_reader :allowed_hosts, :x_forwarded_host, :x_forwarded_server, :x_host
  end
end
