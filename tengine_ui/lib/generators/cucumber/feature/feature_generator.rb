# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'named_arg')

module Cucumber
  class FeatureGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    argument :fields, :optional => true, :type => :array, :banner => "[field:type, field:type]"

    attr_reader :named_args

    def parse_fields
      @named_args = @fields.nil? ? [] : @fields.map { |arg| NamedArg.new(arg) }
    end

    def generate
      empty_directory 'features/step_definitions'
      name_space = class_name.underscore.split('/')[0..-2].join('/')
      template 'feature.erb'   , "features/#{name_space}/manage_#{plural_name}.feature"
      template 'feature_ja.erb', "features/#{name_space}/manage_#{plural_name}_ja.feature"
      template 'steps.erb'   , "features/step_definitions/#{name_space}/#{singular_name}_steps.rb"
      template 'steps_ja.erb', "features/step_definitions/#{name_space}/#{singular_name}_steps_ja.rb"
      gsub_file 'features/support/paths.rb', /'\/'/mi do |match|
        "#{match}\n    when /the new #{table_name.singularize} page/\n      new_#{table_name.singularize}_path\n"
      end
    end

    def self.banner
      "#{$0} cucumber:feature ModelName [field:type, field:type]"
    end

    def singular_name_ja
      options = {
        :locale => :ja,
        :scope => [:mongoid, :models], # [Mongoid::Document.i18n_scope, :models]みたいに指定したいけど、できなかったので直接指定してしまっています
        :exception_handler => lambda{|*args| class_name.humanize}
      }.update(options || {})
      result = I18n.translate(class_name.underscore, options)
      result.force_encoding("ASCII-8BIT")
    end

    def plural_name_ja
      "#{singular_name_ja}s"
    end

    private

    def human_attribute_name_ja(attr_name)
#     def human_attribute_name_ja(*attr_names)
#       attr_name = attr_names.first
      if attr_name.nil?
        puts caller.join("\n  ")
      end
      options = {
        :locale => :ja,
        :scope => [:mongoid, :attributes, class_name.underscore],
        :exception_handler => lambda{|*args| attr_name.humanize}
      }.update(options || {})
      result = I18n.translate(attr_name, options)
      result.force_encoding("ASCII-8BIT")
    end

  end
end
