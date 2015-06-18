json.extract! @shop, :id, :name, :addr, :contact_person, :contact_tel, :work_time, :votes_up, :post_code, :email, :service_tel, :welcome_text, :remark, :lon, :lat
json.pic image_url(@shop.pic.photo.url(:product)) if @shop.pic
json.logo image_url(@shop.logo.photo.url(:product)) if @shop.logo
json.pos_machines_count @shop.pos_machines.try(:count).to_i

json.pos_total_pages @pos.total_pages
json.pos_current_page @pos.current_page
json.pos_machines @pos do |pos_machine|
  json.id pos_machine.id
  json.acquiring_bank pos_machine.acquiring_bank
  json.operator pos_machine.operator
  json.opertion_time pos_machine.opertion_time
  json.shop_id pos_machine.shop_id
  json.pos_ind pos_machine.pos_ind
end

