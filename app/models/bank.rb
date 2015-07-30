# == Schema Information
#
# Table name: banks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Bank < ActiveRecord::Base
  
  searchable do
    text :name
  end

  def self.name_search search_text
    where("name LIKE ?", "%#{search_text}%")
  end
  
end
