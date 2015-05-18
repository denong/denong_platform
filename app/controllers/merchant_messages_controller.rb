class MerchantMessagesController < ApplicationController

  acts_as_token_authentication_handler_for MerchantUser, only: [:create]
  acts_as_token_authentication_handler_for User, only: [:index]
  respond_to :json

  def create
    @merchant_message = current_merchant.merchant_messages.create(create_params)
    respond_with(@merchant_message)
  end

  def index
    @merchant_messages = current_customer.get_unpushed_message params[:last_time]
  end

  private

    def create_params
      params.require(:merchant_message).permit(:time, :title, :content, 
          :summary, :url, thumb_attributes: [:id, :photo, :_destroy] )
    end
end
