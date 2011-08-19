# encoding: utf-8

# 前提 /^以下のドライバsが登録されている$/ do |drivers|
#   Given %{the following drivers:}, drivers
# end

もし /^"ドライバ一覧画面"で(\d+)番目のドライバを削除する$/ do |pos|
  When %{I delete the #{pos}th driver}
end

ならば /^以下のドライバsの一覧が表示されること$/ do |expected_table|
  Then %{I should see the following drivers:}, expected_table
end
