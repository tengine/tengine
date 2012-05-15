class Array
  def deep_dup
    map{|v| v.respond_to?(:deep_dup) ? v.deep_dup : v }
  end

end
