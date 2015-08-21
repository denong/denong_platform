json.array!(@status_codes) do |status_code|
  json.extract! status_code, :id
  json.url status_code_url(status_code, format: :json)
end
