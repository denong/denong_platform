json.extract! @shops, :total_pages, :current_page
json.shops @shops do |shop|
  json.extract! shop, :id, :name, :addr, :contact_person, :contact_tel, :work_time
end