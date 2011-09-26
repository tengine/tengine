# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::Provider::Ec2 do

  before(:all) do
    @credential = Tengine::Resource::Credential.new(:name => "ec2-access-key1",
      :auth_type_key => :ec2_access_key,
      :auth_values => {:access_key => 'ACCESS_KEY1', :secret_access_key => "SECRET_ACCESS_KEY1", :default_region => "us-west-1"})
  end

  before do
    @valid_attributes1 = {
      :name => "my_west-1",
      :credential => @credential
    }
  end

  describe :validation do
    context "valid" do
      subject{ Tengine::Resource::Provider::Ec2.new(@valid_attributes1) }
      its(:valid?){ should be_true }
    end

    context "invalid" do
      subject{ Tengine::Resource::Provider::Ec2.new }
      its(:valid?){ should be_false }
    end
  end

  describe 'update resources' do
    subject do
      Tengine::Resource::Provider::Ec2.create!(:name => "ec2 us-west-1", :credential => @credential)
    end

    before do
      # spec/support/ec2.rb を参照してください
      RightAws::Ec2.should_receive(:new).
        with('ACCESS_KEY1', "SECRET_ACCESS_KEY1", :region => "us-west-1", :logger => Rails.logger).
        and_return(setup_ec2_stub)
    end

    it "最初の実行時には物理サーバを登録する" do
      subject.physical_servers.count.should == 0
      subject.update_physical_servers
      subject.physical_servers.count.should == 2
      servers = subject.physical_servers.order(:provided_name)
      west_1a = servers.first
      west_1a.provider.should == subject
      west_1a.name.should == "us-west-1a"
      west_1a.provided_name.should == "us-west-1a"
      west_1a.status.should == "available"
      west_1b = servers.last
      west_1b.provider.should == subject
      west_1b.name.should == "us-west-1b"
      west_1b.provided_name.should == "us-west-1b"
      west_1b.status.should == "available"
    end
  end

end
