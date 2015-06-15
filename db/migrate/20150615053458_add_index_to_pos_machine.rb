class AddIndexToPosMachine < ActiveRecord::Migration
  def change
    add_index :pos_machines, :pos_ind
  end
end
