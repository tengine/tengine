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
    logger = Logger.new($stdout)

    connect_to ||= 'localhost:27017/tengine_production'
    host, port, db_name = connect_to.split('/').map{|s| s.split(':')}.flatten

    Mongoid.configure do |c|
      if Mongoid::VERSION < '3.0.0'
        c.master = Mongo::Connection.new(host, port).db(db_name)
      else
        c.sessions = {
          default: {
            database: db_name,
            hosts: [
              "#{host}:#{port}"
            ]
          }
        }
      end
    end

    Dir.glob("#{pattern}/**/*.rb").each do |file|
      if model = determine_model(file)
        model.create_indexes
        logger.info "Generated indexes for #{model}"
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
        begin
          klass = parts.last.constantize
        rescue => e
          return nil
        end
      end
    end

    if klass.ancestors.include?(::Mongoid::Document) && !klass.embedded
      return klass
    end
  end
end
