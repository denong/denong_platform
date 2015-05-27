class AddPasswdToMemberCard < ActiveRecord::Migration
  def change
    add_column :member_cards, :Passwd, :string
  end
end
