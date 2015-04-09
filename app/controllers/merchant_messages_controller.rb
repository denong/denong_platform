class MerchantMessagesController < ApplicationController

  acts_as_token_authentication_handler_for User#, only: [:create]
  respond_to :json

  def create
  end

  def index
    @merchant_messages = current_customer.get_unpushed_message params[:last_time]
  end

end
