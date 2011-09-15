# -*- coding: utf-8 -*-
require 'tengine/core'

driver :kill_event do

  # イベントに対応する処理の実行する
  on:kill_event do
    puts "kill_event"
    pid = $$
    `echo ${pid} > tmp/kill_me_process`
sleep 600
#    puts "kill event pid : #{pid}"
#    `kill -9 #{pid}`
#    exit(1)
  end

end
