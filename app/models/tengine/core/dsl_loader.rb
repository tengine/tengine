# -*- coding: utf-8 -*-
module Tengine::Core::DslLoader
  def evaluate
    dir_or_file_path = @config[:tengined_load_path]
    nil
    if Dir.exist?(dir_or_file_path)
      dir_path = dir_or_file_path
      file_paths = Dir["#{dir_path}/**/*.rb"].to_a
    elsif File.exist?(dir_or_file_path)
      dir_path = File.dirname(dir_or_file_path)
      file_paths = [dir_or_file_path]
    else
      # TODO 例外のクラスをどう作るのか要検討
      raise "Invalid tengined_load_path: #{dir_or_file_path}"
    end
    version_file_path = File.expand_path("VERSION", dir_path)
    File.open(version_file_path){|f| @__version__ = f.readline } if File.exist?(version_file_path) 
    @__version__ ||= Time.now.strftime("%Y%m%d%H%M%S")
#     $LOAD_PATH << dir_path
    file_paths.each{|f| self.instance_eval(File.read(f), f)}
  end

  def driver(name, options = {}, &block)
    driver = Tengine::Core::Driver.new((options || {}).update(
        :name => name,
        :version => @__version__
        ))
    @__driver__ = driver
    yield if block_given?
    driver.save!
    driver
  end

  def on(event_type_name, options = {}, &block)
    @__driver__.handlers.new(:event_type_names => [event_type_name.to_s])
  end
end
