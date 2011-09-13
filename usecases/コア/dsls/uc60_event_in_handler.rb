# -*- coding: utf-8 -*-
require 'tengine/core'

# ハンドラ内では event メソッドを使って受け取ったイベントを取得する事が可能。
# イベントの属性については、Tengine::Core::Event を参照

driver :driver60 do
  on:event60 do
    [:event_type_name, :key, :source_name, :occurred_at,
      :level, :confirmed, :sender_name, :properties,].each do |attr_name|
      puts "#{attr_name}: #{event.send(attr_name)}"
    end
  end
end
