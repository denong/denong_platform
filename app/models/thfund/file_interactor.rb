module Thfund
  class FileInteractor
    def self.read_attribute_hash(type,  content, attribute, index)

      # 读取配置文件
      attribute_desc = ThfundSettings.send(type).send(attribute)
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
        value = value.to_f / (10 ** float_ind)
      end

      # 返回相关的值
      [value, index]
    end
  end
end