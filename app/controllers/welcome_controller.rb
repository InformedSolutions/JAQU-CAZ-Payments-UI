# frozen_string_literal: true

##
# Controller class for the home page.
#
class WelcomeController < ApplicationController
  ##
  # Renders the home page.
  # Clears anything already in the session should the user wish to start from scratch.
  #
  # ==== Path
  #    GET /
  #    GET /welcome/index
  #
  def index
    SessionManipulation::ClearSessionDetails.call(session: session, key: 1) if vrn
  end
end
