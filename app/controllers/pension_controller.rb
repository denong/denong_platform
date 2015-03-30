class PensionController < ApplicationController
  
  acts_as_token_authentication_handler_for User

  def index
    @pension = current_customer.try(:pension)
  end
end
