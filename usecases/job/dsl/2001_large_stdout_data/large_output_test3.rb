# -*- coding: utf-8 -*-

require 'tengine_job'

# 標準エラー出力で 3774873 byte 出力します。
# 
# 3774874 byteの内訳は 
# ("0123456789ABCDE" (15byte) + putsによる改行(1byte) => 16 byte) * 235929 + ("01234567" (8byte) + putsによる改行(1byte) => 9 byte)
# 16 * 235929 + 9 => 3774873
#
jobnet("large_output_test3", "3_標準エラー出力のサイズだけで上限を超えない", :instance_name => "test_server1", :credential_name => "test_credential1") do 
  job("job1", "~/large_output stderr puts 0123456789ABCDE 235929 01234567")
end
