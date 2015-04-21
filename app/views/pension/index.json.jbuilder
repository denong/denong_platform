if @pension.present?
  json.extract! @pension, :account, :total
  json.latest 234
else
  json.error "养老金账号暂未开通"
end