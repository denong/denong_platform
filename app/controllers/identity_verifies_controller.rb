class IdentityVerifiesController < ApplicationController
  before_action :set_identity_verify, only: [:update]

  acts_as_token_authentication_handler_for User, only: [:create], fallback_to_devise: false
  acts_as_token_authentication_handler_for MerchantUser, only: [:update]
  acts_as_token_authentication_handler_for Agent, only: [:create], fallback_to_devise: false
  respond_to :html, :json

  def create
    if current_customer.present?
      @identity_verify = current_customer.identity_verifies.build(create_params)
      @identity_verify.save
      respond_with(@identity_verify)
    elsif current_agent.present?
      @identity_verify = IdentityVerify.build(create_params)
      @identity_verify.save
      respond_with(@identity_verify)
    end
  end

  def update
    @identity_verify.update(update_params)
    respond_with(@identity_verify)
  end


  def index
    @identity_verify = current_customer.identity_verifies.try(:last)
  end

  private
    def set_identity_verify
      @identity_verify = IdentityVerify.find(params[:id])
    end

    def create_params
      params.require(:identity_verify).permit(:name, :id_card,
          front_image_attributes: [:id, :photo, :_destroy],
          back_image_attributes: [:id, :photo, :_destroy]
          )
    end

    def update_params
      params.require(:identity_verify).permit(:verify_state)
    end
end
