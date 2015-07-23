# == Schema Information
#
# Table name: pension_accounts
#
#  id          :integer          not null, primary key
#  id_card     :string(255)
#  customer_id :integer
#  account     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  phone       :string(255)
#  name        :string(255)
#  state       :integer          default(3)
#

require 'rails_helper'

RSpec.describe PensionAccount, type: :model do

  # context "create pension log" do
  #   before(:each) do
  #     @customer = create(:customer)
  #     @identify = create(:identity_verify, customer: @customer, name:"于子洵", id_card: "330726199110011333")
  #     PensionAccount.create_by_identity_info
  #   end

  #   it "should add the number of pension account" do
  #     expect(PensionAccount.all.size).to eq(1)
  #   end
  # end

  # context "create pension log success" do
  #   before(:each) do
  #     @customer = create(:customer)
  #     @identify = create(:identity_verify, customer: @customer, name:"于子洵", id_card: "")
  #     PensionAccount.create_by_identity_info
  #     @pension_account = PensionAccount.find_by(id: PensionAccount.first.id)
  #     @pension_account.success
  #   end

  #   it "should make the pension account be success" do
  #     expect(@pension_account.state).to eq("success")
  #     expect(@customer.identity_verifies.last.account_state).to eq("success")
  #   end
  # end

  # context "create pension log success" do
  #   before(:each) do
  #     @customer = create(:customer)
  #     @identify = create(:identity_verify, customer: @customer, name:"于子洵", id_card: "")
  #     PensionAccount.create_by_identity_info
  #     @pension_account = PensionAccount.find_by(id: PensionAccount.first.id)
  #     @pension_account.failed
  #   end

  #   it "should make the pension account be success" do
  #     expect(@pension_account.state).to eq("fail")
  #     expect(@customer.identity_verifies.last.account_state).to eq("fail")
  #   end
  # end
end
