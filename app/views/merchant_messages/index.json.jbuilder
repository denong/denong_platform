json.extract! @merchant_messages, :total_pages, :current_page
json.merchant_messages @merchant_messages do |merchant_message|
  json.extract! merchant_message, :id, :title, :summary, :url, :time, :merchant_id
  if merchant_message.thumb
    json.thumb image_url(merchant_message.thumb.photo.url(:product))
  else
    json.thumb ""
  end
end