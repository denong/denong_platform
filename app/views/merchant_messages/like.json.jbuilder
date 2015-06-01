json.extract! @merchant_message, :id, :title, :summary, :url, :time, :merchant_id
json.like_count @merchant_message.like_count
json.liked current_customer.voted_for?(@merchant_message, vote_scope: "like") if current_customer