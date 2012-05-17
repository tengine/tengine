# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver98 do

  # イベントが発生したら新たなイベントを発火する
  on:event98_1 do
    puts "#{event.key}:handler98_1"
    system("rabbitmqctl stop > /dev/null")
    begin
      @try_count = 0
      callback = lambda{|failure_event| 
         @try_count += 1
         puts "try:#{@try_count},failure event:#{failure_event}"
      }
      fire(:event98_2,{:retry_interval => 10,:retry_times => 2,:event_send_failure_callback => callback})
    rescue
     puts "send event failure: cant's connect to queue server."
  end

  on:event98_2 do
    puts "#{event.key}:handler98_2"
  end

end
