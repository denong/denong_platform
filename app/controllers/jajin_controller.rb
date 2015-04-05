class JajinController < ApplicationController

  acts_as_token_authentication_handler_for User

  def index
    @jajin = current_customer.try(:jajin)
  end
end
