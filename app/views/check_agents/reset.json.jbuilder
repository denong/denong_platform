if @agent.errors.present?
  json.error @agent.errors.full_messages.first
else
  json.extract! @agent, :authentication_token, :phone, :id
end