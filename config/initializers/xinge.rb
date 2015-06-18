require 'xinge'
Xinge.configure do |config|    
  config[:android_accessId] = 2100125778   
  config[:android_secretKey] = '989ca44f6f9d0b6333d6a040a0a09c01'     
  config[:ios_accessId] = 2200120442  
  config[:ios_secretKey] = '1d5677036156dd7124493acc62783de0'   
  config[:env] = Rails.env # if you are not in a rails app, you can set it config[:env]='development' or config[:env]='production', it is 'development' default.
end