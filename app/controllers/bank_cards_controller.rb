class BankCardsController < ApplicationController

  acts_as_token_authentication_handler_for User

  def create
    params[:user_id] = current_customer.id
    @bank_card = BankCard.add_bank_card params
  end

  def send_msg
    params[:user_id] = current_customer.id
    BankCard.send_msg params
  end

  def index
    @bank_cards = current_customer.bank_cards
  end

end
