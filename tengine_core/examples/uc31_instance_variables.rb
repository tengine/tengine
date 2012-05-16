# -*- coding: utf-8 -*-
require 'tengine/core'

ivar1 = "outside of driver"

driver :driver31 do

  ivar2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts ivar1 # => outside of driver

  # イベントに対応する処理の実行する
  on:event31 do
    puts "#{__FILE__}##{__LINE__}"
    puts ivar1 # => outside of driver
    puts ivar2 # => outside of handler
  end

end
