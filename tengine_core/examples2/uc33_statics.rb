# -*- coding: utf-8 -*-
require 'tengine/core'

# Tengine::Core::Driveableモジュールによるドライバ定義で定数を使用する例。

STATIC1 = "outside of driver"

class Driver33
  include Tengine::Core::Driveable

  STATIC2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts STATIC1 # => outside of driver

  # イベントに対応する処理の実行する
  on:event33
  def puts_statics
    puts "#{__FILE__}##{__LINE__}"
    puts STATIC1 # => outside of driver
    puts STATIC2 # => outside of handler
  end

end
