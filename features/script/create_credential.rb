# -*- coding: utf-8 -*-
#
# rails runnerスクリプト
# 既存のcredentialを全て削除し、第一引数で指定された数だけ新規に作成、登録します。
#
def create_credential(count)
  count.times do |i|
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

Tengine::Resource::Credential.delete_all

create_credential ENV["CREATE_NUM"].to_i
