class AddTagsToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :tags, :text, array:true, default: []
  end
end
