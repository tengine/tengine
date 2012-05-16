# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver08 do

  # イベントAとイベントBが発生したら処理を実行する
  on :event08_a & :event08_b do
    puts "handler08"
  end

  # イベントAとイベントBが発生したら処理を実行する
  on :event08_c do
    puts "clear session"
    session.clear!
  end

end
