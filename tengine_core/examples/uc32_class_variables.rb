# -*- coding: utf-8 -*-
require 'tengine/core'

cvar1 = "outside of driver"

driver :driver32 do

  cvar2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts cvar1 # => outside of driver

  # イベントに対応する処理の実行する
  on:event32 do
    puts cvar1 # => outside of driver
    puts cvar2 # => outside of handler
  end

end
