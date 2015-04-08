class ChangeAmmoutNameInGivenLog < ActiveRecord::Migration
  def change
    rename_column :given_logs, :ammout, :amount
  end
end
