class MerchantGivingLogsController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User
  def show
    @merchant_giving_logs = current_customer.try(:merchant_giving_logs).find_by_merchant_id(params[:merchant_giving_log][:merchant_id])
  end

end
