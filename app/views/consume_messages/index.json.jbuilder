json.array!(@consume_messages) do |consume_message|
  json.extract! consume_message, :id
  json.url consume_message_url(consume_message, format: :json)
end
