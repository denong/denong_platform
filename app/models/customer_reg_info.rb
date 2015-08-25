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

  def self.get_reg_info_by_phone query_params
    user = User.find_by_phone query_params[:phone]
    customer_reg_info = user.try(:customer).try(:customer_reg_info)
    if customer_reg_info.present?
       if query_params[:name] == customer_reg_info.name && query_params[:id_card] == customer_reg_info.id_card
         customer_reg_info
       else
        customer_reg_info.errors.add(:identity_verify, "身份证信息错误")
       end
    end
    customer_reg_info
  end
end
