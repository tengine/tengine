# -*- coding: utf-8 -*-
require 'tengine/support/config/definition'

require 'tengine/support/yaml_with_erb'

class Tengine::Support::Config::Definition::Suite
  include Tengine::Support::Config::Definition::HasManyChildren

  def initialize(hash_or_filepath = nil)
    build if respond_to?(:build)
    case hash_or_filepath
    when Hash then load(hash_or_filepath)
    when String then load_file(hash_or_filepath)
    end
  end


  def mapping(mapping = nil)
    @mapping = mapping if mapping
    @mapping
  end

  def parent; nil; end
  def root; self; end

  def load_file(filepath)
    load(YAML.load_file(filepath))
  end

  def banner(banner = nil)
    @banner = banner if banner
    @banner
  end

  def parse!(argv)
    v = Tengine::Support::Config::Definition::OptparseVisitor.new(self)
    self.accept_visitor(v)
    if load_config = children.detect{|child| child.type == :load_config}
      opts = v.option_parser.getopts(argv.dup) # このdup重要。もう一度parseに使用する場合に中身が空にならないように。
      if filepath = opts[load_config.__name__.to_s]
        load_file(filepath)
      end
    end
    v.option_parser.parse(argv.dup)
  end

  def name_array
    []
  end

end
