# == Schema Information
#
# Table name: balance_logs
#
#  id          :integer          not null, primary key
#  jajin       :float(24)
#  balance     :float(24)
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class BalanceLog < ActiveRecord::Base
  belongs_to :merchant

  scope :in, -> { where "balance > 0" }
  scope :out, -> { where "balance < 0" }

  after_create :calculate

  private


    def calculate
      if balance > 0
        increase_balance
      else
        decrease_balance
      end
    end

    def increase_balance
      self.merchant.balance += balance
      self.merchant.save
    end

    def decrease_balance
      self.merchant.balance += balance
      if self.merchant.jajin_total.nil?
        self.merchant.jajin_total = 0
      end
      self.merchant.jajin_total += balance.to_f.abs*100
      self.merchant.save
      self.jajin = balance.to_f.abs*100
    end

end
