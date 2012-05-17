# -*- coding: utf-8 -*-
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

# 
# Local Variables:
# mode: ruby
# coding: utf-8-unix
# End:
