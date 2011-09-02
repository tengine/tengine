# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::Config do

  YAML_EXAMPLE = <<END_OF_YAML
tengined:
  daemon: true
  activation_timeout: 300
  load_path: "/var/lib/tengine"
  log_dir: "/var/log/tengined"
  pid_dir: "/var/run/tengined_pids"
  activation_dir: "/var/run/tengined_activations"
db:
  host: localhost
  port: 27017
  username:
  password:
  database: tengine_production
event_queue:
  conn:
    host: localhost
    port: 5672
    vhost:
    user:
    pass:
  exchange:
    name: tengine_event_exchange
    type: direct
    durable: true
  queue:
    name: tengine_event_queue
    durable: true
END_OF_YAML


  context "ディレクトリ指定の設定ファイル" do
    subject do
      Tengine::Core::Config.new(YAML.load(YAML_EXAMPLE))
    end
    it "should allow to read value by using []" do
      expected = {
        'daemon' => true,
        "activation_timeout" => 300,
        "load_path" => "/var/lib/tengine",
        "log_dir" => "/var/log/tengined",
        "pid_dir" => "/var/run/tengined_pids",
        "activation_dir" => "/var/run/tengined_activations",
      }
      subject[:tengined].should == expected
      subject['tengined'].should == expected
      subject[:tengined]['daemon'].should == true
      subject[:tengined][:daemon].should == true
      subject[:event_queue][:conn][:host].should == "localhost"
      subject['event_queue']['conn']['host'].should == "localhost"
    end

    context "ディレクトリが存在する場合" do
      before do
        Dir.should_receive(:exist?).with("/var/lib/tengine").and_return(true)
      end

      it :dsl_dir_path do
        subject.dsl_dir_path.should == "/var/lib/tengine"
      end

      it :dsl_file_paths do
        Dir.should_receive(:glob).
          with("/var/lib/tengine/**/*.rb").
          and_return(["/var/lib/tengine/foo/bar.rb"])
        subject.dsl_file_paths.should == ["/var/lib/tengine/foo/bar.rb"]
      end

      it :dsl_version_path do
        subject.dsl_version_path.should == "/var/lib/tengine/VERSION"
      end

      context :dsl_version do
        it "VERSIONファイルがある場合" do
          File.should_receive(:exist?).with("/var/lib/tengine/VERSION").and_return(true)
          File.should_receive(:read).and_return("TEST20110905164100")
          subject.dsl_version.should == "TEST20110905164100"
        end

        it "VERSIONファイルがない場合" do
          File.should_receive(:exist?).with("/var/lib/tengine/VERSION").and_return(false)
          t = Time.local(2011,9,5,17,28,30)
          Time.stub!(:now).and_return(t)
          subject.dsl_version.should == "20110905172830"
        end
      end
    end

    context "ディレクトリもファイルも存在しない場合" do
      before do
        @error_message = "file or directory doesn't exist. /var/lib/tengine"
        Dir.should_receive(:exist?).with("/var/lib/tengine").and_return(false)
        File.should_receive(:exist?).with("/var/lib/tengine").and_return(false)
      end

      it :dsl_dir_path do
        expect{ subject.dsl_dir_path }.should raise_error(Tengine::Core::ConfigError, @error_message)
      end

      it :dsl_file_paths do
        expect{ subject.dsl_file_paths }.should raise_error(Tengine::Core::ConfigError, @error_message)
      end

      it :dsl_version_path do
        expect{ subject.dsl_version_path }.should raise_error(Tengine::Core::ConfigError, @error_message)
      end

      it :dsl_version do
        expect{ subject.dsl_version }.should raise_error(Tengine::Core::ConfigError, @error_message)
      end
    end

  end


  describe :default_hash do
    subject do
      @source = Tengine::Core::Config::DEFAULT
      Tengine::Core::Config.default_hash
    end
    it "must be copied deeply" do
      YAML.dump(subject).should == YAML.dump(@source)
    end
    it "must be differenct object(s)" do
      subject.object_id.should_not == @source.object_id
      subject[:action].object_id.should_not == @source[:action].object_id
      subject[:tengined].object_id.should_not == @source[:tengined].object_id
      subject[:tengined][:log_dir].object_id.should_not == @source[:tengined][:log_dir].object_id
      subject[:event_queue].object_id.should_not == @source[:event_queue].object_id
      subject[:event_queue][:conn].object_id.should_not == @source[:event_queue][:conn].object_id
      subject[:event_queue][:conn][:host].object_id.should_not == @source[:event_queue][:conn][:host].object_id
    end
  end

end
