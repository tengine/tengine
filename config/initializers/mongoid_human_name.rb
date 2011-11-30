# -*- coding: utf-8 -*-
module Mongoid::Document::ClassMethods
  extend ActiveSupport::Memoizable

  def human_name(options = nil)
    @@human_name_exception_handler ||= lambda{|*args| self.name }
    options = {
      :scope => [i18n_scope, :models],
      :exception_handler => @@human_name_exception_handler
    }.update(options || {})
    I18n.translate(self.name.underscore, options)
  end
  # memorizeの説明は以下を参照してください
  # http://wota.jp/ac/?date=20081025
  memoize :human_name
end
