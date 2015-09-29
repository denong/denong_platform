class TempProcess

  def self.process
    keys = ["error_logs_201509282110", "error_logs_201509282137", "error_logs_201509290855", "error_logs_201509290856"]
    items = $redis.hgetall(keys[0])
    items.map do |i, e|
      content = e.gsub(/\s:merchant=>.*?>,/, '')
      p "#{i} ---> #{content}"
    end
    nil
  end
end
