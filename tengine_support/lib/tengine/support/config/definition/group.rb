require 'tengine/support/config/definition'

class Tengine::Support::Config::Definition::Group
  include Tengine::Support::Config::Definition::HasManyChildren

  attr_reader :__name__
  attr_accessor :__parent__

  def initialize(__name__, options)
    @__name__ = __name__
    @options = options
  end

  def root
    __parent__.root
  end

  def hidden?
    !!@options[:hidden]
  end

end
