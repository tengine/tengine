# -*- coding: utf-8 -*-

require 'tengine_job'

# 標準エラー出力で 3774874 byte 出力します。
# 
# 3774874 byteの内訳は 
# ("0123456789ABCDE" (15byte) + putsによる改行(1byte) => 16 byte) * 235929 + ("012345678" (9byte) + putsによる改行(1byte) => 10 byte)
# 16 * 235929 + 10 => 3774874
#
jobnet("large_output_test6", "6_標準エラー出力のサイズだけで上限を超える", :instance_name => "test_server1", :credential_name => "test_credential1") do 
  job("job1", "~/large_output stderr puts 0123456789ABCDE 235929 012345678")
end
