# -*- coding: utf-8 -*-

require 'tengine/core'

driver :driver22 do

  # イベントが発生したら:source_nameを指定してイベントを発火する
  on:event22_1 do
    puts "handler22_1"
    fire(:event22_2, :source_name => "test_source01")
  end

  on:event22_2 do
    puts event.source_name # test_source01
  end

end
