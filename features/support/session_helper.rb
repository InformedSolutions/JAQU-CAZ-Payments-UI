# frozen_string_literal: true

module SessionHelper
  def add_vrn_to_session
    page.set_rack_session(vrn: vrn)
  end

  def add_la_to_session
    page.set_rack_session(la: SecureRandom.uuid)
  end

  def vrn
    'CU57ABC'
  end
end

World(SessionHelper)
