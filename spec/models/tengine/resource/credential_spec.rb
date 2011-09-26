# -*- coding: utf-8 -*-
require 'spec_helper'

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

  it "name で検索できるか" do
    Tengine::Resource::Credential.delete_all
    credential = Tengine::Resource::Credential.create!(valid_attributes1)
    found_credential = nil
    lambda{
      found_credential = Tengine::Resource::Credential.first(:conditions => {:name => "ssh-private_key"})
    }.should_not raise_error
    found_credential.should_not be_nil
    found_credential.id.should == credential.id
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

    it :ec2_access_key do
      credential = Tengine::Resource::Credential.create!(:name => "ec2-access-key1",
        :auth_type_key => :ec2_access_key,
        :auth_values => {:access_key => '12345', :secret_access_key => "abcdef"})
      credential.secure_auth_values.should == {'access_key' => '12345', 'default_region' => 'us-east-1'}
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

      describe :ec2_access_key do
        it "キーがSymbol" do
          Tengine::Resource::Credential.new(:name => "ec2-access-key1",
            :auth_type_key => :ec2_access_key,
            :auth_values => {:access_key => '12345', :secret_access_key => "abcdef"}).valid?.should == true
        end
        it "キーが文字列" do
          Tengine::Resource::Credential.new(:name => "ec2-access-key1",
            :auth_type_key => :ec2_access_key,
            :auth_values => {'access_key' => '12345', 'secret_access_key' => "abcdef"}).valid?.should == true
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

      describe :ec2_access_key do
        it "access_keyが空文字列" do
          credential1 = Tengine::Resource::Credential.new(:name => "ec2-access-key1",
            :auth_type_key => :ec2_access_key,
            :auth_values => {:access_key => '', :secret_access_key => "abcdef"})
          credential1.valid?.should == false
        end
        it "secret_access_keyがnil" do
          credential1 = Tengine::Resource::Credential.new(:name => "ec2-access-key1",
            :auth_type_key => :ec2_access_key,
            :auth_values => {'access_key' => '12345', 'secret_access_key' => nil})
          credential1.valid?.should == false
        end
      end
    end
  end

  describe :connect do
    describe :ssh_password do
      it "正常に接続" do
        credential = Tengine::Resource::Credential.new(:name => "ssh-pass1", :auth_type_key => :ssh_password,
          :auth_values => {:username => 'goku', :password => "password1"})
        mock_ssh = mock(:ssh)
        Net::SSH.should_receive(:start).
          with("host1", "goku", :password => "password1").
          and_yield(mock_ssh)
        block_invoked = false
        credential.connect("host1") do |ssh|
          block_invoked = true
        end
        block_invoked.should be_true
      end
    end

    describe :ssh_public_key do
      it "正常に接続" do
        credential = Tengine::Resource::Credential.new(:name => "ssh-pass1", :auth_type_key => :ssh_public_key,
          :auth_values => {:username => 'goku', :private_keys => "xxxxxx", :passphrase => "PPPPP"})
        mock_ssh = mock(:ssh)
        Net::SSH.should_receive(:start).
          with("host1", "goku",
          :keys => [File.expand_path("tmp/pks/pk-#{credential.id}-0", Rails.root)],
          :passphrase => "PPPPP").
          and_yield(mock_ssh)
        block_invoked = false
        credential.connect("host1") do |ssh|
          block_invoked = true
        end
        block_invoked.should be_true
      end
    end

    describe :ec2_access_key do
      it "正常に接続" do
        backup = ENV['EC2_DUMMY']
        ENV['EC2_DUMMY'] = nil
        begin
          credential = Tengine::Resource::Credential.new(:name => "ec2-access-keys", :auth_type_key => :ec2_access_key,
            :auth_values => {:access_key => 'aaaa', :secret_access_key => "ssss"})
          block_invoked  = false
          credential.connect do |ec2|
            block_invoked = true
            ec2.class.should == RightAws::Ec2
          end
          block_invoked.should be_true
        ensure
          ENV['EC2_DUMMY'] = backup
        end
      end

      it "ダミー接続" do
        backup = ENV['EC2_DUMMY']
        ENV['EC2_DUMMY'] = 'true'
        begin
          credential = Tengine::Resource::Credential.new(:name => "ec2-access-keys", :auth_type_key => :ec2_access_key,
            :auth_values => {:access_key => 'aaaa', :secret_access_key => "ssss"})
          block_invoked  = false
          credential.connect do |ec2|
            block_invoked = true
            ec2.class.should_not == RightAws::Ec2
            ec2.class.should == Tengine::Resource::Credential::Ec2::Dummy
          end
          block_invoked.should be_true
        ensure
          ENV['EC2_DUMMY'] = backup
        end
      end

    end
  end

  describe ":for_launch?, :launch_options インスタンス起動用のcredentialかどうかと起動用オプション" do
    it :ssh_password do
      credential = Tengine::Resource::Credential.new(:name => "ssh-pass1",
        :auth_type_key => :ssh_password,
        :auth_values => {:username => 'goku', :password => "password1"})
      credential.for_launch?.should == false
      lambda{
        credential.launch_options
      }.should raise_error(ArgumentError)
    end

    it :ssh_public_key do
      credential = Tengine::Resource::Credential.new(:name => "ssh-pk1",
        :auth_type_key => :ssh_public_key,
        :auth_values => {:username => 'goku', :private_keys => "pkxxxxx", :passphrase => "abc"})
      credential.for_launch?.should == false
      lambda{
        credential.launch_options
      }.should raise_error(ArgumentError)
    end

    describe :ec2_access_key do

      before do
        Tengine::Resource::VirtualServerImage.delete_all
      end

      it "launch_optionsに引数なし" do
        # credential = Tengine::Resource::Credential.create!(:name => "ec2-access-key1",
        #   :auth_type_key => :ec2_access_key,
        #   :auth_values => {:access_key => 'ACCESS_KEY1', :secret_access_key => "SECRET_12345", :default_region => "us-west-1"})
        #   # :auth_values => {
        #   #   :access_key => `cat ~/.ec2/access_key`.chomp,
        #   #   :secret_access_key => `cat ~/.ec2/secret_access_key`.chomp,
        #   #   :default_region => "us-west-1"
        #   # })
        credential = Tengine::Resource::Credential.new(:name => "ec2-access-key1",
          :auth_type_key => :ec2_access_key,
          :auth_values => {:access_key => 'ACCESS_KEY1', :secret_access_key => "SECRET_ACCESS_KEY1", :default_region => "us-west-1"})
        credential.for_launch?.should == true

        images = setup_ec2_images
        RightAws::Ec2.should_receive(:new).
          with('ACCESS_KEY1', "SECRET_ACCESS_KEY1", :region => "us-west-1", :logger => Rails.logger).
          and_return(setup_ec2_stub(images))
        credential.launch_options.should == {
          "current_region" => "us-west-1",
          "regions" => [
            { "name" => "eu-west-1", "caption" => "EU West" },
            { "name" => "us-east-1", "caption" => "US East" },
            { "name" => "us-west-1", "caption" => "US West" },
            { "name" => "ap-southeast-1", "caption" => "Asia Pacific" }
          ],
          'availability_zones' => ["us-west-1a", "us-west-1b"].sort,
          'key_pairs' => ["goku", "dev", "default"],
          'security_groups' => ["default", "hadoop-dev", "ruby-dev"],
          'images' => [
            {'id' => images[0].id, 'name' => "ami-10101000", 'aws_architecture' => 'i386'  , 'aws_arch_root_dev' => 'i386_instance-store', 'caption' => "MySQL server"},
            {'id' => images[1].id, 'name' => "ami-10101000", 'aws_architecture' => 'i386'  , 'aws_arch_root_dev' => 'i386_instance-store', 'caption' => "Rails App Server"},
            {'id' => images[2].id, 'name' => "ami-10102000", 'aws_architecture' => 'x86_64', 'aws_arch_root_dev' => 'x86_64_ebs'         , 'caption' => "Nginx Server"},
          ],
          'instance_types' => {
            'i386_instance-store' => [
              { "value" => "m1.small"  , "caption" => "Small" },
              { "value" => "c1.medium" , "caption" => "High-CPU Medium" },
            ],
            'i386_ebs' => [
              { "value" => "t1.micro"  , "caption" => "Micro" }, # AMIのRootDeviceがebsの場合だけ
              { "value" => "m1.small"  , "caption" => "Small" },
              { "value" => "c1.medium" , "caption" => "High-CPU Medium" },
            ],
            'x86_64_instance-store' => [
              { "value" => "m1.large"  , "caption" => "Large" },
              { "value" => "m1.xlarge" , "caption" => "Extra Large" },
              { "value" => "m2.xlarge" , "caption" => "High-Memory Extra Large" },
              { "value" => "m2.2xlarge", "caption" => "High-Memory Double Extra Large" },
              { "value" => "m2.4xlarge", "caption" => "High-Memory Quadruple Extra Large" },
              { "value" => "c1.xlarge" , "caption" => "High-CPU Extra Large" },
            ],
            'x86_64_ebs' => [
              { "value" => "t1.micro"  , "caption" => "Micro" }, # AMIのRootDeviceがebsの場合だけ
              { "value" => "m1.large"  , "caption" => "Large" },
              { "value" => "m1.xlarge" , "caption" => "Extra Large" },
              { "value" => "m2.xlarge" , "caption" => "High-Memory Extra Large" },
              { "value" => "m2.2xlarge", "caption" => "High-Memory Double Extra Large" },
              { "value" => "m2.4xlarge", "caption" => "High-Memory Quadruple Extra Large" },
              { "value" => "c1.xlarge" , "caption" => "High-CPU Extra Large" },
            ],
          },
          'kernel_ids' => {
            'i386'   => ["aki-00000000", "aki-11111111"],
            'x86_64' => ["aki-22222222", "aki-33333333"],
          },
          'ramdisk_ids' => {
            'i386'   => ["ari-00000000", "ari-11111111"],
            'x86_64' => ["ari-22222222", "ari-33333333"],
          },
        }
      end
    end

  end

end
