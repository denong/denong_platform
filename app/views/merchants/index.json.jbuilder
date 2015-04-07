json.array! @merchants do |merchant|
  json.extract! merchant, :sys_reg_info
end