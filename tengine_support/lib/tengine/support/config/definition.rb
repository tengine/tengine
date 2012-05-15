require 'tengine/support/config'

require 'active_support/core_ext/class/attribute'

module Tengine::Support::Config::Definition
  autoload :Field, 'tengine/support/config/definition/field'
  autoload :Group, 'tengine/support/config/definition/group'
  autoload :Suite, 'tengine/support/config/definition/suite'
  autoload :HasManyChildren, 'tengine/support/config/definition/has_many_children'
  autoload :OptparseVisitor, 'tengine/support/config/definition/optparse_visitor'

  class << self
    def included(klass)
      klass.extend(ClassMethods)
      klass.class_eval do
        self.class_attribute :children, :instance_writer => false, :instance_reader => false
        self.children = []
        self.class_attribute :definition_reference_names, :instance_writer => false
        self.definition_reference_names = []
      end
    end
  end

  module ClassMethods
    def field(__name__, *args, &block)
      attrs = args.last.is_a?(Hash) ? args.pop : {}
      attrs[:description] = args.first unless args.empty?
      attrs[:__name__] = __name__
      attrs[:__parent__] = self
      attrs[:convertor] = block

      if (superclass < Tengine::Support::Config::Definition) &&
          (self.children == self.superclass.children)
        self.children = self.superclass.children.dup
      end
      if field = children.detect{|child| child.__name__ == __name__}
        new_field = field.dup
        new_field.update(attrs)
        idx = self.children.index(field)
        self.children[idx] = new_field
        field = new_field
      else
        field = Field.new(attrs)
        self.children << field
      end
      (class << self; self; end).module_eval do
        define_method(field.__name__){ field }
      end
      self.class_eval do
        field_name = field.__name__
        ivar_name = :"@#{field_name}"

        define_method(field_name) do
          if result = instance_variable_get(ivar_name)
            result
          else
            field = child_by_name(field_name)
            result = field ? field.default_value : nil
            instance_variable_set(ivar_name, result)
            result
          end
        end

        define_method("#{field.__name__}=") do |value|
          instance_variable_set("@#{field.__name__}", field.convert(value, self))
        end
      end
    end

    def parameters
      @parameters ||= []
    end

    def parameter(parameter_name)
      parameters << parameter_name
      self.class_eval do
        attr_accessor parameter_name
      end
    end

    def depends(*definition_reference_names)
      if superclass.is_a?(Tengine::Support::Config::Definition) &&
          (self.definition_reference_names == self.superclass.definition_reference_names)
        self.definition_reference_names = self.superclass.definition_reference_names.dup
      end
      self.class_eval do
        definition_reference_names.each do |ref_name|
          attr_accessor ref_name
        end
      end
      self.definition_reference_names += definition_reference_names
    end

  end

  attr_accessor :__name__, :__parent__, :children

  def instantiate_children
    @children = self.class.children.map do |class_child|
      child = class_child.dup
      child.__parent__ = self
      child
    end
    self
  end

  def child_by_name(__name__)
    (children || []).detect{|child| child.__name__ == __name__}
  end

  def find(name_array)
    name_array = Array(name_array)
    head = name_array.shift
    if child = child_by_name(head)
      name_array.empty? ? child : child.find(name_array)
    else
      nil
    end
  end

  def to_hash
    children.inject({}) do |dest, child|
      dest[child.__name__] = child.to_hash
      dest
    end
  end

  def load(hash)
    hash.each{|__name__, value| send("#{__name__}=", value)}
  end

  def accept_visitor(visitor)
    visitor.visit(self)
  end

  def root
    __parent__ ? __parent__.root : nil
  end

  def name_array
    (__parent__ ? __parent__.name_array : []) + [__name__]
  end

  def get_value(obj)
    obj.is_a?(Proc) ? self.instance_eval(&obj) : obj
  end

  def short_opt
    r = root.mapping[ name_array ]
    r ? "-#{r}" : nil
  end

  def long_opt
    '--' << name_array.join('-').gsub(%r{_}, '-')
  end

  def action?; false; end
  def separator?; false; end

  def [](child_name)
    self.send(child_name)
  end

  def []=(child_name, value)
    self.send("#{child_name}=", value)
  end

end
