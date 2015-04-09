json.total_pages @gain_histories.total_pages
json.current_page @gain_histories.current_page


json.gain_histories @gain_histories do |gain_history|
  json.extract! gain_history, :gain, :gain_date
end
