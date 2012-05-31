# -*- coding: utf-8 -*-
require 'tengine/core'

# driverメソッドによるドライバ定義でクラス変数を使用する例。

@@cvar1 = "outside of driver"

driver :driver32 do

  @@cvar2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts @@cvar1.inspect # => outside of driver

  on:event32 do
  puts "#{__FILE__}##{__LINE__}"
    puts @@cvar1.inspect # => outside of driver
    puts @@cvar2.inspect # => outside of handler
  end

end
