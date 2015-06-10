if @merchant.errors.present?
  json.error @merchant.errors.full_messages.first
else
  json.extract! @merchant, :authentication_token, :phone, :id
end