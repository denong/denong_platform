class AddCompanyToConsumeMessage < ActiveRecord::Migration
  def change
    add_column :consume_messages, :company, :string
  end
end
