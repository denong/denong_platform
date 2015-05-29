class ThfundSettings < Settingslogic
  source "#{Rails.root}/config/thfund.yml"
  namespace Rails.env
end