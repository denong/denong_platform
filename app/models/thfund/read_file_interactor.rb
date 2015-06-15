module Thfund
  class ReadFileInteractor
    attr_accessor :type

    def initialize(filename)
      @file = File.new(filename, "r", encoding: 'gbk')
      @type_code = filename.split(/\.|_/)[-2]
      @type = get_type_by_code @type_code
      read_head
      read_params
    end

    def close
      @file.try(:close)
    end

    def foreach
      @data_count = @file.readline.to_i
      (0..@data_count-1).each do |index|
        data_hash = read_data
        if block_given?
          yield data_hash
        else
          puts data_hash
        end
      end
    end

    private
      def get_type_by_code type_code
        case type_code
        when "01"
          "create_account_request"
        when "02"
          "create_account_response"
        when "03"
          "trade_request"
        when "04"
          "trade_response"
        when "05"
          "asset_file"
        when "07"
          "gain_file"
          
        end
      end

      def read_head
        (0..8).each { |index| @file.readline }
      end

      def read_params
        @param_count = @file.readline.to_i
        @params = []
        (0..@param_count-1).each do |index|
          @params << @file.readline.strip
        end
      end

      def read_data
        content = @file.readline.encode('gbk')
        data_hash = {}
        if content.present?
          index = 0
          @params.each do |attribute|
            value, index = read_attribute content, attribute, index
            data_hash[attribute] = value if value.present?
          end
        end
        data_hash
      end

      # 读取字符串其中一个属性
      # type: 业务类型
      # content: 一行字符串的内容
      # attribute: 属性的名称
      # index: 偏移
      # 读出来的内容是gbk格式
      def read_attribute(content, attribute, index)

        # 读取配置文件
        attribute_desc = ThfundSettings.send(@type).params.send(attribute)
        attribute_type = attribute_desc[0]
        attribute_length = attribute_desc[1]

        # 读取内容，更新游标
        value = content.byteslice(index ... index + attribute_length).to_s.encode('utf-8')
        index += attribute_length

        # 根据配置类型，得到最后的Value值
        case attribute_type.upcase
        when "C"
          value = value.strip
        when "A"
          value = value.to_i
        when "N"
          float_ind = attribute_desc[2]
          value = value.to_f / (10 ** float_ind) if float_ind
        end
        # 返回相关的值
        [value, index]
      end
  end
end