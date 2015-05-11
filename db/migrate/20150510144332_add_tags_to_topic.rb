class AddTagsToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :tags, :string, array:true, default: []
  end
end
