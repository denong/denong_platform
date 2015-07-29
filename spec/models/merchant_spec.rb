# == Schema Information
#
# Table name: merchants
#
#  id                      :integer          not null, primary key
#  merchant_user_id        :integer
#  created_at              :datetime
#  updated_at              :datetime
#  ratio                   :float
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  topic_id                :integer
#  consumption_total       :float
#  jajin_total             :float
#  consume_count           :integer
#  verify_state            :integer
#  agent_id                :integer
#  convert_ratio           :float            default(1.0)
#  balance                 :float            default(0.0)
#  member_card_amount      :integer          default(0)
#

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should belong_to :topic }
  it { should belong_to :merchant_user }
  it { should have_one :busi_reg_info }
  it { should have_one :sys_reg_info }
  it { should have_many :shops}
  it { should have_many :tl_trades }
  it { should have_many :yl_trades }
  it { should have_many :merchant_messages }
  it { should have_many :merchant_giving_logs }
  it { should have_many :jajin_logs }

  context "searchable" do
    it { should have_searchable_field(:sys_name) }
    it { should have_searchable_field(:votes_up) }

    # it 'accepts search field' do
    #   MerchantSearch.search(search: "merchant")
    #   expect(Sunspot.session).to have_search_params(:fulltext, "merchant")
    # end

  end
end
