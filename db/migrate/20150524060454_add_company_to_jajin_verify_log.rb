class AddCompanyToJajinVerifyLog < ActiveRecord::Migration
  def change
    add_column :jajin_verify_logs, :company, :string
  end
end
