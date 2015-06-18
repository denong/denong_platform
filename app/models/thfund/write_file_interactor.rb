module Thfund
  class WriteFileInteractor
    def initialize(type)
      @type = type
      @date = Time.zone.today.strftime('%Y%m%d')
      @type_code = ThfundSettings.send(type).code
      @params = ThfundSettings.send(@type).params.keys
      filename = "OFD_242_42_#{@date}_#{@type_code}.TXT"
      file_path = FileSettings.for_thfund.local_path
      local_dir = File.join file_path, @date
      FileUtils.makedirs(local_dir) unless File.exist?(local_dir)

      @local_file = File.join local_dir ,filename
      @file = File.new(@local_file, "w", encoding: 'gbk')
      write_header
      write_params
    end

    def close
      @file.puts "OFDCFEND"
      @file.try(:close)
      @ok_file = File.new("#{@local_file}.ok", 'w')
      @ok_file.close
    end

    def write_datas datas
      return if datas.blank?
      @file.puts datas.count
      datas.each do |data|
        if data.respond_to? :as_json
          data_hash = data.as_json
          write_data data_hash
        end
      end
    end

    private

      def write_data data_hash
        content = ""
        @params.each do |param|
          if data_hash[param].present?
            content = write_attribute(content, param, data_hash[param])
          else
            content = write_attribute(content, param, "")
          end
        end
        @file.puts content
      end

      # 999
      # 02
      # 42      
      # 095
      def write_header
        @file.puts "OFDCFDAT"
        @file.puts "20"
        @file.puts "42"
        @file.puts "242"
        @file.puts @date
        @file.puts 999
        @file.puts "01"
        @file.puts "42"
        @file.puts "242"
      end

      def write_params
        @file.puts @params.count
        @params.each { |param| @file.puts(param) }
      end

      # 把一个属性的值写到字符串中（append）
      # type: 业务类型
      # content: 一行字符串的内容
      # attribute: 属性的名称
      # value: 属性值
      def write_attribute(content, attribute, value)
        # 读取配置文件
        attribute_desc = ThfundSettings.send(@type).params.send(attribute)
        attribute_type = attribute_desc[0]
        attribute_length = attribute_desc[1]

        # 根据配置类型，将value的值写到content中
        case attribute_type.upcase
        when "C"
          chinese_char_count = value.to_s.encode('gbk').bytes.size - value.to_s.size
          content = "#{content}#{value.to_s.ljust(attribute_length - chinese_char_count, ' ')}".encode('gbk')
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