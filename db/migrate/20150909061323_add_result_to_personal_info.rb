class AddResultToPersonalInfo < ActiveRecord::Migration
  def change
    add_column :personal_infos, :result, :integer
  end
end
