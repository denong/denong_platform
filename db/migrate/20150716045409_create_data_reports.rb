class CreateDataReports < ActiveRecord::Migration
  def change
    create_table :data_reports do |t|
      t.date :report_date
      t.float :u_day_count, default: 0
      t.float :u_month_count, default: 0
      t.float :u_sum, default: 0
      t.string :u_type_count
      t.float :ul_day_count
      t.float :ul_month_count
      t.float :ul_sum
      
      t.float :j_day_count, default: 0
      t.float :j_month_count, default: 0
      t.float :j_sum, default: 0
      
      t.timestamps
    end
  end
end
