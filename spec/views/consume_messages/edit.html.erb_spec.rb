require 'rails_helper'

RSpec.describe "consume_messages/edit", type: :view do
  before(:each) do
    @consume_message = assign(:consume_message, ConsumeMessage.create!())
  end

  it "renders the edit consume_message form" do
    render

    assert_select "form[action=?][method=?]", consume_message_path(@consume_message), "post" do
    end
  end
end
