class MerchantMessagesController < ApplicationController

  before_action :set_merchant_message, only: [:like, :unlike]

  acts_as_token_authentication_handler_for MerchantUser, only: [:create]
  # acts_as_token_authentication_handler_for User, only: [:index]
  acts_as_token_authentication_handler_for User, only: [:like, :unlike]
  respond_to :json

  def create
    @merchant_message = current_merchant.merchant_messages.create(create_params)
    respond_with(@merchant_message)
  end

  def index
    merchant = Merchant.find params[:merchant_id]
    if merchant.present?
      @merchant_messages = merchant.try(:merchant_messages).paginate(page: params[:page], per_page: 10)
    else
      @merchant_messages = []
    end
    # @merchant_messages = current_customer.get_unpushed_message params[:last_time]
  end

  def like
    if @merchant_message.present?
      current_customer.like! @merchant_message
    end
  end

  def unlike
    if @merchant_message.present?
      current_customer.unlike! @merchant_message
    end
  end

  private

    def set_merchant_message
      @merchant_message = MerchantMessage.find(params[:id])
    end

    def create_params
      params.require(:merchant_message).permit(:time, :title, :content, 
          :summary, :url, thumb_attributes: [:id, :photo, :_destroy] )
    end
end
