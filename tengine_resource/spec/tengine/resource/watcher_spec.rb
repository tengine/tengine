require 'spec_helper'

describe Tengine::Resource::Watcher do

  class TestProvider1 < Tengine::Resource::Provider
    field :connection_settings, :type => Hash
  end

  describe :find_providers do
    before do
      Tengine::Resource::Provider.delete_all
    end

    context "no provider exist" do
        subject{ expect{ Tengine::Resource::Watcher.new.find_providers } }
        it{ should raise_error(Tengine::Resource::Watcher::ConfigurationError, "no provider found")}
    end

    context "providers exist" do
      before do
        @provider1 = TestProvider1.create!(:name => "test1", :connection_settings => {:foo => "FOO", :bar => "BAR"})
        @provider2 = TestProvider1.create!(:name => "test2", :connection_settings => {:baz => "BAZ"})
      end

      context "valid" do
        subject{ Tengine::Resource::Watcher.new.find_providers }

        its(:length){ should == 2 }
        its(:first){ should be_a(TestProvider1) }
        its(:last){ should be_a(TestProvider1) }
        it{ subject.first.id.should == @provider1.id }
        it{ subject.last.id.should == @provider2.id }
      end

      context "with provider class in unloaded package" do

        before do
          @provider_class_name = "Tengine::ResourceEc2::Provider"
          Tengine::Resource::Provider.collection.tap do |c|
            c.insert({:_id => Moped::BSON::ObjectId.new, :_type => @provider_class_name, :name => "tengine@ec2-tokyo",
                :connection_settings => {"access_key_file" => "~/.ec2/access_key", "secret_access_key_file" => "~/.ec2/secret_access_key"}})
          end
        end

        subject{ expect{ Tengine::Resource::Watcher.new.find_providers } }
        it{ should raise_error(Tengine::Resource::Watcher::ConfigurationError, "provider class not found: #{@provider_class_name}")}
      end

    end
  end

end
