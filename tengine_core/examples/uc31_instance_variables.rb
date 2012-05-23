# -*- coding: utf-8 -*-
require 'tengine/core'

# driverメソッドによるドライバ定義でインスタンス変数を使用する例。
#
# driverメソッドでは内部で Tengine::Core::Driveableモジュールをincludeした
# クラスを定義します。そのためインスタンス変数のスコープはクラスのスコープと同じです。
#
# 以下の例ではおかしく見えるかもしれませんが、Tengine::Core::Driveableモジュールを
# 使った定義をみれば納得して頂けると思います。
# https://github.com/tengine/tengine/blob/develop/tengine_core/examples2/uc31_instance_variables.rb

@ivar1 = "outside of driver"

driver :driver31 do

  @ivar2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts @ivar1.inspect # => nil

  def initialize
    @ivar3 = "inside of initialize"
    puts "#{__FILE__}##{__LINE__}"
    puts @ivar1.inspect # => nil
    puts @ivar2.inspect # => nil
  end

  on:event31 do
    puts "#{__FILE__}##{__LINE__}"
    puts @ivar1.inspect # => nil
    puts @ivar2.inspect # => nil
    puts @ivar3.inspect # => inside of initialize
  end

end
