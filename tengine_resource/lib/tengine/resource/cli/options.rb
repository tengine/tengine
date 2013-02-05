require 'tengine/resource/cli'
require 'active_support/core_ext/hash/keys'

module Tengine::Resource::CLI::Options
  def merge_options(args, options)
    opts = args.last.is_a?(Hash) ? args.pop : {}
    opts = opts.symbolize_keys
    opts.merge(options.to_hash.symbolize_keys)
  end
end
