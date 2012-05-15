# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

require 'logger'
require 'tempfile'
require 'active_support/core_ext/logger'

describe 'Tengine::Support::Config::Logger' do

  context "static" do
    describe Tengine::Support::Config::Logger.output do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :string }
      its(:__name__){ should == :output }
      its(:description){ should == 'file path or "STDOUT" / "STDERR" / "NULL".'}
      its(:default){ should == "STDOUT"}
    end

    describe Tengine::Support::Config::Logger.rotation do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == nil} # 文字列か整数値なので指定していません
      its(:__name__){ should == :rotation }
      its(:description){ should == 'rotation file count or daily,weekly,monthly.'}
      its(:default){ should == nil}
    end

    describe Tengine::Support::Config::Logger.rotation_size do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :integer }
      its(:__name__){ should == :rotation_size }
      its(:description){ should == 'number of max log file size.'}
      its(:default){ should == nil}
    end

    describe Tengine::Support::Config::Logger.level do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :string }
      its(:__name__){ should == :level }
      its(:description){ should == 'Logging severity threshold.'}
      its(:enum){ should == %w[debug info warn error fatal]}
      its(:default){ should == "info"}
    end

    describe Tengine::Support::Config::Logger.progname do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :string }
      its(:__name__){ should == :progname }
      its(:description){ should == 'program name to include in log messages.'}
      its(:default){ should == nil}
    end

    describe Tengine::Support::Config::Logger.datetime_format do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :string }
      its(:__name__){ should == :datetime_format }
      its(:description){ should == 'A string suitable for passing to strftime.'}
      its(:default){ should == nil}
    end

    # describe Tengine::Support::Config::Logger.formatter do
    #   it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
    #   its(:type){ should == :proc }
    #   its(:__name__){ should == :formatter }
    #   its(:description){ should == 'Logging formatter, as a Proc that will take four arguments and return the formatted message.'}
    #   its(:default){ should == nil}
    # end
  end

  context "デフォルト値" do
    context "instantiate_childrenなし" do
      subject{ Tengine::Support::Config::Logger.new }
      its(:output){ should == nil }
      its(:rotation){ should == nil}
      its(:rotation_size){ should == nil}
      its(:level){ should == nil}
      its(:datetime_format){ should == nil}
      its(:formatter){ should == nil}
      its(:progname){ should == nil}
    end

    context "instantiate_childrenあり" do
      subject{ Tengine::Support::Config::Logger.new.instantiate_children }
      its(:output){ should == "STDOUT" }
      its(:rotation){ should == nil}
      its(:rotation_size){ should == nil}
      its(:level){ should == "info"}
      its(:datetime_format){ should == nil}
      its(:formatter){ should == nil}
      its(:progname){ should == nil}
    end

    describe :level do
      subject{ Tengine::Support::Config::Logger.new.instantiate_children }

      it "nilが明示的に指定されてもデフォルト値になる" do
        subject.level = nil
        subject.level.should == 'info'
      end

      %w[debug info warn error fatal].each do |name|
        it "#{name}を設定することができる" do
          subject.level = name
          subject.level.should == name
        end
      end

      %w[invalid_name DEBUG inf err].each do |name|
        it "#{name}は設定することができない" do
          expect{
            subject.level = name
          }.to raise_error(ArgumentError)
        end
      end
    end

    describe :rotation do
      subject{ Tengine::Support::Config::Logger.new.instantiate_children }

      ["daily", "weekly", "monthly", :daily, 2, 8].each do |value|
        it "#{value}を設定することができる(変換なし)" do
          subject.rotation = value
          subject.rotation.should == value
        end
      end

      ["1", "100"].each do |value|
        it "#{value}を設定することができる(変換あり)" do
          subject.rotation = value
          subject.rotation.should == value.to_i
        end
      end

      ['invalid_rotation', true, false].each do |value|
        it "#{value}は設定することができない" do
          expect{
            subject.rotation = value
          }.to raise_error(ArgumentError)
        end
      end
    end


    describe :output do
      subject{ Tengine::Support::Config::Logger.new.instantiate_children }

      %w[STDOUT STDERR NULL].each do |value|
        it "#{value}を設定することができる" do
          subject.output = value
          subject.output.should == value
        end
      end

      it "存在するディレクトリのファイル" do
        path = File.expand_path("unexist.log", File.dirname(__FILE__))
        subject.output = path
        subject.output.should == path
      end

      it "存在しないディレクトリのファイル" do
        expect{
          subject.output = "/unexist/dir/foo.log"
        }.to raise_error(ArgumentError)
      end
    end

  end

  describe :new_logger do
    context "デフォルトの場合" do
      subject{ Tengine::Support::Config::Logger.new.instantiate_children.new_logger }
      its(:datetime_format){ should == nil}

      require 'active_support/version'
      if ActiveSupport::VERSION::STRING =~ /^3\.0\./
        its(:formatter){ should be_a(Logger::SimpleFormatter)}
      else
        its(:formatter){ should == nil}
      end

      its(:level){ should == 1}
      its(:progname){ should == nil}
    end

    context "各属性の設定と引数を指定が両方ある場合" do
      before{ @tempfile = Tempfile.new("test.log") }
      after { @tempfile.close }
      it "引数に指定されたオプションを優先" do
        mock_logger = Logger.new("/dev/null")
        Logger.should_receive(:new).with($stdout, nil, nil).and_return(mock_logger)
        Tengine::Support::Config::Logger.new.tap{|c|
          c.output = @tempfile.path
        }.instantiate_children.new_logger(:output => $stdout)
      end
    end

    context "各属性を設定を指定する場合" do
      before{ @tempfile = Tempfile.new("test.log") }
      after { @tempfile.close }
      subject do
        Tengine::Support::Config::Logger.new.tap{|c|
          c.output = @tempfile.path
          c.rotation = "3"
          c.rotation_size = 1000000
          c.level = "info"
          c.datetime_format = "%Y/%m/%d %H:%M:%S"
          c.progname = "foobar"
        }.instantiate_children.new_logger
      end
      its(:datetime_format){ should == "%Y/%m/%d %H:%M:%S"}
      its(:formatter){ should be_a(Logger::Formatter)}
      its(:level){ should == 1}
      its(:progname){ should == "foobar"}
      it "実際に出力してみる" do
        t = Time.local(2011, 12, 31, 23, 59, 59)
        Time.stub!(:now).and_return(t)
        subject.info("something started.")
        subject.error("something happened.")
        File.read(@tempfile.path).should == [
          "I, [2011/12/31 23:59:59##{Process.pid}]  INFO -- foobar: something started.\n",
          "E, [2011/12/31 23:59:59##{Process.pid}] ERROR -- foobar: something happened.\n"
        ].join
      end

      context "更にformatterも指定してみる" do
        before do
          subject.formatter = lambda{|level, t, prog, msg| "#{t.iso8601} #{level} #{prog} #{msg}\n"}
        end
        it "実際に出力してみる" do
          t = Time.utc(2011, 12, 31, 23, 59, 59)
          Time.stub!(:now).and_return(t)
          subject.info("something started.")
          subject.error("something happened.")
          File.read(@tempfile.path).should == [
            "2011-12-31T23:59:59Z INFO foobar something started.\n",
            "2011-12-31T23:59:59Z ERROR foobar something happened.\n",
          ].join
        end
      end
    end

    it "STDOUTの場合" do
      config = Tengine::Support::Config::Logger.new.instantiate_children
      config.output = "STDOUT"
      config.level = "warn"
      config.rotation = nil
      config.rotation_size = nil
      config.output.should == "STDOUT"
      config.level.should == "warn"
      config.rotation.should == nil
      config.rotation_size.should == nil
      logger = Logger.new(STDOUT, nil, nil)
      Logger.should_receive(:new).with(STDOUT, nil, nil).and_return(logger)
      logger.should_receive(:level=).with(Logger::WARN)
      config.new_logger.should == logger
    end

    it "STDERRの場合" do
      config = Tengine::Support::Config::Logger.new.instantiate_children
      config.output = "STDERR"
      config.level = "warn"
      config.rotation = nil
      config.rotation_size = nil
      logger = Logger.new(STDERR, nil, nil)
      Logger.should_receive(:new).with(STDERR, nil, nil).and_return(logger)
      logger.should_receive(:level=).with(Logger::WARN)
      config.new_logger.should == logger
    end

    it "NULLの場合" do
      config = Tengine::Support::Config::Logger.new.instantiate_children
      config.output = "NULL"
      config.level = "warn"
      config.rotation = nil
      config.rotation_size = nil
      Tengine::Support::NullLogger.should_receive(:new).and_return(:logger)
      config.new_logger.should == :logger
    end

    context "ファイル名の場合" do
      before do
        @tempfile = Tempfile.new("test.log")
        @filepath = @tempfile.path
      end
      after do
        @tempfile.close
      end

      %w[daily weekly monthly].each do |shift_age|
        it "shift_age が #{shift_age}" do
          config = Tengine::Support::Config::Logger.new.instantiate_children
          config.output = @filepath
          config.level = "info"
          config.rotation = shift_age
          config.rotation_size = nil
          logger = Logger.new(@filepath, shift_age, nil)
          Logger.should_receive(:new).with(@filepath, shift_age, nil).and_return(logger)
          logger.should_receive(:level=).with(Logger::INFO)
          config.new_logger.should == logger
        end
      end

      it "shift_ageが整数値" do
        config = Tengine::Support::Config::Logger.new.instantiate_children
        config.output = @filepath
        config.level = "info"
        config.rotation = "3"
        config.rotation_size = 10 * 1024 * 1024 # 10MB
        logger = Logger.new(@filepath, 3, 10 * 1024 * 1024)
        Logger.should_receive(:new).with(@filepath, 3, 10 * 1024 * 1024).and_return(logger)
        logger.should_receive(:level=).with(Logger::INFO)
        config.new_logger.should == logger
      end
    end
  end

end
