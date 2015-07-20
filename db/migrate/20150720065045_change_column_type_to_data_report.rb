class ChangeColumnTypeToDataReport < ActiveRecord::Migration
  def change
    change_column :data_reports,  :report_date, :datetime
  end
end
