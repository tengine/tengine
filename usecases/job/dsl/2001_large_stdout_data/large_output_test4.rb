# -*- coding: utf-8 -*-
# 標準出力     で 1887437 byte
# 標準エラー出力で 1887437 byte
# 合計           3774874 byte 出力します。
# 
# 1887437 byteの内訳は 
# ("0123456789ABCDE" (15byte) + putsによる改行(1byte) => 16 byte) * 117964 + ("0123456789AB" (11byte) + putsによる改行(1byte) => 13 byte)
# 16 * 117964 + 13 => 1887437
#
jobnet("large_output_test4", "4_標準出力、標準エラー出力のサイズの合計が上限を超える", :instance_name => "i-centos", :credential_name => "i-centos_credential") do 
  job("job1", "\"~/large_output stdout puts 0123456789ABCDE 117964 0123456789AB && ~/large_output stderr puts 0123456789ABCDE 117964 0123456789AB\"") 
end
