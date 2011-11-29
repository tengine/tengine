# encoding: utf-8

# 前提 /^以下のCredentialsが登録されている$/ do |credentials|
#   Given %{the following credentials:}, credentials
# end

もし /^"Credential一覧画面"で(\d+)番目のCredentialを削除する$/ do |pos|
  visit credentials_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "削除"
  end
end

ならば /^以下のCredentialsの一覧が表示されること$/ do |expected_table|
  Then %{I should see the following credentials:}, expected_table
end
