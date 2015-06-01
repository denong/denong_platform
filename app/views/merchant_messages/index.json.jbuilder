json.extract! @merchant_messages, :total_pages, :current_page
json.merchant_messages @merchant_messages do |merchant_message|
  json.extract! merchant_message, :id, :title, :summary, :url, :time, :merchant_id
  if merchant_message.thumb
    json.thumb image_url(merchant_message.thumb.photo.url(:product))
  else
    json.thumb ""
  end
  json.like_count merchant_message.like_count
  json.liked current_customer.voted_for?(merchant_message, vote_scope: "like") if current_customer
end