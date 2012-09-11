require 'tengine/core'

module Tengine::Core::SafeUpdatable
  extend ActiveSupport::Concern

  def update_in_safe_mode(collection, selector, document, opts=nil)
    options = { :upsert => false, :multiple => false }
    options.update(opts) if opts

    options = options.merge({ :safe => safemode(collection, 10240) })

    max_retries = 60
    retries = 0
    begin
      # Return a Hash containing the last error object if running safe mode.
      # Otherwise, returns true
      self.class.with(options).where(selector).update(document)
    rescue Moped::Errors::ConnectionFailure, Moped::Errors::OperationFailure => ex
      case ex when Moped::Errors::OperationFailure then
        raise ex unless ex.message =~ /wtimeout/
      end
      retries += 1
      raise ex if retries > max_retries
      Tengine.logger.debug "retrying due to mongodb error #{ex.inspect}, #{retries} times."
      sleep 0.5
      retry
    end
  end

  def safemode(collection, wtimeout=61440)
    collection.database.session.cluster.with_primary do |n|
      return n.peers.size.zero? ||
        { :w => "majority", :wtimeout => wtimeout, }
    end
  end
  module_function :safemode
end
