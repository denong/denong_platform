json.extract! @gain_histories, :total_pages, :current_page
json.gain_histories @gain_histories do |gain_history|
  json.extract! gain_history, :gain, :gain_date
end
