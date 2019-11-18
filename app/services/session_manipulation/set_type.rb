# frozen_string_literal: true

module SessionManipulation
  class SetType < BaseManipulator
    LEVEL = 3

    def initialize(session:, type:)
      @session = session
      @type = type
    end

    def call
      add_fields(type: type)
    end

    private

    attr_reader :type
  end
end
