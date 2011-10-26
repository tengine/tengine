# -*- coding: utf-8 -*-

require 'tengine_job'

# 標準出力     で 1887436 byte
# 標準エラー出力で 1887437 byte
# 合計           3774873 byte 出力します。
# 
# 1887436 byteの内訳は 
# ("0123456789ABCDE" (15byte) + putsによる改行(1byte) => 16 byte) * 117964 + ("0123456789A" (11byte) + putsによる改行(1byte) => 12 byte)
# 16 * 117964 + 12 => 1887436  と
#
# 1887437 byteの内訳は 
# ("0123456789ABCDE" (15byte) + putsによる改行(1byte) => 16 byte) * 117964 + ("0123456789AB" (11byte) + putsによる改行(1byte) => 13 byte)
# 16 * 117964 + 13 => 1887437
#
jobnet("large_output_test1", "1_標準出力、標準エラー出力のサイズの合計が上限を超えない", :instance_name => "test_server1", :credential_name => "test_credential1") do 
  job("job1", "\"~/large_output stdout puts 0123456789ABCDE 117964 0123456789A && ~/large_output stderr puts 0123456789ABCDE 117964 0123456789AB\"") 
end
