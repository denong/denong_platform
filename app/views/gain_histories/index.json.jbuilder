json.array!(@gain_histories) do |gain_history|
  json.extract! gain_history, :gain, :gain_date
end
