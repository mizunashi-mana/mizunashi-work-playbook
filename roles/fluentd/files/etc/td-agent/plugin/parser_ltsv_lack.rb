require 'fluent/plugin/parser'

module Fluent
  module Plugin
    class LackedLabeledTSVParser < Parser
      Plugin.register_parser('ltsv_lack', self)

      desc 'The delimiter character (or string) of TSV values'
      config_param :delimiter, :string, default: "\t"
      desc 'The delimiter pattern of TSV values'
      config_param :delimiter_pattern, :regexp, default: nil
      desc 'The delimiter character between field name and value'
      config_param :label_delimiter, :string, default: ':'

      config_set_default :time_key, 'time'

      def configure(conf)
        super
        @delimiter = @delimiter_pattern || @delimiter
      end

      def parse(text)
        r = {}
        text.split(@delimiter).each do |entry|
          if entry.include? @label_delimiter
            parsed_entry = entry.split(@label_delimiter, 2)
            if parsed_entry.size > 1
              key, value = parsed_entry
              r[key] = value
            else
              key = parsed_entry[0]
              r[key] = ''
            end
          end
        end
        time, record = convert_values(parse_time(r), r)
        yield time, record
      end
    end
  end
end
