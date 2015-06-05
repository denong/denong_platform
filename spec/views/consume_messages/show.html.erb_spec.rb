require 'rails_helper'

RSpec.describe "consume_messages/show", type: :view do
  before(:each) do
    @consume_message = assign(:consume_message, ConsumeMessage.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
