# -*- coding: utf-8 -*-
require 'tengine/core'

require 'active_support/core_ext/array/extract_options'

module Tengine::Core::OptimisticLock
  extend ActiveSupport::Concern
  include Tengine::Core::SafeUpdatable

  included do
    cattr_accessor :lock_optimistically, :instance_writer => false
    self.lock_optimistically = true

    class << self
      alias_method :locking_field=, :set_locking_field
    end
  end

  class RetryOverError < StandardError
  end

  class << self
    def update_with_lock_stack
      @update_with_lock_stack ||= []
    end
  end

  DEFAULT_RETRY_COUNT = (ENV['TENGINE_OPTIMISTIC_LOCK_RETRY_MAX'] || 5).to_i

  def update_with_lock(options = {})
    unless Tengine::Core::OptimisticLock.update_with_lock_stack.empty?
      Tengine.logger.warn("Tengine::Core::OptimisticLock#update_with_lock is used in another #update_with_lock.\n  " << caller.join("\n  "))
    end
    Tengine::Core::OptimisticLock.update_with_lock_stack.push(caller.first)
    begin
      retry_count = options[:retry] || DEFAULT_RETRY_COUNT
      idx = 1
      while idx <= retry_count
        yield
        return if __update_with_lock__
        reload
        idx += 1
      end
      raise RetryOverError, "retried #{retry_count} times but failed to update"
    ensure
      Tengine::Core::OptimisticLock.update_with_lock_stack.pop
    end
  end

  def __update_with_lock__
    lock_field_name = self.class.locking_field
    current_version = self.send(lock_field_name)
    hash = as_document.dup.stringify_keys
    hash.delete("_id") # _id not allowed in mod
    new_version = current_version + 1
    hash[lock_field_name.to_s] = new_version
    selector = { :_id => self.id, lock_field_name.to_sym => current_version }
    result = update_in_safe_mode(self.class.collection, selector, hash)
    send("#{lock_field_name}=", new_version)
    result["updatedExisting"] && !result["err"]
  end

  # ActiveRecord::Locking::Optimistic::ClassMethods を参考に実装しています
  # https://github.com/rails/rails/blob/master/activerecord/lib/active_record/locking/optimistic.rb
  module ClassMethods
    DEFAULT_LOCKING_FIELD = 'lock_version'.freeze

    # Set the field to use for optimistic locking. Defaults to +lock_version+.
    def set_locking_field(value = nil)
      # 後者のlocking_fieldメソッドを上書きします。
      self.instance_eval("def locking_field; #{value.inspect}; end")
      value
    end

    # The version field used for optimistic locking. Defaults to +lock_version+.
    def locking_field
      reset_locking_field
    end

    # Reset the field used for optimistic locking back to the +lock_version+ default.
    def reset_locking_field
      set_locking_field DEFAULT_LOCKING_FIELD
    end
  end

end
