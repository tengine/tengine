# -*- coding: utf-8 -*-
require 'tengine_support'

class Tengine::Support::UniqueKeyError < StandardError
end

module Enumerable

  # このメソッド名はダサイので良い名前募集してます。
  def map_to_hash(key_method, &block)
    block ||= lambda{|i| i}
    inject({}) do |d, i|
      key = i.send(key_method)
      raise Tengine::Support::UniqueKeyError, "duplicated key found: #{key.inspect}" unless d[key].nil?
      d[key] = block.call(i)
      d
    end
  end

end
