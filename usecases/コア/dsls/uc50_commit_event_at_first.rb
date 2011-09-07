# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントfoo50を受け取ったらDBに保存して、すぐにキューにACKを返す。
# 特に指定しない場合、カーネルはこの :at_first が指定されているように振る舞う。
Tengine.commit_event(:at_first, :foo50)

Tengine.driver :driver50 do

  on:event50 do
    puts "handler50"
  end

end
