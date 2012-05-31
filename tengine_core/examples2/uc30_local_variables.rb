# -*- coding: utf-8 -*-
require 'tengine/core'

# Tengine::Core::Driveableモジュールによるドライバ定義でローカル変数を使用する例。
#
# ドライバはRubyのクラスとして定義されるので、スコープの異なるローカル変数を
# 参照する事はできません。
#
# ドライバ外に定義したデータをドライバ内、イベントハンドラ内で使用したい場合には
# 定数やクラス変数の利用を検討してください。
# https://github.com/tengine/tengine/blob/develop/tengine_core/examples2/uc33_statics.rb
# https://github.com/tengine/tengine/blob/develop/tengine_core/examples2/uc32_class_variables.rb
#
# ローカル変数を用いてデータを共有したい場合は、driverメソッドによるドライバ定義を検討してください。
# https://github.com/tengine/tengine/blob/develop/tengine_core/examples/uc30_local_variables.rb

# lvar1の定義
lvar1 = "outside of driver"

class Driver30
  include Tengine::Core::Driveable

  # lvar2の定義
  lvar2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"

  begin
    # lvar1へのアクセス
    puts lvar1 # => raise NameError: undefined local variable or method `lvar1'
    raise "some thing wrong"
  rescue NameError => e
      puts "#{e.class} #{e.message}"
  end

  on:event30
  def puts_local_variables
    puts "#{__FILE__}##{__LINE__}"
    begin
      # lvar1へのアクセス
      puts lvar1 # => raise NameError: undefined local variable or method `lvar1'
      raise "some thing wrong"
    rescue NameError => e
      puts "#{e.class} #{e.message}"
    end

    begin
      # lvar2へのアクセス
      puts lvar2 # => raise NameError: undefined local variable or method `lvar2'
      raise "some thing wrong"
    rescue NameError => e
      puts "#{e.class} #{e.message}"
    end
  end

end
