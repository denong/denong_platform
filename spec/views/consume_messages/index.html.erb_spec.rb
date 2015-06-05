require 'rails_helper'

RSpec.describe "consume_messages/index", type: :view do
  before(:each) do
    assign(:consume_messages, [
      ConsumeMessage.create!(),
      ConsumeMessage.create!()
    ])
  end

  it "renders a list of consume_messages" do
    render
  end
end
