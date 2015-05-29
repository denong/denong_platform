json.array!(@topics) do |topic|
  json.extract! topic, :id, :title, :subtitle
  json.pic image_url(topic.pic.photo.url(:product)) if topic.pic
  json.merchant_num topic.merchants.size
end