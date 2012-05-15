# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::Connectable do

  context "Rjn0001SimpleJobnetBuilderを使う場合" do
    [:actual, :template].each do |jobnet_type|
      context "#{jobnet_type}の場合" do

        before(:all) do
          builder = Rjn0009TreeSequentialJobnetBuilder.new
          builder.send(:"create_#{jobnet_type}")
          @ctx = builder.context
        end

        {
          "rjn0009" => [nil, nil],
          "j1100" => ["test_credential1" , "test_server1"],
          "j1110" => ["test_credential1" , "test_server1"],
          "j1120" => ["test_credential1" , "test_server1"],
          "j1200" => ["test_credential1" , nil           ],
          "j1210" => ["test_credential1" , "mysql_master"],
          "j1300" => [nil                , "mysql_master"],
          "j1310" => ["test_credential1" , "mysql_master"],
          "j1400" => [nil                , nil           ],
          "j1410" => ["test_credential1" , "mysql_master"],
          "j1500" => ["test_credential1" , "mysql_master"],
          "j1510" => ["test_credential1" , "mysql_master"],
          "j1511" => ["test_credential1" , "mysql_master"],
          "j1600" => ["test_credential1" , "mysql_master"],
          "j1610" => ["test_credential1" , "mysql_master"],
          "j1611" => ["test_credential1" , "test_server1"],
          "j1612" => ["gohan_ssh_pk"     , "mysql_master"],
          "j1620" => ["test_credential1" , "test_server1"],
          "j1621" => ["test_credential1" , "test_server1"],
          "j1630" => ["gohan_ssh_pk", "mysql_master"     ],
          "j1631" => ["gohan_ssh_pk", "mysql_master"     ],
        }.each do |job_name, (credential_name, server_name)|
          context job_name do
            subject{ @ctx[job_name.to_sym] }
            its(:actual_credential_name){ should == credential_name }
            its(:actual_server_name){ should == server_name }
          end
        end

      end
    end

  end

  describe :actual_credential do
    before do
      resource_fixture = GokuAtEc2ApNortheast.new
      resource_fixture.goku_ssh_pw
    end

    it "存在するCredentialの場合" do
      jobnet = Tengine::Job::JobnetTemplate.new(:credential_name => "test_credential1")
      credential = jobnet.actual_credential
      credential.should be_a(Tengine::Resource::Credential)
      credential.name.should == "test_credential1"
    end

    it "存在しないCredentialの場合" do
      jobnet = Tengine::Job::JobnetTemplate.new(:credential_name => "unexist_credential")
      expect{
        jobnet.actual_credential
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end


  describe :actual_server do
    before do
      resource_fixture = GokuAtEc2ApNortheast.new
      resource_fixture.hadoop_master_node
    end

    it "存在するServerの場合" do
      jobnet = Tengine::Job::JobnetTemplate.new(:server_name => "test_server1")
      server = jobnet.actual_server
      server.should be_a(Tengine::Resource::Server)
      server.name.should == "test_server1"
    end

    it "存在しないServerの場合" do
      jobnet = Tengine::Job::JobnetTemplate.new(:server_name => "unexist_server")
      expect{
        jobnet.actual_server
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

end
