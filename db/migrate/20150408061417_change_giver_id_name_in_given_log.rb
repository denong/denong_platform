class ChangeGiverIdNameInGivenLog < ActiveRecord::Migration
  def change
    rename_column :given_logs, :giver_id, :giver_or_given_id
  end
end
