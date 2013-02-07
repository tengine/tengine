require 'spec_helper'

require 'tengine/resource/cli'

describe Tengine::Resource::CLI::Credential do

  before do
    $stdout.stub(:puts) # ignore output to stdout
    Mongoid.should_receive(:configure) # and ignore given block
  end

  describe "#list" do
    context "no credential" do
      before(:all){ Tengine::Resource::Credential.delete_all }
      subject{ Tengine::Resource::CLI::Credential.new.list }
      its(:class){ should == Array }
      its(:length){ should == 1 } # header line
    end

    context "some credential" do
      before(:all){ ExampleFixtures1.build_credentials }

      shared_examples_for "Tengine::Resource::CLI::Credential#list with sort" do |options, expected_names|
        let(:list){ Tengine::Resource::CLI::Credential.new.list(options) }
        let(:header){ list.first }
        let(:result){ list[1..-1] }

        describe :list do
          subject{ list }
          its(:class){ should == Array }
          its(:length){ should == 5 }
        end

        describe :header do
          it{ header.should == %w[name auth_values created_at updated_at] }
        end

        describe :result do
          let(:names){ result.map(&:first) }
          it{ names.should == expected_names }
        end
      end

      it_should_behave_like "Tengine::Resource::CLI::Credential#list with sort", {                      }, %w[ssh_pkf1 ssh_pkf2 ssh_pw1 ssh_pw2]
      it_should_behave_like "Tengine::Resource::CLI::Credential#list with sort", {"sort" => 'name'      }, %w[ssh_pkf1 ssh_pkf2 ssh_pw1 ssh_pw2]
      it_should_behave_like "Tengine::Resource::CLI::Credential#list with sort", {"sort" => 'created_at'}, %w[ssh_pw1 ssh_pkf1 ssh_pw2 ssh_pkf2]
      it_should_behave_like "Tengine::Resource::CLI::Credential#list with sort", {"sort" => 'updated_at'}, %w[ssh_pkf1 ssh_pkf2 ssh_pw1 ssh_pw2]
    end
  end

  describe "#add" do
    before do
      @name = "ssh_pw1"
      @attrs = {
        auth_values: {
          username: "goku",
          password: "password1"
        }
      }
    end

    context "valid" do
      before do
        Tengine::Resource::Credential.delete_all
      end

      it "password" do
        $stdout.stub(:puts) # ignore output to stdout
        expect{
          Tengine::Resource::CLI::Credential.new.add(@name, @attrs[:auth_values])
        }.to change(Tengine::Resource::Credential, :count).by(1)
        c1 = Tengine::Resource::Credential.first
        c1.name.should == @name
        c1.auth_values["username"].should == @attrs[:auth_values][:username]
        c1.auth_values["password"].should == @attrs[:auth_values][:password]
      end

      context "public_key" do
        shared_examples_for "Tengine::Resource::CLI::Credential#add with public_key" do |arg_hash, expected_hash|
          it do
            $stdout.stub(:puts) # ignore output to stdout
            expect{
              Tengine::Resource::CLI::Credential.new.add("ssh_pk1", arg_hash)
            }.to change(Tengine::Resource::Credential, :count).by(1)
            c1 = Tengine::Resource::Credential.first
            c1.name.should == "ssh_pk1"
            expected_hash.each do |k, v|
              c1.auth_values[k.to_s].should == v
            end
          end
        end

        it_should_behave_like("Tengine::Resource::CLI::Credential#add with public_key",
                         {"username" => "goku", "private_key_file" => "~/.ssh/id_rsa"},
                         {"username" => "goku", "private_key_file" => "~/.ssh/id_rsa", "passphrase" => nil}
                         )

        it_should_behave_like("Tengine::Resource::CLI::Credential#add with public_key",
                         {"username" => "goku", "private_key_file" => "~/.ssh/id_rsa", "passphrase" => "passphrase1"},
                         {"username" => "goku", "private_key_file" => "~/.ssh/id_rsa", "passphrase" => "passphrase1"}
                         )
      end
    end

    context "duplicated" do
      before do
        Tengine::Resource::Credential.delete_all
        Tengine::Resource::Credential.create!(@attrs.merge(name: @name).merge(auth_type_key: :ssh_password))
      end

      it do
        expect{
          expect{
            Tengine::Resource::CLI::Credential.new.add(@name, @attrs[:auth_values])
          }.to raise_error
        }.to change(Tengine::Resource::Credential, :count).by(0)
      end
    end
  end


  describe "#remove" do
    before do
      @name = "ssh_pw1"
      @attrs = {
        auth_values: {
          username: "goku",
          password: "password1"
        }
      }
    end

    context "target exists" do
      before do
        Tengine::Resource::Credential.delete_all
        Tengine::Resource::Credential.create!(@attrs.merge(name: @name).merge(auth_type_key: :ssh_password))
      end
      it do
        $stdout.stub(:puts) # ignore output to stdout
        expect{
          Tengine::Resource::CLI::Credential.new.remove(@name)
        }.to change(Tengine::Resource::Credential, :count).by(-1)
      end
    end

    context "target doesn't exist" do
      before do
        Tengine::Resource::Credential.delete_all
      end
      it do
        expect{
          expect{
            Tengine::Resource::CLI::Credential.new.remove(@name)
          }.to raise_error
        }.to change(Tengine::Resource::Credential, :count).by(0)
      end
    end
  end

end
