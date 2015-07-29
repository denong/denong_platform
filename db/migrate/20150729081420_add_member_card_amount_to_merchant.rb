class AddMemberCardAmountToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :member_card_amount, :integer, default: 0
  end
end
