json.extract! @banks, :total_pages, :current_page
json.banks @banks do |bank|
  json.name bank.name
end