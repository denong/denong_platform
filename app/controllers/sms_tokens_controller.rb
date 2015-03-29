class SmsTokensController < ApplicationController

  respond_to :html, :json

  def create
    @sms_token = SmsToken.find_or_initialize_by phone: sms_token_params[:phone]
    @sms_token.activate!
    @sms_token.save
    respond_with(@sms_token)
  end

  private
    def set_sms_token
      @sms_token = SmsToken.find(params[:id])
    end

    def sms_token_params
      params.require(:sms_token).permit(:phone)
    end
end
