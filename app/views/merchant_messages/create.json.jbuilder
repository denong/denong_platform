json.merchant_message @merchant_message, :time, :title, :content, :summary, :url, :merchant_id
json.thumb image_url(@merchant_message.thumb.photo.url(:product)) if @merchant_message.thumb