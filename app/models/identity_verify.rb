# == Schema Information
#
# Table name: identity_verifies
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  verify_state  :integer
#  customer_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#  id_card       :string(255)
#  account_state :integer          default(3)
#

class IdentityVerify < ActiveRecord::Base
  enum verify_state: [ :unverified, :wait_verify, :verified, :verified_fail]
  enum account_state: [ :processing, :success, :fail, :not_created]

  belongs_to :customer
  has_one :front_image, -> { where photo_type: "front" }, class_name: "Image", as: :imageable, dependent: :destroy
  has_one :back_image, -> { where photo_type: "back" }, class_name: "Image", as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :front_image, allow_destroy: true
  accepts_nested_attributes_for :back_image, allow_destroy: true

  before_create :set_state
  after_create :auto_validate!

  validates :name, presence: true
  validates :id_card, presence: true
  # validates :front_image, presence: true
  # validates :back_image, presence: true

  # 如何身份证符合规则，则直接接收，否则直接拒绝
  def auto_validate!
    if (id_card =~ /^(\d{15}$|^\d{18}$|^\d{17}(\d|X|x))$/) && (IdentityVerify.idcard_verify? name, id_card)
      accept!
    else
      reject!
    end
  end

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

  def self.idcard_verify? name, id_card
    personal_info = PersonalInfo.find_by(id_card: id_card, name: name)
    if personal_info.present? && personal_info.result == 0
      return true
    end

    IdentityVerify.change_id_card id_card
    response = RestClient.get 'http://apis.haoservice.com/idcard/VerifyIdcard', {params: {cardNo: id_card, realName: name, key: "0e7253b6cf7f46088c18a11fdf42fd1b"}}
    response_hash = MultiJson.load(response)

    # haoserivce库中不存在的数据，认为是正确的。
    if response_hash["reason"] == "NoExistERROR"
      PersonalInfo.find_or_create_by(name: name, id_card: id_card, result: 0)
      return true
    end
    if response_hash["error_code"].to_i == 0
      if response_hash["result"]["isok"]
        PersonalInfo.find_or_create_by(name: name, id_card: id_card, result: 0)
      end
      return response_hash["result"]["isok"]
    else
      # 错误数据，结果为1
      PersonalInfo.find_or_create_by(name: name, id_card: id_card, result: 1)
      return false
    end
  end

  def reject!
    self.verified_fail!
    customer_reg_info = self.customer.customer_reg_info
    customer_reg_info.verified_fail!
  end

  def accept!
    customer_reg_info = self.customer.customer_reg_info
    customer_reg_info.name = name
    customer_reg_info.id_card = id_card
    if id_card[-2].to_i % 2 == 1
      customer_reg_info.male!
    else
      customer_reg_info.female!
    end
    customer_reg_info.verified!
    customer_reg_info.processing!
    customer_reg_info.save
    self.verified!
    self.processing!
  end

  def set_state
    self.verify_state ||= :wait_verify
    customer_reg_info = self.customer.customer_reg_info
    customer_reg_info.wait_verify!
    # auto_validate!
  end
  
end
