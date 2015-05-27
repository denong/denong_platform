class AddPasswdToMemberCard < ActiveRecord::Migration
  def change
    add_column :member_cards, :passwd, :string
  end
end
