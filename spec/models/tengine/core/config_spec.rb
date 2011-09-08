# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::Config do

  context "ディレクトリ指定の設定ファイル" do
    subject do
      Tengine::Core::Config.new(:config => File.expand_path("config_spec/config_with_dir_load_path.yml", File.dirname(__FILE__)))
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
      subject[:event_queue][:connection][:host].should == "localhost"
      subject['event_queue']['connection']['host'].should == "localhost"
      subject[:event_queue][:queue][:name].should == "tengine_event_queue2"
      subject['event_queue']['queue']['name'].should == "tengine_event_queue2"
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

  context "ファイル指定の設定ファイル" do
    subject do
      Tengine::Core::Config.new(:config => File.expand_path("config_spec/config_with_file_load_path.yml", File.dirname(__FILE__)))
    end
    it "should allow to read value by using []" do
      expected = {
        'daemon' => true,
        "activation_timeout" => 300,
        "load_path" => "/var/lib/tengine/init.rb",
        "log_dir" => "/var/log/tengined",
        "pid_dir" => "/var/run/tengined_pids",
        "activation_dir" => "/var/run/tengined_activations",
      }
      subject[:tengined].should == expected
      subject['tengined'].should == expected
      subject[:tengined]['load_path'].should == "/var/lib/tengine/init.rb"
      subject[:tengined][:load_path].should == "/var/lib/tengine/init.rb"
    end

    context "ファイルが存在する場合" do
      before do
        Dir.should_receive(:exist?).with("/var/lib/tengine/init.rb").and_return(false)
        File.should_receive(:exist?).with("/var/lib/tengine/init.rb").and_return(true)
      end

      it :dsl_dir_path do
        subject.dsl_dir_path.should == "/var/lib/tengine"
      end

      it :dsl_file_paths do
        subject.dsl_file_paths.should == ["/var/lib/tengine/init.rb"]
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

    context "ファイルもディレクトリも存在しない場合" do
      before do
        @error_message = "file or directory doesn't exist. /var/lib/tengine/init.rb"
        Dir.should_receive(:exist?).with("/var/lib/tengine/init.rb").and_return(false)
        File.should_receive(:exist?).with("/var/lib/tengine/init.rb").and_return(false)
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

  context "指定した設定ファイルが存在しない場合" do
    it "例外を生成します" do
      config_path = File.expand_path("config_spec/unexist_config.yml", File.dirname(__FILE__))
      expect{
        Tengine::Core::Config.new(:config => config_path)
      }.to raise_error(Tengine::Core::ConfigError, /Exception occurred when loading configuration file: #{config_path}./)
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
      subject[:event_queue][:connection].object_id.should_not == @source[:event_queue][:connection].object_id
      subject[:event_queue][:connection][:host].object_id.should_not == @source[:event_queue][:connection][:host].object_id
      subject[:event_queue][:queue][:name].should_not == @source[:event_queue][:queue][:name].object_id
    end
  end

end
