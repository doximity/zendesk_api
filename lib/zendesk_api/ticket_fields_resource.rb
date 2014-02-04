class ZendeskApi::TicketFieldsResource < ZendeskApi::Resource
  def resource_name
    "ticket_field"
  end

  module CustomFieldsMapper
    def custom_field_for(title, type, available)
      custom_field = available.find do |e|
        e["title"] == title && 
        (e["type"] == type || (e["type"] == "tagger" && type == "text"))
      end

      custom_field
    end

    def type_for(value)
      case value
      when TrueClass, FalseClass
        "checkbox"
      when Fixnum
        "integer"
      when Float
        "decimal"
      else
        if value.is_a?(Symbol)
          return "tagger"
        end

        if value.match(/^\d+$/)
          return "integer"
        end

        if !value.match(/^\d(?:\.\d)+/)
          begin
            Date.parse(value)
            return "date"
          rescue ArgumentError
          end
        end

        "text"
      end
    end

    def value_for(type, value)
      return if value.nil?

      case type
      when "tagger"
        value.to_sym
      when "date"
        Date.parse(value).strftime("%Y-%m-%d")
      when "integer"
        value.to_i
      when "decimal"
        value.to_f
      else
        value
      end
    end
  end
end
