json.array! @shops do |shop|
  json.extract! shop, :id, :name, :addr, :contact_person, :contact_tel, :work_time
end