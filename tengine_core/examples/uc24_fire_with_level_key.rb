# -*- coding: utf-8 -*-

require 'tengine/core'

driver :driver24 do

  # イベントが発生したら:propertiesを指定してイベントを発火する
  on:event24 do
    puts "handler24"
    fire(:event24_0, :level_key => :debug)
  end

  on(:event24_0){ puts "handler24_0"; fire(:event24_1, :level_key => :info) }
  on(:event24_1){ puts "handler24_1"; fire(:event24_2, :level_key => :warn) }
  on(:event24_2){ puts "handler24_2"; fire(:event24_3, :level_key => :error) }
  on(:event24_3){ puts "handler24_3"; fire(:event24_4, :level_key => :fatal) }
  on(:event24_4){ puts "handler24_4"; fire(:event24_5, :level_key => :urgent) } # [ArgumentError] Invalid level_key :urgent. It must be one of [:gr_heartbeat, :debug, :info, :warn, :error, :fatal]
  on(:event24_5){ puts "handler24_5" }
end
