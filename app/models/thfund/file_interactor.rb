module Thfund
  class FileInteractor

    # 读取字符串其中一个属性
    # type: 业务类型
    # content: 一行字符串的内容
    # attribute: 属性的名称
    # index: 偏移
    def self.read_attribute(type, content, attribute, index)

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

    # 把一个属性的值写到字符串中（append）
    # type: 业务类型
    # content: 一行字符串的内容
    # attribute: 属性的名称
    # value: 属性值
    def self.write_attribute(type, content, attribute, value)
      # 读取配置文件
      attribute_desc = ThfundSettings.send(type).send(attribute)
      attribute_type = attribute_desc[0]
      attribute_length = attribute_desc[1]

      # 根据配置类型，将value的值写到content中
      case attribute_type.upcase
      when "C"
        content = "#{content}#{value.to_s.ljust(attribute_length, ' ')}"
      when "A"
        content = "#{content}#{value.to_s.rjust(attribute_length, '0')}"
      when "N"
        value = value.to_f * (10 ** float_ind)
        content = "#{content}#{value.to_i.to_s.rjust(attribute_length, '0')}"
      end
    end
  end
end