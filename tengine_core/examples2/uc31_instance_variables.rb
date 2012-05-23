# -*- coding: utf-8 -*-
require 'tengine/core'

# Tengine::Core::Driveableモジュールによるドライバ定義でインスタンス変数を使用する例。
#
# @ivar1
# クラスの外で定義したインスタンス変数なので、クラス内のどこからも参照できません。
#
# @ivar2
# クラスのコンテキスト中で定義したインスタンス変数なので、Driverクラスオブジェクト自身のインスタンス変数であり、
# Driverのインスタンスのインスタンス変数ではないので、メソッドから参照できません。
#
# @ivar3
# initializeで定義したインスタンス変数は、Driverクラスオブジェクト自身のインスタンス変数ではなく、
# Driverのインスタンスのインスタンス変数なので、メソッドから参照できます。
#
# ドライバ外に定義したデータをドライバ内、イベントハンドラ内で使用したい場合には
# 定数やクラス変数の利用を検討してください。
# https://github.com/tengine/tengine/blob/develop/tengine_core/examples2/uc33_statics.rb
# https://github.com/tengine/tengine/blob/develop/tengine_core/examples2/uc32_class_variables.rb

@ivar1 = "outside of driver"

class Driver31
  include Tengine::Core::Driveable

  @ivar2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  puts @ivar1.inspect # => nil

  def initialize
    @ivar3 = "inside of initialize"
    puts "#{__FILE__}##{__LINE__}"
    puts @ivar1.inspect # => nil
    puts @ivar2.inspect # => nil
  end

  on:event31
  def puts_instance_variables
    puts "#{__FILE__}##{__LINE__}"
    puts @ivar1.inspect # => nil
    puts @ivar2.inspect # => nil
    puts @ivar3.inspect # => inside of initialize
  end

end
