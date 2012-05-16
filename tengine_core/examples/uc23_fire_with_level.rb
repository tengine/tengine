# -*- coding: utf-8 -*-

require 'tengine/core'

driver :driver23 do

  # イベントが発生したら:propertiesを指定してイベントを発火する
  on:event23 do
    puts "handler23"
    fire(:event23_1, :level => 1)
  end

  on(:event23_1){ puts "handler23_1"; fire(:event23_2, :level => 2) }
  on(:event23_2){ puts "handler23_2"; fire(:event23_3, :level => 3) }
  on(:event23_3){ puts "handler23_3"; fire(:event23_4, :level => 4) }
  on(:event23_4){ puts "handler23_4"; fire(:event23_5, :level => 5) }
  on(:event23_5){ puts "handler23_5"; fire(:event23_6, :level => 6) } # [ArgumentError] Invalid level 6. It must be one of [0, 1, 2, 3, 4, 5]
  on(:event23_6){ puts "handler23_6" }
end
