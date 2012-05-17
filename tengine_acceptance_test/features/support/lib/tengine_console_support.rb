# -*- coding: utf-8 -*-
class TengineConsoleSupport
  
  class << self

    def running?
      command = "ps axww |grep -v \"grep\" | grep -e \"ruby script/rails s \""
      puts "command:#{command}"
      system(command)
    end

  end
end
