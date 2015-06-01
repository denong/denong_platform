module Thfund
  class FileInteractor

    def initialize()
      date = Time.zone.today.strftime('%Y%m%d')
      @file = File.new("OFD_242_42_#{date}_01.TXT", "w")
      @file.puts "OFDCFDAT"
      @file.puts "20"
      @file.puts "42"
      @file.puts "242"
      @file.puts date
      @file.puts 999
    end

    def close
      @file.puts "OFDCFEND"
      @file.try(:close)
    end

    # 999
    # 02
    # 42      
    # 095
    def write_file_header
      @file.puts "01"
      @file.puts "42"
      @file.puts "242"
    end

    def puts content
      @file.puts content
    end

    # 读取字符串其中一个属性
    # type: 业务类型
    # content: 一行字符串的内容
    # attribute: 属性的名称
    # index: 偏移
    def read_attribute(type, content, attribute, index)

      # 读取配置文件
      attribute_desc = ThfundSettings.send(type).params.send(attribute)
      attribute_type = attribute_desc[0]
      attribute_length = attribute_desc[1]

      # 读取内容，更新游标
      value = content[index, index + attribute_length]
      index += attribute_length

      # 根据配置类型，得到最后的Value值
      case attribute_type.upcase
      when "C"
        value = value.rstrip
      when "A"
        value = value.to_i
      when "N"
        float_ind = attribute_desc[2]
        value = value.to_f / (10 ** float_ind) if float_ind
      end

      # 返回相关的值
      [value, index]
    end

    # 把一个属性的值写到字符串中（append）
    # type: 业务类型
    # content: 一行字符串的内容
    # attribute: 属性的名称
    # value: 属性值
    def write_attribute(type, content, attribute, value)
      # 读取配置文件
      attribute_desc = ThfundSettings.send(type).params.send(attribute)
      attribute_type = attribute_desc[0]
      attribute_length = attribute_desc[1]

      # 根据配置类型，将value的值写到content中
      case attribute_type.upcase
      when "C"
        content = "#{content}#{value.to_s.ljust(attribute_length, ' ')}"
      when "A"
        content = "#{content}#{value.to_s.rjust(attribute_length, '0')}"
      when "N"
        float_ind = attribute_desc[2]
        value = value.to_f * (10 ** float_ind) if float_ind
        content = "#{content}#{value.to_i.to_s.rjust(attribute_length, '0')}"
      end
    end
  end
end