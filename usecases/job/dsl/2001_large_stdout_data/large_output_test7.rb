# -*- coding: utf-8 -*-
# ファイルへ改行なしで500KBを11行出力します。
jobnet("large_output_test7", "7_ファイルへ改行なしで500KBを10行出力", :instance_name => "i-centos", :credential_name => "i-centos_credential") do
  auto_sequence
  (1..5).each do |idx|
    job("job#{idx}", "~/large_output ~/long_line.log print 0123456789 50000")
  end
  job("job6", "~/large_output ~/long_line.log print 0123456789 49999 ERRORERROR")
  (7..11).each do |idx|
    job("job#{idx}", "~/large_output ~/long_line.log print 0123456789 50000")
  end
end
