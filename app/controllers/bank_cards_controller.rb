class BankCardsController < ApplicationController

  acts_as_token_authentication_handler_for User

  def create
    params[:user_id] = current_customer.id
    params[:auth_type] ||= 1
    @bank_card = BankCard.add_bank_card params
  end

  def send_msg
    params[:user_id] = current_customer.id
    @bank_card = BankCard.send_msg params
  end

  def index
    @bank_cards = current_customer.bank_cards.success
  end

  def bank_info
    @bankcard_no = params[:bankcard_no]
    @bank_card_info = BankCard.find_info @bankcard_no
    bank_card = BankCard.find_by bankcard_no: @bankcard_no
    @certification_type =  bank_card.try(:certification_type) || @bank_card_info.try(:certification_type) || "sms"
  end



end
