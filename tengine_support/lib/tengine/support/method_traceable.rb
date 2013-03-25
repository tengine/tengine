require 'tengine/support'

module Tengine::Support::MethodTraceable

  class << self
    attr_accessor :disabled
  end

  IGNORED_METHOD_NAMES = ['`']

  def method_trace(*symbols)
    return if Tengine::Support::MethodTraceable.disabled
    symbols.flatten!
    symbols.uniq!
    symbols.each do |symbol|
      s = symbol.to_s
      next if IGNORED_METHOD_NAMES.include?(s)
      original_method = (s =~ /([\?\!])$/) ?
        "#{s[0..-2]}_without_traceable#{$1}" :
        "_#{s}_without_traceable"
      definition_start = __LINE__ + 2
      definitions = <<-EOS
        if method_defined?(:#{original_method})
          raise "Already method_tracing #{symbol}"
        end
        alias #{original_method} #{symbol}

        def #{symbol}(*args, &block)
          begin
            Tengine.logger.info("\#{self.class.name}##{symbol} called")
            result = #{original_method}(*args, &block)
            Tengine.logger.info("\#{self.class.name}##{symbol} complete")
            return result
          rescue Exception => e
            unless e.instance_variable_get(:@__traced__)
              Tengine.logger.error("\#{self.class.name}##{symbol} failure. [\#{e.class.name}] \#{e.message}\n  " << e.backtrace.join("\n  "))
              e.instance_variable_set(:@__traced__, true)
            end
            raise
          end
        end

      EOS
      begin
        class_eval(definitions, __FILE__, definition_start)
      rescue SyntaxError => e
        error = SyntaxError.new("illegal statement for method #{symbol.inspect}\n#{definitions}\n#{e.message}")
        error.set_backtrace(e.backtrace)
        raise error
      end
    end
  end

end
