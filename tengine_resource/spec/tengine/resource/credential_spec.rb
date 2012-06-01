# -*- coding: utf-8 -*-
require 'spec_helper'
require 'net/ssh'

describe Tengine::Resource::Credential do

  valid_attributes1 = {
    :name => "ssh-private_key",
    :auth_type_key => :ssh_password,
    :auth_values => {
      :username => 'user1',
      :password => "password1",
    }
  }.freeze

  context "name、auth_type_cd、auth_values は必須" do
    it "正常系" do
      Tengine::Resource::Credential.delete_all
      credential1 = Tengine::Resource::Credential.new(valid_attributes1)
      credential1.valid?.should == true
    end

    [:name, :auth_type_key].each do |key|
      it "#{key}なし" do
        attrs = valid_attributes1.dup
        attrs.delete(key)
        credential1 = Tengine::Resource::Credential.new(attrs)
        credential1.valid?.should == false
      end
    end

  end

  context "nameはユニーク" do
    before do
      Tengine::Resource::Credential.delete_all
      @credential1 = Tengine::Resource::Credential.create!(valid_attributes1)
      @original_locale, I18n.locale = I18n.locale, :en
    end
    after do
      I18n.locale = @original_locale
    end

    it "同じ名前で登録されているものが存在する場合エラー" do
      expect{
        @credential1 = Tengine::Resource::Credential.create!(valid_attributes1)
      }.to raise_error(Mongoid::Errors::Validations, "Validation failed - Name is already taken.")
    end
  end

  context "nameはベース名として定義される文字列です" do
    it "スラッシュ'/’はリソース識別子で使われるのでnameには使用できません" do
      server1 = Tengine::Resource::Credential.new(:name => "foo/bar")
      server1.valid?.should == false
      server1.errors[:name].should == [Tengine::Core::Validation::BASE_NAME.message]
    end

    it "コロン':'はリソース識別子で使われるのでnameには使用できません" do
      server1 = Tengine::Resource::Credential.new(:name => "foo:bar")
      server1.valid?.should == false
      server1.errors[:name].should == [Tengine::Core::Validation::BASE_NAME.message]
    end
  end


  context "nameで検索" do
    before do
      Tengine::Resource::Credential.delete_all
      @credential = Tengine::Resource::Credential.create!(valid_attributes1)
    end

    context "見つかる場合" do
      it "name で検索できるか" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::Credential.first(:conditions => {:name => "ssh-private_key"})
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @credential.id
      end

      it "find_by_name" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::Credential.find_by_name("ssh-private_key")
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @credential.id
      end

      it "find_by_name!" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::Credential.find_by_name!("ssh-private_key")
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @credential.id
      end
    end

    context "見つからない場合" do
      it "find_by_name" do
        found_credential = Tengine::Resource::Credential.find_by_name("unexist_name").should == nil
      end

      it "find_by_name!" do
        lambda{
          found_credential = Tengine::Resource::Credential.find_by_name!("unexist_name")
        }.should raise_error(Tengine::Core::FindByName::Error)
      end
    end

  end


  describe :secure_auth_values, "外部に見せても良いように見せちゃ拙い情報は取り除く" do
    it :ssh_password do
      credential = Tengine::Resource::Credential.new(:name => "ssh-pass1",
        :auth_type_key => :ssh_password,
        :auth_values => {:username => 'goku', :password => "password1"})
      credential.secure_auth_values.should == {'username' => 'goku'}
    end

    it :ssh_public_key do
      credential = Tengine::Resource::Credential.new(:name => "ssh-pk1",
        :auth_type_key => :ssh_public_key,
        :auth_values => {:username => 'goku', :private_keys => "pkxxxxx", :passphrase => "abc"})
      credential.secure_auth_values.should == {'username' => 'goku'}
    end

  end

  describe :auth_values_validation do
    context "valid" do

      describe :ssh_password do
        it "キーがSymbol" do
          Tengine::Resource::Credential.new(:name => "ssh-pass1",
            :auth_type_key => :ssh_password,
            :auth_values => {:username => 'goku', :password => "password1"}).valid?.should == true
        end
        it "キーが文字列" do
          Tengine::Resource::Credential.new(:name => "ssh-pass1",
            :auth_type_key => :ssh_password,
            :auth_values => {'username' => 'goku', 'password' => "password1"}).valid?.should == true
        end
      end

      describe :ssh_public_key do
        it "キーがSymbol" do
          Tengine::Resource::Credential.new(:name => "ssh-pk1",
            :auth_type_key => :ssh_public_key,
            :auth_values => {:username => 'goku', :private_keys => "pkxxxxx"}).valid?.should == true
        end
        it "キーが文字列" do
          Tengine::Resource::Credential.new(:name => "ssh-pk1",
            :auth_type_key => :ssh_public_key,
            :auth_values => {'username' => 'goku', 'private_keys' => "pkxxxxx"}).valid?.should == true
        end
      end

    end

    context "invalid" do
      describe :ssh_password do
        it ":usernameが空文字列" do
          Tengine::Resource::Credential.new(:name => "ssh-pass1",
            :auth_type_key => :ssh_password,
            :auth_values => {:username => '', :password => "password1"}).valid?.should == false
        end
        it "passwordなし" do
          Tengine::Resource::Credential.new(:name => "ssh-pass1",
            :auth_type_key => :ssh_password,
            :auth_values => {'username' => 'goku'}).valid?.should == false
        end
      end

      describe :ssh_public_key do
        it ":usernameなし" do
          credential1 = Tengine::Resource::Credential.new(:name => "ssh-pk1",
            :auth_type_key => :ssh_public_key,
            :auth_values => {:private_keys => "pkxxxxx"})
          credential1.valid?.should == false
        end
        it "private_keyが空文字列" do
          credential1 = Tengine::Resource::Credential.new(:name => "ssh-pk1",
            :auth_type_key => :ssh_public_key,
            :auth_values => {'username' => 'goku', 'private_keys' => ""})
          credential1.valid?.should == false
        end
      end

    end
  end
end
