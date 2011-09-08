# see http://www.ruzee.com/blog/2006/11/redirecting-stdout-to-logger-with-ruby-on-rails
class Tengine::Core::IoToLogger
  def initialize(logger, method_to_write = :info)
    @logger = logger
    @method_to_write = method_to_write
  end
  def puts(str)
    @logger.send(@method_to_write, str)
  end
  def write(str)
    @logger.send(@method_to_write, str)
  end
end
