# -*- coding: utf-8 -*-
require 'tengine/core'

# driverメソッドによるドライバ定義でローカル変数を使用する例。
#
# Rubyの通常のブロックと同じように、ブロックの外で定義されたローカル変数は
# ブロック内からアクセス可能です。

# lvar1の定義
lvar1 = "outside of driver"

driver :driver30 do

  # lvar2の定義
  lvar2 = "outside of handler"
  puts "#{__FILE__}##{__LINE__}"
  # lvar1へのアクセス
  puts lvar1 # => outside of driver

  on:event30 do
    puts "#{__FILE__}##{__LINE__}"
    # lvar1へのアクセス
    puts lvar1 # => outside of driver
    # lvar2へのアクセス
    puts lvar2 # => outside of handler
  end

end
