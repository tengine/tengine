# -*- coding: utf-8 -*-

require 'tengine/core'

driver :driver20 do

  # イベントが発生したら:propertiesを指定してイベントを発火する
  on:event20_1 do
    puts "handler20_1"
    fire(:event20_2, :properties => {:foo => 'bar', :baz => 1})
  end

  on:event20_2 do
    puts event[:foo].inspect
    puts event[:baz].inspect
    puts event.properties.inspect
  end

end
