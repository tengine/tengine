# -*- coding: utf-8 -*-
require 'tengine/core'

lvar1 = "outside of driver"

driver :driver30 do

  lvar2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts lvar1 # => outside of driver

  on:event30 do
    puts "#{__FILE__}##{__LINE__}"
    puts lvar1 # => outside of driver
    puts lvar2 # => outside of handler
  end

end
