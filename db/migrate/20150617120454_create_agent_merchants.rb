class CreateAgentMerchants < ActiveRecord::Migration
  def change
    create_table :agent_merchants do |t|
      t.references :agent, index: true
      t.references :merchant, index: true

      t.timestamps
    end
  end
end
