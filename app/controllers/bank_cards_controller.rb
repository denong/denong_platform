class BankCardsController < ApplicationController

  acts_as_token_authentication_handler_for User

  def create
    @bank_card = BankCard.add_bank_card params,current_customer
  end

  def send_msg
    params["userId"] = current_customer.id
    BankCard.send_msg params
  end
end
