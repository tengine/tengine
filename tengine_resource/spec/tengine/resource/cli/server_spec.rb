require 'spec_helper'

require 'tengine/resource/cli'

describe Tengine::Resource::CLI::Server do

  describe "#list" do
    context "no server" do
      before(:all){ Tengine::Resource::Server.delete_all }
      before do
        $stdout.stub(:puts) # ignore output to stdout
        Mongoid.should_receive(:configure) # and ignore given block
      end
      subject{ Tengine::Resource::CLI::Server.new.list }
      its(:class){ should == Array }
      its(:length){ should == 1 } # header line
    end

    context "some servers" do
      before(:all){ ExampleFixtures1.build }
      before do
        $stdout.stub(:puts) # ignore output to stdout
        Mongoid.should_receive(:configure) # and ignore given block
      end

      shared_examples_for "Tengine::Resource::CLI::Server#list with sort" do |options, expected_names|
        let(:list){ Tengine::Resource::CLI::Server.new.list(options) }
        let(:header){ list.first }
        let(:result){ list[1..-1] }

        describe :list do
          subject{ list }
          its(:class){ should == Array }
          its(:length){ should == 7 }
        end

        describe :header do
          it{ header.should == %w[provider virtual? name addresses] }
        end

        describe :result do
          let(:names){ result.map{|r| r[2] } }
          it{ names.should == expected_names }
        end
      end

      it_should_behave_like "Tengine::Resource::CLI::Server#list with sort", {                      }, %w[AWS_Instance_1 ap-northeast-1a physical_server_1 physical_server_2 virtual_server_1 virtual_server_2]
      it_should_behave_like "Tengine::Resource::CLI::Server#list with sort", {"sort" => 'name'      }, %w[AWS_Instance_1 ap-northeast-1a physical_server_1 physical_server_2 virtual_server_1 virtual_server_2]
      it_should_behave_like "Tengine::Resource::CLI::Server#list with sort", {"sort" => 'created_at'}, %w[ap-northeast-1a physical_server_1 physical_server_2 AWS_Instance_1 virtual_server_1 virtual_server_2]
      it_should_behave_like "Tengine::Resource::CLI::Server#list with sort", {"sort" => 'updated_at'}, %w[physical_server_2 virtual_server_1 virtual_server_2 physical_server_1 AWS_Instance_1 ap-northeast-1a]

    end
  end

  describe "#add" do
    context "valid" do
      before do
        Tengine::Resource::Server.delete_all
      end

      it do
        $stdout.stub(:puts) # ignore output to stdout
        expect{
          Tengine::Resource::CLI::Server.new.add("test_server1", addresses: {"private_ip_address" => "192.168.1.11", "private_dns_name" => "server11"})
        }.to change(Tengine::Resource::Server, :count).by(1)
        s1 = Tengine::Resource::Server.first
        s1.addresses["private_ip_address"].should == "192.168.1.11"
        s1.addresses["private_dns_name"].should == "server11"
      end
    end

    context "duplicated" do
      before do
        Tengine::Resource::Server.delete_all
        @name = "test_server1"
        @attrs = {
          provider_id: Tengine::Resource::Provider.manual.id,
          addresses: {"private_ip_address" => "192.168.1.11", "private_dns_name" => "server11"}
        }
        Tengine::Resource::PhysicalServer.create!(@attrs.update(name: @name))
      end

      it do
        expect{
          expect{
            Tengine::Resource::CLI::Server.new.add(@name, @attrs)
          }.to raise_error
        }.to change(Tengine::Resource::Server, :count).by(0)
      end
    end
  end


end
