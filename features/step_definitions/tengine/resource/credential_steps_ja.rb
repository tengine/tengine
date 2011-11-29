# encoding: utf-8

前提 /^以下の認証情報が登録されている$/ do |credentials|
  Given %{the following credentials:}, credentials
end

前提 /^認証情報が登録されていない$/ do
    Tengine::Resource::Credential.delete_all
end

前提 /^(\d+)件の認証情報が登録されている$/ do |count|
  count.to_i.times do |i|
    index = i+1
    hash = {
      :name => "name_#{sprintf("%03d", index)}",
      :description => "説明_#{sprintf("%03d", index)}",
      :auth_type_key => :ssh_password,
      :auth_values => {:username => "username", :password => "password"},
    }
    if index.even?
      hash.merge!({
        :auth_type_key => :ssh_public_key,
        :auth_values => {:username => "username", :passphrase => "passphrase", :private_keys => "private_keys"}
      })
    end
    Tengine::Resource::Credential.create!(hash)
  end
end

もし /^"Credential一覧画面"で(\d+)番目のCredentialを削除する$/ do |pos|
  visit credentials_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "削除"
  end
end

ならば /^以下の認証情報の一覧が表示されること$/ do |expected_table|
  expected_table.diff!(tableish('table.TableBase tr', 'td,th'))
end

ならば /^(\d+)件の認証情報が登録されていること$/ do |count|
  Tengine::Resource::Credential.count.should == count.to_i
end
