# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::Template::SshJob do

  context "Rjn0001SimpleJobnetBuilderを使う場合" do
    [:actual, :template].each do |jobnet_type|
      context "#{jobnet_type}の場合" do

        before(:all) do
          builder = Rjn0009TreeSequentialJobnetBuilder.new
          r = builder.send(:"create_#{jobnet_type}")
          @ctx = builder.context
        end

        {
          "rjn0009" => [nil, nil, false],
          "j1100" => ["test_credential1" , "test_server1", false],
          "j1110" => ["test_credential1" , "test_server1", true ],
          "j1120" => ["test_credential1" , "test_server1", true ],
          "j1200" => ["test_credential1" , nil           , false],
          "j1210" => ["test_credential1" , "mysql_master", true ],
          "j1300" => [nil                , "mysql_master", false],
          "j1310" => ["test_credential1" , "mysql_master", true ],
          "j1400" => [nil                , nil           , false],
          "j1410" => ["test_credential1" , "mysql_master", true ],
          "j1500" => ["test_credential1" , "mysql_master", false],
          "j1510" => ["test_credential1" , "mysql_master", false],
          "j1511" => ["test_credential1" , "mysql_master", true ],
          "j1600" => ["test_credential1" , "mysql_master", false],
          "j1610" => ["test_credential1" , "mysql_master", false],
          "j1611" => ["test_credential1" , "test_server1", true ],
          "j1612" => ["gohan_ssh_pk"     , "mysql_master", true ],
          "j1620" => ["test_credential1" , "test_server1", false],
          "j1621" => ["test_credential1" , "test_server1", true ],
          "j1630" => ["gohan_ssh_pk", "mysql_master"     , false],
          "j1631" => ["gohan_ssh_pk", "mysql_master"     , true ],
        }.each do |job_name, (credential_name, server_name, ssh_job)|
          context "#{job_name} #{ssh_job ? :ssh_job : :jobnet}" do
            subject{ @ctx[job_name.to_sym] }

            its(:name){ should == job_name }

            its(:"class.name"){ should =~ (ssh_job ? /SshJob$/ : /Jobnet$/)}

            # Tengine::Job::Template::Jobnetは接続情報を持ちますが、
            # Tengine::Job::Runtiem::Jobnet は接続情報を持ちません。
            if jobnet_type == :template
              its(:actual_credential_name){ should == credential_name }
              its(:actual_server_name){ should == server_name }
            elsif ssh_job
              its(:actual_credential_name){ should == credential_name }
              its(:actual_server_name){ should == server_name }
            else
              it{ subject.respond_to?(:actual_credential_name).should == false }
              it{ subject.respond_to?(:actual_server_name).should == false }
            end
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
      jobnet = Tengine::Job::Template::Jobnet.new(:credential_name => "test_credential1")
      credential = jobnet.actual_credential
      credential.should be_a(Tengine::Resource::Credential)
      credential.name.should == "test_credential1"
    end

    it "存在しないCredentialの場合" do
      jobnet = Tengine::Job::Template::Jobnet.new(:credential_name => "unexist_credential")
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
      jobnet = Tengine::Job::Template::Jobnet.new(:server_name => "test_server1")
      server = jobnet.actual_server
      server.should be_a(Tengine::Resource::Server)
      server.name.should == "test_server1"
    end

    it "存在しないServerの場合" do
      jobnet = Tengine::Job::Template::Jobnet.new(:server_name => "unexist_server")
      expect{
        jobnet.actual_server
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

end
