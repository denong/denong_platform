class AddTopicRefToMerchant < ActiveRecord::Migration
  def change
    add_reference :merchants, :topic, index: true
  end
end
