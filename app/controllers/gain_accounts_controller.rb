class GainAccountsController < ApplicationController
  before_action :set_gain_account, only: [:show, :edit, :update, :destroy]

  acts_as_token_authentication_handler_for User

  respond_to :html, :json

  def index
    @gain_accounts = current_customer.try(:gain_accounts)
    respond_with(@gain_accounts)
  end

  def show
    respond_with(@gain_account)
  end

end
