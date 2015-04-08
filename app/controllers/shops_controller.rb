class ShopsController < ApplicationController
  
  respond_to :json
  acts_as_token_authentication_handler_for User

  def index
    if params[:merchant_id].present?
      shops = Merchant.find(params[:merchant_id]).shops
    else
      shops = Shop.all
    end
    @shops = shops.paginate(page: params[:page], per_page: 10)
  end

end
