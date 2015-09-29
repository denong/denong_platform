class TempProcess

  def self.process
    keys = ["error_logs_201509282137", "error_logs_201509290855", "error_logs_201509290856"]
    keys.each do |key|
      items = $redis.hgetall(key)
      items.map do |i, e|
        content = e.gsub(/\s:merchant=>.*?>,/, '')
        p "#{i} ---> #{content}"
        $redis.hset(key, i, content)
      end
    end
    nil
  end
end
