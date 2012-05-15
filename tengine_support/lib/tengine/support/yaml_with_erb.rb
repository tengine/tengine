require 'tengine/support'

require 'yaml'
require 'erb'

module Tengine::Support::YamlWithErb

  ERB_EXTNAME = ".erb".freeze

  class << self
    def extended(klass)
      return if klass.respond_to?(:load_file_without_erb)
      klass.instance_eval do
        alias :load_file_without_erb :load_file

        def load_file(filepath)
          if File.extname(filepath) == ERB_EXTNAME
            load_file_with_erb(filepath)
          else
            load_file_without_erb(filepath)
          end
        end

      end
    end
  end

  def load_file_with_erb(filepath)
    erb = ERB.new(IO.read(filepath))
    erb.filename = filepath
    text = erb.result
    YAML.load(text)
  end
end

YAML.extend(Tengine::Support::YamlWithErb)
