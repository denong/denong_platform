class AddPosIndToPosMachine < ActiveRecord::Migration
  def change
    add_column :pos_machines, :pos_ind, :string
  end
end
