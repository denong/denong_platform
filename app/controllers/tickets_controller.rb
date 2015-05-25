class TicketsController < ApplicationController

  acts_as_token_authentication_handler_for User, only: [:create]

  respond_to :html, :json

  def create
    @ticket = current_customer.create_ticket create_params
    respond_with(@ticket)
  end

  private

    def create_params
      params.require(:ticket).permit(:customer_id)
    end
end
