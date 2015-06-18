class AgentsController < ApplicationController

  acts_as_token_authentication_handler_for Agent, only: [:update]
  respond_to :json

  def update
    @agent = current_agent
    params = update_params
    params[:sms_token] = "989898"
    @agent.update(params)
    respond_with(@agent)
  end

  private

    def update_params
      params.require(:agent).permit(:name, :contact_person, :phone, :password, :email)
    end

end
