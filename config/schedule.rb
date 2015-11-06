# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "./log/schedule.log"

every 1.minutes do
  runner "MemberCardPointLog.process_data_from_cache"
end

every 1.day, :at => '00:05' do
  runner "DataReport.new.process"
  runner "MerchantLog.new.process"
  runner "LogProcess.generate_guangdong_telecom_data"
end

every 1.day, :at => '15:20' do
  runner "PensionAccount.create_by_identity_info"
end
