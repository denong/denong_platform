# == Schema Information
#
# Table name: shops
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  addr                    :string(255)
#  contact_person          :string(255)
#  contact_tel             :string(255)
#  work_time               :string(255)
#  merchant_id             :integer
#  created_at              :datetime
#  updated_at              :datetime
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  lon                     :float
#  lat                     :float
#

class Shop < ActiveRecord::Base
  acts_as_votable
  
  belongs_to :merchant
  has_many :pos_machines

  def votes_up 
    self.cached_votes_up
  end 

  def self.get_neighbour_shop addr_data_params
    current_place = Geokit::LatLng.new(addr_data_params[:lon], addr_data_params[:lat])
    shop_distance = {}
    Shop.all.each do |shop|
      shop_place = Geokit::LatLng.new(shop.lon, shop.lat)
      shop_distance[shop] = current_place.distance_from( shop_place ) 
    end 
    shop_distance.sort_by {|key, value| value}.reverse
    shop_distance.keys
  end
end
