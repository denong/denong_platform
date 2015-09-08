unless @agent.errors.present?
  json.extract! @agent, :id, :contact_person, :email, :created_at, :updated_at, :phone, :name, :authentication_token
end
