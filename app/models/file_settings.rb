class FileSettings < Settingslogic
  source "#{Rails.root}/config/file.yml"
  namespace Rails.env
end