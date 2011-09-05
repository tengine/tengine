require 'active_support/hash_with_indifferent_access'

class Tengine::Core::Config
  def initialize(original)
    @hash = ActiveSupport::HashWithIndifferentAccess.new(original)
  end

  def [](key)
    @hash[key]
  end

  def dsl_dir_path
    unless @dsl_dir_path
      load_path = self[:tengined][:load_path]
      if Dir.exist?(load_path)
        @dsl_dir_path = load_path
      elsif File.exist?(load_path)
        @dsl_dir_path = File.dirname(load_path)
      else
        raise Tengine::Core::ConfigError, "file or directory doesn't exist. #{load_path}"
      end
    end
    @dsl_dir_path
  end

  def dsl_file_paths
    unless @dsl_file_paths
      @dsl_file_paths = Dir.glob("#{dsl_dir_path}/**/*.rb")
    end
    @dsl_file_paths
  end

  def dsl_version_path
    @dsl_version_path ||= File.expand_path("VERSION", dsl_dir_path)
  end

  def dsl_version
    File.exist?(dsl_version_path) ? File.read(dsl_version_path).strip : Time.now.strftime("%Y%m%d%H%M%S")
  end


end
