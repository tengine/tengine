# -*- coding: utf-8 -*-
require 'tengine/core'

# Tengine::Core::Driveableモジュールによるドライバ定義でクラス変数を使用する例。

@@cvar1 = "outside of driver"

class Driver32
  include Tengine::Core::Driveable

  @@cvar2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts @@cvar1.inspect # => outside of driver

  on:event32
  def puts_class_variables
    puts "#{__FILE__}##{__LINE__}"
    puts @@cvar1.inspect # => outside of driver
    puts @@cvar2.inspect # => outside of handler
  end

end
