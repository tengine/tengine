# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver99 do

  # イベントが発生したら新たなイベントを発火する
  on:event99_1 do
    puts "#{event.key}:handler99_1"
    system("rabbitmqctl stop > /dev/null")
    begin
      fire(:event99_2)
    rescue
     puts "send event failure: cant's connect to queue server."
  end

  on:event99_2 do
    puts "#{event.key}:handler99_2"
  end

end
