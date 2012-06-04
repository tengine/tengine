require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'mongoid'
require 'tengine/support/mongo_index'

describe "mongo_index" do
  describe :create_indexes do

    context "when model exist in subdirectories" do

      context "when the model is namespaced" do
        module Twitter
          class Follow
            include Mongoid::Document
          end
        end

        let(:files) { ["/lib/twitter/follow.rb"] }
        let(:conf) { stub }

        before do
          Dir.should_receive(:glob).with("/lib/**/*.rb").and_return(files)
          Mongoid.should_receive(:configure).and_return(conf)
        end

        it "loads the model with the namespacing" do
          Twitter::Follow.should_receive(:create_indexes).once
          Tengine::Support::MongoIndex.create_indexes("/lib")
        end
      end

      context "when the model is not namespaced" do
        class Unfollow; include Mongoid::Document end

        let(:files) { ["/lib/twitter/unfollow.rb"] }
        let(:conf) { stub }

        before do
          Dir.should_receive(:glob).with("/lib/**/*.rb").and_return(files)
          Mongoid.should_receive(:configure).and_return(conf)
        end

        it "loads the model with the namespacing" do
          Unfollow.should_receive(:create_indexes).once
          Tengine::Support::MongoIndex.create_indexes("/lib")
        end
      end
    end
  end

end
