# frozen_string_literal: true

module SessionManipulation
  class SetComplianceDetails < BaseManipulator
    LEVEL = 4

    def initialize(session:, la_id:)
      @session = session
      @la_id = la_id
    end

    def call
      compliance_details = ComplianceDetails.new(session[SESSION_KEY].merge('la_id' => la_id))
      add_fields(
        la_id: la_id,
        la_name: compliance_details.zone_name,
        daily_charge: compliance_details.charge,
        weekly_possible: session[SESSION_KEY]['taxi'] && compliance_details.zone_name == 'Leeds'
      )
    end

    private

    attr_reader :la_id
  end
end
