class AddReturnCodeToThfundAccount < ActiveRecord::Migration
  def change
    add_column :thfund_accounts, :return_code, :integer
  end
end
