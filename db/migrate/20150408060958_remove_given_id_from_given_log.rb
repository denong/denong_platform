class RemoveGivenIdFromGivenLog < ActiveRecord::Migration
  def change
    remove_column :given_logs, :given_id, :integer
  end
end
