# -*- coding: utf-8 -*-
# 標準出力で 3774873 byte 出力します。
# 
# 3774874 byteの内訳は 
# ("0123456789ABCDE" (15byte) + putsによる改行(1byte) => 16 byte) * 235929 + ("01234567" (8byte) + putsによる改行(1byte) => 9 byte)
# 16 * 235929 + 9 => 3774873
#
jobnet("large_output_test2", "2_標準出力のサイズだけで上限を超えない", :instance_name => "i-centos", :credential_name => "i-centos_credential") do 
  job("job1", "~/large_output stdout puts 0123456789ABCDE 235929 01234567")
end
