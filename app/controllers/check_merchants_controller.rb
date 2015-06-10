class CheckMerchantsController < ApplicationController

  respond_to :json

  def reset
    @merchant = MerchantUser.reset_user_password params 
    respond_with @merchant
  end

end
