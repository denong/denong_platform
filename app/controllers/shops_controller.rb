class ShopsController < ApplicationController
  
  respond_to :json
  acts_as_token_authentication_handler_for User

  def index
    @shops = Shop.all.paginate(page: params[:shop][:page], per_page: 10)
  end

end
