class JajinIdentityCodeController < ApplicationController

  acts_as_token_authentication_handler_for MerchantUser, only: [:create]
  respond_to :html, :json

  def create
    @jajin_identity_code = current_merchant.jajin_identity_codes.build(create_params)
    @jajin_identity_code.save
    respond_with(@jajin_identity_code)
  end

  private

    def create_params
      params.require(:jajin_identity_code).permit(:amount, :expiration_time, :company)
    end

end
