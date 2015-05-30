class MerchantMessagesController < ApplicationController

  acts_as_token_authentication_handler_for MerchantUser, only: [:create]
  # acts_as_token_authentication_handler_for User, only: [:index]
  respond_to :json

  def create
    @merchant_message = current_merchant.merchant_messages.create(create_params)
    respond_with(@merchant_message)
  end

  def index
    merchant = Merchant.find params[:merchant_id]
    if merchant.present?
      puts "merchant is:#{merchant.inspect}"
      puts "messages is:#{merchant.merchant_messages}"
      @merchant_messages = merchant.try(:merchant_messages).paginate(page: params[:page], per_page: 10)
    else
      @merchant_messages = []
    end
    # @merchant_messages = current_customer.get_unpushed_message params[:last_time]
  end

  private

    def create_params
      params.require(:merchant_message).permit(:time, :title, :content, 
          :summary, :url, thumb_attributes: [:id, :photo, :_destroy] )
    end
end
