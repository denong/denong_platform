json.array!(@gain_accounts) do |gain_account|
  json.id gain_account.id
  json.gain_org_thumb image_url(gain_account.gain_org.thumb.photo.url(:small))
  json.gain_org_title gain_account.gain_org.title
  json.gain_org_sub_title gain_account.gain_org.sub_title
  json.gain_total gain_account.total
end
