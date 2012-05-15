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
