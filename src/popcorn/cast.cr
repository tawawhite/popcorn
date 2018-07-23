require "json/any"
require "yaml/any"

module Popcorn
  module Cast
    # Returns the `Int32` value represented by given data type.
    def to_int(v : T) forall T
      case v
      when Int
        v.as(Int).to_i
      when Float
        v.as(Float).to_i
      when Bool
        v.as(Bool) ? 1 : 0
      when Nil
        0
      when String
        value = v.as(String).to_i?(strict: false)
        value ? value : 0
      else
        raise TypeCastError.new("cast from #{T} to Int32 failed. at #{__FILE__}:#{__LINE__}")
      end
    end

    # Returns the `Int64` value represented by given data type.
    def to_int64(v : T) forall T
      case v
      when Int
        v.as(Int).to_i64
      when Float
        v.as(Float).to_i64
      when Bool
        v.as(Bool) ? 1 : 0
      when Nil
        0
      when String
        value = v.as(String).to_i64?(strict: false)
        value ? value : 0
      else
        raise TypeCastError.new("cast from #{T} to Int64 failed. at #{__FILE__}:#{__LINE__}")
      end
    end

    # Returns the `Float64` value represented by given data type.
    def to_float(v : T) forall T
      case v
      when Int
        v.as(Int).to_f
      when Float
        v.as(Float).to_f
      when Nil
        0
      when String
        value = v.as(String).to_f?(strict: false)
        value ? value : 0
      else
        raise TypeCastError.new("cast from #{T} to Float64 failed. at #{__FILE__}:#{__LINE__}")
      end
    end

    # Returns the `Float32` value represented by given data type.
    def to_float32(v : T) forall T
      case v
      when Int
        v.as(Int).to_f32
      when Float
        v.as(Float).to_f32
      when Nil
        0
      when String
        value = v.as(String).to_f32?(strict: false)
        value ? value : 0
      else
        raise TypeCastError.new("cast from #{T} to Float32 failed. at #{__FILE__}:#{__LINE__}")
      end
    end

    # Returns the `Time` value represented by given data type.
    def to_time(v : T, location : Time::Location = Time::Location::UTC, formatters : Array(String)? = nil) forall T
      case v
      when Time
        v.as(Time)
      when Int
        Time.epoch(v.as(Int))
      when String
        parse_time(v.as(String), location, formatters)
      else
        raise TypeCastError.new("cast from #{T} to Time failed. at #{__FILE__}:#{__LINE__}")
      end
    end

    # Returns the `Bool` value represented by given data type.
    # It accepts true, t, yes, y, on, 1, false, f, no, n, off, 0. Any other value return an error.
    def to_bool(v : T) forall T
      value = case v
              when Bool
                v.as(Bool)
              when Int
                !v.as(Int).zero?
              when Float
                !v.as(Float).zero?
              when Nil
                false
              when Symbol
                to_bool(v.as(Symbol).to_s)
              when JSON::Any
                v.as(JSON::Any).as_bool
              when YAML::Any
                if object = v.as(YAML::Any).as_s?
                  to_bool(object)
                end
              when String
                object = v.as(String).downcase
                if %w(true t yes y on 1).includes?(object)
                  true
                elsif %w(false f no n off 0).includes?(object)
                  false
                end
              end

      raise TypeCastError.new("cast from #{T} to Bool failed. at #{__FILE__}:#{__LINE__}") if value.nil?

      value
    end

    {% for method in @type.methods %}
      def {{ method.name.id }}?(v : T) forall T
        # Returns the `{{ method.name }}` value represented by given data type. If can not convert return nil.
        {{ method.name.id }}(v)
      rescue TypeCastError
        nil
      end
    {% end %}

    private def parse_time(v : String, location = Time::Location::UTC, formatters : Array(String)? = nil)
      formatters = formatters ? formatters.not_nil!.concat(time_formatters) : time_formatters
      formatters.each do |formatter|
        begin
          return Time.parse(v, formatter, location)
        rescue Time::Format::Error
          next
        end
      end

      raise TypeCastError.new("cast from String to Time failed.")
    end

    private def time_formatters
      [
        "%a, %d %b %Y %T %z", # RFC 1123Z eg, Tue, 20 Jan 2018 01:20:33 +0800
        "%a, %d %b %Y %T",    # RFC 1123 eg, Tue, 20 Jan 2018 01:20:33 GMT
        "%A, %d-%b-%y %T",    # RFC 850 eg, Tuesday, 14-Feb-16 01:20:33 GMT
        "%d %b %y %H:%M %z",  # RFC 822Z 20 Jan 18 01:20 +0800
        "%d %b %y %H:%M",     # RFC 822 20 Jan 18 01:20 UTC
        "%a %b %d %T %z %Y",  # RubyDate
        "%a %b %d %T %Y",     # ANSIC/UnixDate
        "%FT%T%:z",           # ISO 8601 eg 2018-01-20T01:20:33Z+08:00
        "%F %T %z",           # RFC 3339
        "%FT%TZ",             # RFC 3339 nano
        "%F %H:%M:%S.%9N",    # Date Time Nano, eg 2018-01-20 01:20:33.000000000
        "%F %H:%M:%S.%6N",    # Date Time Macro, eg 2018-01-20 01:20:33.000000
        "%F %H:%M:%S.%3N",    # Date Time Milli, eg 2018-01-20 01:20:33.000
        "%F %T",              # Date Time, eg 2018-01-20 01:20:33
        "%F",                 # Date, eg 2018-01-20
        "%d %b %Y",           # Date, eg 20 Jan 2018
      ]
    end
  end
end