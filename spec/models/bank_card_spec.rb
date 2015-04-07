# == Schema Information
#
# Table name: bank_cards
#
#  id          :integer          not null, primary key
#  bankcard_no :string(255)
#  id_card     :string(255)
#  name        :string(255)
#  phone       :string(255)
#  card_type   :integer
#  sn          :string(255)
#  bank        :integer
#  bind_state  :integer
#  bind_time   :datetime
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe BankCard, type: :model do
  it { should belong_to :customer }

  let(:card_attrs) { FactoryGirl.attributes_for(:bank_card) } 

  describe "bank cards" do

    context "create customer" do
      before(:each) do
        @bank_card = create(:bank_card)
      end

      it "should create customer automaticly" do
        expect(@bank_card.customer).not_to be_nil
      end

      it "should make the phone of customer equal to the phone of bank card" do
        expect(@bank_card.phone).to equal(@bank_card.customer.user.phone)
      end

      it "should increase the card's number by 1" do
        bank_card = BankCard.find_or_create_by(phone: card_attrs[:phone], bankcard_no: card_attrs[:bankcard_no])
        expect(@bank_card.customer.bank_cards.size).to eq(1)
      end
    end

    context "validations" do
      it "should both validation" do
        bank_card_1 = create(:bank_card, phone: "12345678901", bankcard_no: "0987654321123456")
        expect(bank_card_1).to be_valid
        bank_card_2 = create(:bank_card, phone: "12345678901", bankcard_no: "0987654321123457")
        expect(bank_card_2).to be_valid
        bank_card_3 = create(:bank_card, phone: "12345678910", bankcard_no: "0987654321123457")
        expect(bank_card_3).to be_valid
        bank_card_4 = build(:bank_card, phone: "12345678910", bankcard_no: "0987654321123457")
        expect(bank_card_4).not_to be_valid
      end
    end



  end
end