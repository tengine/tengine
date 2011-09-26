# -*- coding: utf-8 -*-
require 'tengine/core'

# 強制的にバグを発生させるためにTengine::Core::Kernel#startを上書きしている
class Tengine::Core::Kernel
  def start(&block)
    nil.each
  end
end

driver :driver95 do

  # イベントに対応する処理の実行する
  on:event95 do
    puts "#{event.key}:handler95"
  end

end
