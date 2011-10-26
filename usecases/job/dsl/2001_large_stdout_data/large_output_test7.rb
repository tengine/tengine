# -*- coding: utf-8 -*-

require 'tengine_job'

# ファイルへ改行なしで500KBを11行出力します。
jobnet("large_output_test7", "7_ファイルへ改行なしで500KBを10行出力", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  (1..5).each do |idx|
    job("job#{idx}", "~/large_output ~/long_line.log print 0123456789 50000")
  end
  job("job6", "~/large_output ~/long_line.log print 0123456789 49999 ERRORERROR")
  (7..11).each do |idx|
    job("job#{idx}", "~/large_output ~/long_line.log print 0123456789 50000")
  end
end
