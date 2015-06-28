class AddPicUrlToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :pic_url, :string
  end
end
