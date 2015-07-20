class RemoveUTypeCountInDataReport < ActiveRecord::Migration
  def change
    remove_column :data_reports, :u_type_count, :string
    add_column :data_reports, :u_ios_count, :float, default: 0
    add_column :data_reports, :u_android_count, :float, default: 0
    add_column :data_reports, :u_other_count, :float, default: 0
  end
end
