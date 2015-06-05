require 'rails_helper'

RSpec.describe "consume_messages/new", type: :view do
  before(:each) do
    assign(:consume_message, ConsumeMessage.new())
  end

  it "renders new consume_message form" do
    render

    assert_select "form[action=?][method=?]", consume_messages_path, "post" do
    end
  end
end
