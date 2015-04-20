class AddGainAccountToGainHistory < ActiveRecord::Migration
  def change
    add_reference :gain_histories, :gain_account, index: true
  end
end
