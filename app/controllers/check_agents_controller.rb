class CheckAgentsController < ApplicationController
  respond_to :json

  def reset
    @agent = Agent.reset_user_password params 
    respond_with @agent
  end
end
