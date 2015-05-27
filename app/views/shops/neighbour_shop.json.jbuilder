json.total_pages @shops.total_pages
json.current_page @shops.current_page
 
json.shops @shops do |shop|
  json.extract! shop, :id, :name, :addr, :contact_person, :contact_tel, :work_time, :votes_up, :lon, :lat, :post_code, :email, :service_tel, :welcome_text, :remark
  json.image image_url(shop.pic.photo.url(:product)) if shop.pic
  json.logo image_url(shop.logo.photo.url(:product)) if shop.logo
end