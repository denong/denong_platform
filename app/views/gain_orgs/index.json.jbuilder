json.array!(@gain_orgs) do |gain_org|
  json.extract! gain_org, :id
  json.url gain_org_url(gain_org, format: :json)
end
