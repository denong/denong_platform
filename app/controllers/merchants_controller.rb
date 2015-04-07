class MerchantsController < ApplicationController
  
  respond_to :json
  acts_as_token_authentication_handler_for User

  def index
    @merchants = Merchant.all
  end
  
end
