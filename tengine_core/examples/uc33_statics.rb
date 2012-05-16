# -*- coding: utf-8 -*-
require 'tengine/core'

STATIC1 = "outside of driver"

driver :driver33 do

  STATIC2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts STATIC1 # => outside of driver

  # イベントに対応する処理の実行する
  on:event33 do
    puts STATIC1 # => outside of driver
    puts STATIC2 # => outside of handler
  end

end
