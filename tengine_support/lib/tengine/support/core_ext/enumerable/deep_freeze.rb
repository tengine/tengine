module Enumerable
  def deep_freeze
    each do |i|
      case i
      when String # 1.8.7 tweak
        i.freeze
      when Enumerable
        i.deep_freeze
      else
        i.freeze
      end
    end
    freeze
  end
end
