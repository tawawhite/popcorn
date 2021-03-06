module Popcorn::Cast
  # Alias to `to_int32?`
  def to_int?(raw : Hash)
    to_int32?(raw)
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_int32?(raw : Hash)
    nil
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_int8?(raw : Hash)
    nil
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_int16?(raw : Hash)
    nil
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_int64?(raw : Hash)
    nil
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_uint?(raw : Hash)
    to_uint32?(raw)
  end

  # Alias to `to_uint?`
  def to_uint32?(raw : Hash)
    nil
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_uint8?(raw : Hash)
    nil
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_uint16?(raw : Hash)
    nil
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_uint64?(raw : Hash)
    nil
  end

  # Alias to `to_float64?`
  def to_float?(raw : Hash)
    to_float64?(raw)
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_float64?(raw : Hash)
    nil
  end

  # Returns the `Nil` value represented by given Hash type.
  def to_float32?(raw : Hash)
    nil
  end

  # Returns the `Nil` value represented by given Hash type.
  #
  # - `location` argument applies for `Int`/`String` types
  # - `formatters` argument applies for `String` type.
  def to_time?(raw : Hash, location : Time::Location? = nil, formatters : Array(String)? = nil)
    nil
  end

  # Returns the `Bool` or `Nil` value represented by given data type.
  def to_bool?(raw : Hash)
    !raw.size.zero?
  end

  # Returns the `Array` or `Nil` value represented by given Hash type.
  #
  # ```
  # Popcorn.to_array?({"a" => "b", "c" => "d"})   # => ["a", "b", "c", "d"]
  # ```
  def to_array?(raw : Hash, value_type : T.class = String) forall T
    Array(T).new.tap do |obj|
      raw.each do |k, v|
        obj << k << v
      end
    end
  end

  # Returns the `Hash` or `Nil` value represented by given Hash type.
  def to_hash?(raw : Hash, value_type : T.class = String) forall T
    raw
  end
end
