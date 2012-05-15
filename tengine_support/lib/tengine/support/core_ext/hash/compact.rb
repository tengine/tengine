# -*- coding: utf-8 -*-

class Hash
  # Destructive elimination of nil, like Array#compact!
  def compact!
    reject! do |k, v|
      v.nil?
    end
  end

  # Intuitive, see the source.
  def compact
    dup.tap {|i| i.compact! }
  end
end
