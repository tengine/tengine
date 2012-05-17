# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver97 do

  # イベントが発生したら新たなイベントを発火する
  on:event97_1 do
    puts "#{event.key}:handler97_1"
    system("rabbitmqctl stop > /dev/null")
    begin
      fire(:event97_2,{:retry_interval => 10,:retry_times => 2})
    rescue
     puts "send event failure: cant's connect to queue server."
  end

  on:event97_2 do
    puts "#{event.key}:handler97_2"
  end

end
