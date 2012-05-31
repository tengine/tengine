# -*- coding: utf-8 -*-
require 'tengine/core'

# driverメソッドによるドライバ定義で定数を使用する例。

STATIC1 = "outside of driver"

driver :driver33 do

  STATIC2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts STATIC1 # => outside of driver

  on:event33 do
    puts "#{__FILE__}##{__LINE__}"
    puts STATIC1 # => outside of driver
    puts STATIC2 # => outside of handler
  end

end
