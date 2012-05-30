# -*- coding: utf-8 -*-
if Rails.env == "development"

  require 'rails/generators/generated_attribute'
  require 'generators/rspec'

  class Rails::Generators::GeneratedAttribute
    def field_type_with_array_and_hash_support
      @field_type ||=
        case type
        when :array then :text_field
        when :hash then :text_area
        else
          field_type_without_array_and_hash_support
        end
    end
    alias_method_chain :field_type, :array_and_hash_support

    # rspec/lib/generators/rspec.rb を上書き
    def input_type
      @input_type ||=
        case type
        when :hash, :text then 'textarea'
        else
          "input"
        end
    end

    def default_with_array_and_hash_support
      @default ||=
        case type
        when :array then ["abc", "123"]
        when :hash then {"a"=>"1", "b"=>"2"}
        else
          default_without_array_and_hash_support
        end
    end
    alias_method_chain :default, :array_and_hash_support
  end

end
