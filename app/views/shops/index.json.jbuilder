json.total_pages @shops.total_pages
json.current_page @shops.current_page
 
json.shops @shops do |shop|
  json.extract! shop, :id, :name, :addr, :contact_person, :contact_tel, :work_time, :votes_up, :lon, :lat, :pic, :logo
end