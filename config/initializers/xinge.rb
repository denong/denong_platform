require 'xinge'
Xinge.configure do |config|    
  config[:android_accessId] = 2100119963   
  config[:android_secretKey] = '27451a9f55f04fb7f15a997d37b7b647'     
  config[:ios_accessId] = 2100119963  
  config[:ios_secretKey] = 'dbe0d16b3f9dbdc08b55ce37603ccb15'   
  config[:env] = Rails.env # if you are not in a rails app, you can set it config[:env]='development' or config[:env]='production', it is 'development' default.
end