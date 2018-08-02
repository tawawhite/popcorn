require "./cast/*"

module Popcorn
  module Cast
    # Returns the target value or `Nil` represented by given data type.
    def cast?(raw, other)
      case other
      when Int8.class    then to_int8?(raw)
      when Int16.class   then to_int16?(raw)
      when Int32.class   then to_int32?(raw)
      when Int64.class   then to_int64?(raw)
      when UInt8.class   then to_uint8?(raw)
      when UInt16.class  then to_uint16?(raw)
      when UInt32.class  then to_uint32?(raw)
      when UInt64.class  then to_uint64?(raw)
      when Float32.class then to_float32?(raw)
      when Float64.class then to_float64?(raw)
      when Bool.class    then to_bool?(raw)
      when Time.class    then to_time?(raw)
      when Array.class   then to_array?(raw)
      when Hash.class    then to_hash?(raw)
      when String.class  then raw.to_s
      end
    rescue TypeCastError
      nil
    end

    # Returns the target value represented by given data type.
    def cast(raw, other)
      cast_error!(raw.class.to_s, other.to_s) unless value = cast?(raw, other)
      value
    end

    # Raise a `TypeCastError` exception.
    def cast_error!(source : String, other : String)
      raise TypeCastError.new("cast from #{source} to #{other} failed.")
    end

    # Generate to `to_xxx` methods from `to_xxx?`.
    macro generate!
      {% begin %}
        {% for method in @type.methods %}
          {% if method.name.starts_with?("to_") %}
            {% mname = method.name.tr("?", "") %}
            {% margs = method.args.map { |a| s = "#{a.name.id} : #{a.restriction.id}"; s = "#{s.id} = #{a.default_value}" if a.default_value == nil || a.default_value; s }.join(", ") %}
            {% rtype = method.args[0].restriction %}
            {% mtype = method.name.gsub(/^to_/, "").gsub(/\?$/, "").capitalize.gsub(/^Ui/, "UI") %}

            # Returns the `{{ mtype.id }}` value represented by given `{{ rtype.id }}` type, else raise a `TypeCastError` exception.
            def {{ mname.id }}({{ margs.id }}){% if mname.includes?("to_array") || mname.includes?("to_hash") %} forall T{% end %}
              value = {{ method.name }}({{ method.args.map { |a| a.name }.join(", ").id }})
              cast_error!({{ rtype.id.stringify }}, {{ mtype.id.stringify }}) if value.nil?
              value
            end
          {% end %}
        {% end %}
      {% end %}
    end

    generate!
  end
end
