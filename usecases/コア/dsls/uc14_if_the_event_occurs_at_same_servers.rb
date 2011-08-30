# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver14 do

  # 同じイベントの発生源から イベントa と イベントb が発生した場合のみ処理を実行する
  on (:event14_a & :event14_b).at_same_source do
    puts "handler14"
  end

end
