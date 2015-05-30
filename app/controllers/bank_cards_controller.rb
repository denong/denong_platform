class BankCardsController < ApplicationController

  acts_as_token_authentication_handler_for User

  def create
    params[:user_id] = current_customer.id
    @bank_card = BankCard.add_bank_card params
  end

  def send_msg
    params[:user_id] = current_customer.id
    @bank_card = BankCard.send_msg params
  end

  def index
    @bank_cards = current_customer.bank_cards
  end

  def bank_info
    @bankbard_no = params[:bankbard_no]
    @bank_card_info = BankCard.find_info @bankbard_no
  end



end
