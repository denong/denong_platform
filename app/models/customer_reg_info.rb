# == Schema Information
#
# Table name: customer_reg_infos
#
#  id            :integer          not null, primary key
#  customer_id   :integer
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  verify_state  :integer
#  id_card       :string(255)
#  nick_name     :string(255)
#  gender        :integer
#  account_state :integer          default(3)
#

class CustomerRegInfo < ActiveRecord::Base
  enum verify_state: [:unverified, :wait_verify, :verified, :verified_fail]
  enum account_state: [ :processing, :success, :fail, :not_created]

  enum gender: [:male, :female]
  belongs_to :customer
  has_one :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image, allow_destroy: true

  # def account_state
  #   self.try(:customer).try(:identity_verifies).try(:last).try(:account_state)
  # end
  def self.change_id_card id_card
    id_card = id_card.to_s
    unless id_card.size == 15
      return id_card 
    end
    id_card = id_card.insert(6,"19")
    sum = 0
    m_arr = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]
    (0..id_card.size-1).each do |index|
      sum += m_arr[index]*id_card[index].to_i
    end
    result = ["1","0","X","9","8","7","6","5","4","3","2"]
    id_card << result[sum%11]
    id_card
  end

  def self.get_reg_info_by_phone query_params
    user = User.find_by_phone query_params[:phone]
    customer_reg_info = user.try(:customer).try(:customer_reg_info)
    if customer_reg_info.present? && customer_reg_info.name.present? && customer_reg_info.id_card.present?
      logger.info "before is #{query_params[:id_card]}"
      id_card = change_id_card query_params[:id_card]
      logger.info "--------------id_card is #{id_card}, customer_reg_info is #{customer_reg_info.name}, #{customer_reg_info.id_card}"
      if query_params[:name] == customer_reg_info.name && id_card == customer_reg_info.id_card
        customer_reg_info
      else
        customer_reg_info.errors.add(:identity_verify, "身份信息错误")
      end
    end
    logger.info "return --------------"
    customer_reg_info
  end
end
