# frozen_string_literal: true

module ActionController
  # TestSession used in helper tests doesn't have dig method
  class TestSession < Rack::Session::Abstract::SessionHash
    def dig(*keys)
      to_h.dig(*keys.map(&:to_s))
    end
  end
end
