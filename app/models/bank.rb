# == Schema Information
#
# Table name: banks
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  bank_card_amount   :integer          default(0)
#  debit_card_amount  :integer          default(0)
#  credit_card_amount :integer          default(0)
#

class Bank < ActiveRecord::Base
  
  has_many :bank_cards
  has_many :bank_card_types
  
  has_one :logo, -> { where photo_type: "logo" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :logo, allow_destroy: true

  searchable do
    text :name
  end
  
  def bind_bank_card! bank_card
    self.bank_cards << bank_card
  end

  def bind_bank_card? customer, bank_card_type = nil
    puts "bank_card_type is #{bank_card_type.to_i}, class is #{bank_card_type.class}"
    logger.info "bank_card_type is #{bank_card_type.to_i}, class is #{bank_card_type.class}"
    if bank_card_type.nil?
      self.bank_cards.success.find_by(customer: customer).present? 
    else
      logger.info "bind_bank_card? customer is #{customer.try(:user).try(:phone)}, bank_card_type is #{bank_card_type}, #{self.bank_cards.success.find_by(customer: customer, bank_card_type: bank_card_type).inspect}"
      self.bank_cards.success.find_by(customer: customer, bank_card_type: bank_card_type.to_i).present?
    end
  end

end
