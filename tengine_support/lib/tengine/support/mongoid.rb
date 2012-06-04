# -*- coding: utf-8 -*-
require 'mongoid'

module Mongoid::Document::ClassMethods

  def human_name(options = nil)
    @@human_name_exception_handler ||= lambda{|*args| self.name }
    options = {
      :scope => [i18n_scope, :models],
      :exception_handler => @@human_name_exception_handler
    }.update(options || {})
    I18n.translate(self.name.underscore, options)
  end
end

require 'tengine/support'

module Tengine::Support::Mongoid
  extend self

  # Create indexes for each model given provided file_path directory and
  # the class is not embedded.
  #
  def create_indexes(pattern, connect_to=nil)
    connect_to ||= 'localhost:27017/tengine_production'
    host, port, db_name = connect_to.split('/').map{|s| s.split(':')}.flatten

    Mongoid.configure do |c|
      c.master = Mongo::Connection.new(host, port).db(db_name)
    end

    Dir.glob("#{pattern}/**/*.rb").each do |file|
      begin
        model = determine_model(file)
      rescue => e
        $stderr.puts(%Q{Failed to determine model from #{file}:
            #{e.class}:#{e.message}
            #{e.backtrace.join("\n")}
          })
      end

      if model
        model.create_indexes
        $stdout.puts "Generated indexes for #{model}"
      else
        $stdout.puts "Not a Mongoid parent model: #{file}"
      end
    end
  end

  def determine_model(file)
    if file =~ /lib\/(.*).rb$/
      model_path = $1.split('/')
      begin
        parts = model_path.map { |path| path.camelize }
        name = parts.join('::')
        klass = name.constantize
      rescue NameError, LoadError => e
        klass = parts.last.constantize
      end
    end
    return klass if klass.ancestors.include?(::Mongoid::Document) && !klass.embedded
  end
end
