# -*- coding: utf-8 -*-
require_relative '../../spec_helper'

require_relative '../../../lib/tengine/mq/suite'

# ログを黙らせたり喋らせたりする
require 'amq/client'
if $DEBUG
  require 'logger'
  AMQP::Session.logger = Tengine.logger = Logger.new(STDERR)
else
  AMQP::Session.logger = Tengine.logger = Tengine::NullLogger.new
end

require 'amq/client/callbacks'

describe Tengine::Mq::Suite do
  shared_examples "Tengine::Mq::Suite" do
    describe "#initialize" do
      context "no args" do
        subject { Tengine::Mq::Suite.new }
        its(:config) { should == {
            :sender                 => {
              :keep_connection      => false,
              :retry_interval       => 1,
              :retry_count          => 30,
            },
            :connection             => {
              :user                 => 'guest',
              :pass                 => 'guest',
              :vhost                => '/',
              :logging              => false,
              :insist               => false,
              :host                 => 'localhost',
              :port                 => 5672,
              :auto_reconnect_delay => 1,
            },
            :channel                => {
              :prefetch             => 1,
              :auto_recovery        => true,
            },
            :exchange               => {
              :name                 => 'tengine_event_exchange',
              :type                 => :direct,
              :passive              => false,
              :durable              => true,
              :auto_delete          => false,
              :internal             => false,
              :nowait               => false,
              :publish              => {
                :content_type       => "application/json",
                :persistent         => true,
              },
            },
            :queue                  => {
              :name                 => 'tengine_event_queue',
              :passive              => false,
              :durable              => true,
              :auto_delete          => false,
              :exclusive            => false,
              :nowait               => false,
              :subscribe            => {
                :ack                => true,
                :nowait             => false,
                :confirm            => nil,
              },
            },
          }
        }
      end

      context "hash arg" do
        subject { Tengine::Mq::Suite.new :sender => { :keep_connection => false } }
        its(:config) { should have_key(:sender) }
        it "merges the argument" do
          subject.config[:sender][:keep_connection].should be_false
          subject.config[:sender].should have_key(:retry_interval)
        end
      end
    end

    describe "#config" do
      subject { Tengine::Mq::Suite.new.config }
      it { should be_kind_of(Hash) }
      it { should be_frozen }
    end

    describe "#add_hook" do
      subject { Tengine::Mq::Suite.new the_config }

      context "no arg" do
        it { expect { subject.add_hook }.to raise_error(ArgumentError) }
      end

      context "many arg" do
        it { expect { subject.add_hook :foo, :bar }.to raise_error(ArgumentError) }
      end

      context "no block" do
        it { expect { subject.add_hook :foo }.to raise_error(ArgumentError) }
      end

      context "one arg, one block" do
        it { expect { subject.add_hook(:foo){ } }.to_not raise_error(ArgumentError) }
      end

      context "connection.on_closed" do
        it "called" do
          block_called = false
          subject.add_hook "connection.on_closed" do
            block_called = true
          end

          EM.run do
            subject.subscribe {|x, y| }
            EM.add_timer(0.1) { subject.stop }
          end
          block_called.should be_true
        end
      end

      context "connection.on_tcp_connection_failure" do
        subject {
          port = the_config[:connection] ? the_config[:connection][:port] : 5672
          Tengine::Mq::Suite.new :connection => { :port => port + rand(1024) }
        }

        it "https://www.pivotaltracker.com/story/show/18317933" do
          block_called = false
          subject.add_hook "connection.on_tcp_connection_failure" do
            block_called = true
          end
          expect {
            EM.run_block do
              subject.subscribe {|x, y| }
              EM.add_timer(0.2) { subject.stop }
            end
          }.to raise_exception
          block_called.should be_true
        end
      end

      # context "channel.on_error" ...
      # context "connection.after_recovery" ...

      it "hookを保持する" do
        mq = nil
        # 1st time
        yielded = 0
        EM.run do
          mq = subject
          mq.send :ensures, :connection do
            mq.add_hook(:"connection.on_closed") do
              yielded += 1
            end
            mq.stop
          end
        end

        # 2nd time
        yielded = 0
        EM.run do
          mq.send :ensures, :connection do
            mq.stop
          end
        end
        yielded.should == 1
      end

      it "hookを保持する #2" do
        mq = nil

        # 1st time
        yielded = 0
        EM.run do
          mq = subject
          mq.send :ensures, :channel do
            mq.add_hook(:"channel.on_error") do
              yielded += 1
            end
            mq.channel.exec_callback_once_yielding_self(:error, "channel close reason object")
            mq.stop
          end
        end

        # 2nd time
        yielded = 0
        EM.run do
          mq.send :ensures, :channel do
            mq.channel.exec_callback_once_yielding_self(:error, "channel close reason object")
            mq.stop
          end
        end
        yielded.should == 1
      end
    end

    describe "#subscribe" do
      subject { Tengine::Mq::Suite.new the_config }

      context "no block" do
        it { expect { subject.subscribe }.to raise_error(ArgumentError) }
      end

      context "no reactor, nowait: false" do
        it "raises" do
          block_called = false
          expect {
            subject.subscribe(:nowait => true) {
              block_called = true
            }
          }.to raise_error(RuntimeError)
          block_called.should be_false
        end
      end

      context "no reactor, nowait: true" do
        it "raises" do
          block_called = false
          expect {
            subject.subscribe(:nowait=>false) {
              block_called = true
            }
          }.to raise_error(RuntimeError)
          block_called.should be_false
        end
      end

      context "with reactor, with 1 message in queue" do
        it "runs the block" do
          block_called = false
          body = nil
          header = nil
          expect {
            EM.run do
              subject.subscribe do |hdr, bdy|
                block_called = true
                body = bdy
                header = hdr
                hdr.ack
                subject.stop
              end

              sender = Tengine::Event::Sender.new subject
              ev = Tengine::Event.new :event_type_name => "foo"
              subject.fire sender, ev, { :keep_connection => true }, nil
            end
          }.to_not raise_error(RuntimeError)
          block_called.should be_true
          header.should be_kind_of(AMQP::Header)
          body.should be_kind_of(String)
          body.should =~ /foo/
        end
      end

      context "many messages in queue" do
        before do
          # キューにイベントがすでに溜まってるとおかしくなるので、吸い出しておく
          EM.run do
            i = 0
            subject.subscribe do |hdr, bdy|
              hdr.ack
              i += 1
            end
            EM.add_periodic_timer(0.1) do
              subject.stop if i.zero?
              i = 0
            end
          end
        end

        it "runs the block every time" do
          block_called = 0
          expect {
            EM.run do
              subject.subscribe do |hdr, bdy|
                block_called += 1
                hdr.ack
              end

              sender = Tengine::Event::Sender.new subject
              EM.add_timer(0.1) {
                ev = Tengine::Event.new :event_type_name => "foo"
                subject.fire sender, ev, { :keep_connection => true }, nil
                EM.add_timer(0.1) {
                  ev = Tengine::Event.new :event_type_name => "foo"
                  subject.fire sender, ev, { :keep_connection => true }, nil
                  EM.add_timer(0.1) {
                    ev = Tengine::Event.new :event_type_name => "foo"
                    subject.fire sender, ev, { :keep_connection => true }, nil
                    EM.add_timer(0.3) {
                      subject.stop
                    }
                  }
                }
              }
            end
          }.to_not raise_error(RuntimeError)
          block_called.should == 3
        end
      end
    end

    describe "#unsubscribe" do
      subject { Tengine::Mq::Suite.new the_config }

      context "no block" do
        it { expect { subject.unsubscribe }.to raise_error(ArgumentError) }
      end

      context "no queue" do
        it "runs the block" do
          block_called = false
          expect {
            subject.unsubscribe {
              block_called = true
              subject.stop
            }
          }.to_not raise_error(RuntimeError)
          block_called.should be_true
        end
      end

      context "queue not subscribed" do
        it "runs the block" do
          block_called = false
          expect {
            EM.run do
              subject.send :ensures, :queue do
                subject.unsubscribe do
                  block_called = true
                  subject.stop
                end
              end
            end
          }.to_not raise_error(RuntimeError)
          block_called.should be_true
        end
      end

      context "subscribed" do
        it "runs the block" do
          block_called = false
          expect {
            EM.run do
              subject.subscribe :nowait => false, :confirm => lambda {|x|
                subject.unsubscribe {|y|
                  block_called = true
                  subject.stop
                }
              } do |hdr, bdy|
                hdr.ack
              end
            end
          }.to_not raise_error(RuntimeError)
          block_called.should be_true
        end
      end

      context "nowait:true" do
        it "runs the block" do
          block_called = false
          expect {
            EM.run do
              subject.subscribe :nowait => false, :confirm => lambda {|x|
                subject.unsubscribe({:nowait => true}) {|y|
                  block_called = true
                  subject.stop
                }
              } do |hdr, bdy|
                hdr.ack
              end
            end
          }.to_not raise_error(RuntimeError)
          block_called.should be_true
        end
      end
    end

    describe "#fire" do
      subject { Tengine::Mq::Suite.new the_config }
      def sender; Tengine::Event::Sender.new subject end
      def expected_event; Tengine::Event.new(:event_type_name => :foo, :key => "uniq_key") end

      context "without reactor" do
        it "raises" do
          block_called = false
          expect {
            ev = Tengine::Event.new :event_type_name => "foo"
            subject.fire sender, ev, { :keep_connection => true }, nil
          }.to raise_error(RuntimeError)
          block_called.should be_false
        end
      end

      context "with reactor" do
        after do
          # キューにイベントがたまるのでてきとうに吸い出す
          if @port
            EM.run do
              subject.send :ensures, :connection do
              i = 0
              subject.subscribe do |hdr, bdy|
                hdr.ack
                i += 1
              end
              @timer = EM.add_periodic_timer(0.1) do
                if i.zero?
                  EM.cancel_timer @timer
                  subject.unsubscribe do
                    subject.stop
                  end
                else
                  i = 0
                end
              end
              end
            end
          end
        end

        it "JSON形式にserializeしてexchangeにpublishする" do
          Thread.current[:expected_event] = expected_event
          EM.run do
            subject.send :ensures, :exchange do |xchg|
              def xchg.publish json, hash
                json.should == Thread.current[:expected_event].to_json
                super
              end
              subject.fire sender, Thread.current[:expected_event], {:keep_connection => false}, nil
            end
          end
        end

        it "Tengine::Eventオブジェクトを直接指定する" do
          # 上と同じ…過去には意味があった
          Thread.current[:expected_event] = expected_event
          EM.run do
            subject.send :ensures, :exchange do |xchg|
              def xchg.publish json, hash
                json.should == Thread.current[:expected_event].to_json
                super
              end
              subject.fire sender, Thread.current[:expected_event], {:keep_connection => false}, nil
            end
          end
        end

        context "publish後に特定の処理を行う" do
          it "カスタム処理" do
            block_called = false
            EM.run do
              sender.fire "foo" do
                block_called = true
              end
            end
            block_called.should be_true
          end
        end

        context "keep_connection: true" do
          it "do not stop the reactor" do
            block_called = false
            EM.run do
              sender.fire "foo", :keep_connection => true
              EM.add_timer(0.5) do
                block_called = true
                subject.stop
              end
            end
            block_called.should be_true
          end
        end

        context "keep_connection: false" do
          it "stop the reactor" do
            block_called = false
            EM.run do
              sender.fire "foo", :keep_connection => false
              EM.add_timer(1) do
                block_called = true
                subject.stop
              end
            end
            block_called.should be_false
          end
        end

        context "AMQP::TCPConnectionFailed 以外のエラー" do
          it "メッセージ送信ができなくてpublishに渡したブロックが呼び出されず、インターバルが過ぎて、EM.add_timeに渡したブロックが呼び出された場合" do
            block_called = false
            EM.run do
              subject.send :ensures, :exchange do |xchg|
                xchg.stub(:publish).with(expected_event.to_json, :content_type => "application/json", :persistent => true).exactly(31).times.and_raise(StandardError)
                subject.fire sender, expected_event, {:keep_connection => false, :retry_interval => 0}, lambda { block_called = true }
                subject.stop
              end
            end
            block_called.should_not be_true
          end

          it "エラーが発生しても設定のリトライが行われる" do
            EM.run do
              subject.send :ensures, :exchange do |xchg|
                # 正規のfireとリトライのfireなので、リトライ回数+1
                xchg.stub(:publish).with(expected_event.to_json, :content_type => "application/json", :persistent => true).exactly(31).times.and_raise(StandardError)
                subject.fire sender, expected_event, {:keep_connection => false, :retry_interval => 0}, nil
                subject.stop
              end
            end
          end

          it "エラーが発生してもオプションで指定したリトライ回数分のリトライが行われる" do
            EM.run do
              subject.send :ensures, :exchange do |xchg|
                # 正規のfireとリトライのfireなので、リトライ回数+1
                xchg.stub(:publish).with(expected_event.to_json, :content_type => "application/json", :persistent => true).exactly(2).times.and_raise(StandardError)
                subject.fire sender, expected_event, {:keep_connection => false, :retry_interval => 0, :retry_count => 1}, nil
                subject.stop
              end
            end
          end

          it "エラーが発生してもオプションで指定したリトライ間隔でリトライが行われる" do
            t0 = Time.now
            EM.run do
              subject.send :ensures, :exchange do |xchg|
                # 正規のfireとリトライのfireなので、リトライ回数+1
                x = sender
                xchg.stub(:publish).with(expected_event.to_json, :content_type => "application/json", :persistent => true).exactly(3).times.and_raise(StandardError)
                subject.fire x, expected_event, {:keep_connection => false, :retry_interval => 1, :retry_count => 2}, nil
                subject.stop
              end
            end
            t1 = Time.now
            (t1 - t0).should be_within(1.0).of(2.0)
          end

          it "ちょうどretry_count回めのリトライして成功の場合は例外にならない" do
            block_called = false
            EM.run do
              subject.send :ensures, :exchange do |xchg|
                # 正規のfireとリトライのfireなので、リトライ回数+1
                Thread.current[:expected_event] = expected_event
                Thread.current[:x] = false
                def xchg.publish str, hash
                  if Thread.current[:x] = !Thread.current[:x]
                    raise "foo"
                  else
                    super
                  end
                end
                subject.fire sender, expected_event, {:keep_connection => false, :retry_interval => 0, :retry_count => 2}, lambda { block_called = true }
                subject.stop
              end
            end
            block_called.should be_true
          end
        end
      end

      context "複数のEM event loopにまたがったfire" do
        it "https://www.pivotaltracker.com/story/show/21252625" do
          EM.run do sender.fire("foo") end
          EM.run do sender.fire("foo") end
          # ここまでくればOK
        end
      end

      context "入り乱れたfireにおけるretryの回数" do
        it "https://www.pivotaltracker.com/story/show/20236589" do
          Thread.current[:n1] = 0
          Thread.current[:n2] = 0
          Thread.current[:ev1] = ev1 = Tengine::Event.new(:event_type_name => :foo, :key => "uniq_key")
          Thread.current[:ev2] = ev2 = Tengine::Event.new(:event_type_name => :foo, :key => "another_uniq_key")
          EM.run do
            subject.send :ensures, :exchange do |xchg|
              def xchg.publish json, hash
                case json
                when Thread.current[:ev1].to_json
                  Thread.current[:n1] += 1
                  raise "ev1"
                when Thread.current[:ev2].to_json
                  Thread.current[:n2] += 1
                  raise "ev2"
                end
              end

              subject.fire sender, ev1, {:keep_connection => true, :retry_interval => 0}, nil
              subject.fire sender, ev2, {:keep_connection => true, :retry_interval => 0}, nil
              subject.stop
            end
          end
          n1 = Thread.current[:n1]
          n2 = Thread.current[:n2]
          if n1 == 31
            n2.should <= 31
            n2.should >= 2
          elsif n2 == 31
            n1.should <= 31
            n1.should >= 2
          else
            raise "neither n1(#{n1}) nor n2(#{n2})"
          end
        end

        it "無限にメモリを消費しない" do
          n = 256 # 1024 # 4096
          EM.run do
            subject.send :ensures, :exchange do |xchg|
              xchg.stub(:publish).with(an_instance_of(String), :content_type => "application/json", :persistent => true).exactly(31).times.and_raise(StandardError)
              n.times do
                EM.next_tick do
                  ev = Tengine::Event.new(:event_type_name => :foo, :key => "uniq_key")
                  subject.fire sender, ev, {:keep_connection => true, :retry_cont => 3, :retry_interval => 0}, nil
                end
              end
              EM.next_tick do
                subject.stop
              end
            end
          end
          GC.start
          subject.pending_events{true}.size.should < n
        end
      end
    end

    describe "#stop" do
      subject { Tengine::Mq::Suite.new the_config }
      let(:sender) { Tengine::Event::Sender.new subject }
      let(:expected_event) { Tengine::Event.new(:event_type_name => :foo, :key => "uniq_key") }

      after do
        # キューにイベントがたまるのでてきとうに吸い出す
        if @port
          EM.run do
            subject.send :ensures, :connection do
            i = 0
            subject.subscribe do |hdr, bdy|
              hdr.ack
              i += 1
            end
            EM.add_periodic_timer(0.1) do
              subject.stop if i.zero?
              i = 0
            end
            end
          end
        end
      end

      it "EMのイベントループを抜ける" do
        EM.run do
          subject.stop
        end
        # ここに到達すればOK
      end

      it "ペンディングのイベントが送信されるまではEMのイベントループにとどまる" do
        block_called = false
        EM.run do
          subject.send :ensures, :exchange do |xchg|
            Thread.current[:expected_event] = expected_event
            Thread.current[:x] = false
            def xchg.publish str, hash
              if Thread.current[:x] = !Thread.current[:x]
                raise "foo"
              else
                super
              end
            end
            subject.fire sender, expected_event, {:keep_connection => false, :retry_interval => 0, :retry_count => 2}, lambda { block_called = true }
            subject.stop
          end
        end
        block_called.should be_true
      end
    end

    describe "#initiate_termination" do
      subject { Tengine::Mq::Suite.new the_config }
      after do
        # キューにイベントがたまるのでてきとうに吸い出す
        if @port
          EM.run do
            i = 0
            j = false
            subject.subscribe :confirm=>proc{j = true} do |hdr, bdy|
              hdr.ack
              i += 1
            end
            EM.add_periodic_timer(0.1) do
              if j
                subject.stop if i.zero?
                i = 0
              end
            end
          end
        end
      end

      it "再接続しない" do
        block_called = false
        EM.run do
          subject.add_hook("connection.after_recovery") { block_called = true }
          subject.initiate_termination do
            EM.defer(proc { finish; trigger@port },
                     proc { subject.stop })
          end
        end
        block_called.should_not be_true
      end
    end

    describe "#callback_entity" do
      subject { Tengine::Mq::Suite.new the_config }
      it "registers callbacks" do
        EM.run do
          subject.send :ensures, :queue do
            { :queue => [
                :before_recovery,
                :after_recovery,
                :after_connection_interruption,
              ],
              :exchange => [
                :before_recovery,
                :after_recovery,
                :after_connection_interruption,
              ],
              :channel => [
                :before_recovery,
                :after_recovery,
                :after_connection_interruption,
                :error,
              ],
              :connection => [
                :before_recovery,
                :after_recovery,
                :after_connection_interruption,
                :error,
#                 :on_closed,
#                 :on_possible_authentication_failure,
#                 :on_tcp_connection_failure,
#                 :on_tcp_connection_loss,
              ]
            }.each_pair do |klass, mids|
              obj = subject.send klass
              mids.each do |mid|
                case obj when AMQ::Client::Callbacks
                  obj.should be_has_callback(mid) # 英語おかしいがしょうがない
                else
                  # mockかも
                end
              end
            end
            subject.stop
          end
        end
      end
    end
  end

  context "実際にMQに接続する試験" do
    next if RUBY_VERSION < "1.9.2"
    next if ENV['TRAVIS'] == 'true'

    let(:rabbitmq) do
      ret = nil
      ENV["PATH"].split(/:/).find do |dir|
        Dir.glob("#{dir}/rabbitmq-server") do |path|
          if File.executable?(path)
            ret = path
            break
          end
        end
      end

      pending "these specs needs a rabbitmq installed" unless ret
      ret
    end

    def trigger port = rand(32768)
      raise "WRONG" if $_pid
      require 'tmpdir'
      $_dir = Dir.mktmpdir
      # 指定したポートはもう使われているかもしれないので、その際は
      # rabbitmqが起動に失敗するので、何回かポートを変えて試す。
      n = 0
      begin
        envp = {
          "RABBITMQ_NODENAME"        => "rspec",
          "RABBITMQ_NODE_PORT"       => port.to_s,
          "RABBITMQ_NODE_IP_ADDRESS" => "auto",
          "RABBITMQ_MNESIA_BASE"     => $_dir.to_s,
          "RABBITMQ_LOG_BASE"        => $_dir.to_s,
        }
        $_pid = Process.spawn(envp, rabbitmq, :pgroup => true, :chdir => $_dir, :in => :close)
        x = Time.now
        while Time.now < x + 16.0 do # まあこんくらい待てばいいでしょ
          sleep 0.1
          Process.waitpid2($_pid, Process::WNOHANG)
          Process.kill 0, $_pid
          # netstat -an は Linux / BSD ともに有効
          # どちらかに限ればもう少し効率的な探し方はある。たとえば Linux 限定でよければ netstat -lnt ...
          y = `netstat -an | fgrep LISTEN | fgrep #{port}`
          if y.lines.to_a.size >= 1
            @port = port
            return
          end
        end
        pending "failed to invoke rabbitmq in 16 secs."
      rescue Errno::ECHILD, Errno::ESRCH
        if (n += 1) > 10
          pending "10 attempts to invoke rabbitmq failed."
        else
          port = rand(32768)
          retry
        end
      end
    end

    def finish
      if $_pid
        begin
          Process.kill "INT", -$_pid
          Process.waitpid $_pid
        rescue Errno::ECHILD, Errno::ESRCH
        ensure
          require 'fileutils'
          FileUtils.remove_entry_secure $_dir, :force
        end
      end
      $_pid = nil
    end

    before :all do
      trigger
    end

    after :all do
      finish
    end

    let(:the_config) {
      {
        :connection => {
          :port => @port,
        },
      }
    }
    it_should_behave_like "Tengine::Mq::Suite"
  end

  context "mock/stubによる試験" do
    def trigger *;
    end
    def finish
    end

    class Mocker
      class << self
        alias_method :[], :new
      end
      def initialize inspect
        @inspect = inspect
      end
      attr_reader :inspect
    end

    # for exchange
    class RSpec::Mocks::Mock
      def publish str, opt
        $the_messages.push str
      end
    end

    class RSpec::Mocks::MessageExpectation
      def and_emyield *val
        index = Object.new
        @emvals ||= Hash.new
        @emvals[index] = val
        def self.invoke_with_yield(&block)
          if block.nil?
            @error_generator.raise_missing_block_error @args_to_yield
          end
          value = nil
          @args_to_yield.each do |args_to_yield_this_time|
            if Array === args_to_yield_this_time[0] and @emvals.key?(args_to_yield_this_time[0][0])
              value = EM.next_tick do
                block.yield(*args_to_yield_this_time[0][1])
              end
            else
              if block.arity > -1 && args_to_yield_this_time.length != block.arity
                @error_generator.raise_wrong_arity_error args_to_yield_this_time, block.arity
              end
              value = eval_block(*args_to_yield_this_time, &block)
            end
          end
          value
        end
        and_yield([index, val])
      end
    end

    before do
      $the_messages   = EM::Queue.new
      @the_connection = mock(Mocker["connection"])
      @the_channel_id = Numeric.new
      @the_channel    = mock(Mocker["channel"])
      @the_exchange   = mock(Mocker["exchange"])
      @the_queue      = mock(Mocker["queue"])
      @callbacks      = Hash.new do |h, k|
        h[k]          = Hash.new 
      end
      AMQP.stub(:connect).with(an_instance_of(Hash)) do |h, block|
        EM.next_tick do
          block.yield @the_connection
          if h[:port] != 5672
            @callbacks[@the_connection][:on_tcp_connection_failure].yield @the_connection if @callbacks[@the_connection][:on_tcp_connection_failure]
            raise AMQP::Error, "fake error."
          end
        end
      end
      AMQP::Channel.stub(:next_channel_id).and_return(@the_channel_id)
      AMQP::Channel.stub(:new).with(@the_connection, @the_channel_id, an_instance_of(Hash)).and_emyield(@the_channel).and_return(@the_channel)
      AMQP::Exchange.stub(:new).with(@the_channel, an_instance_of(Symbol), an_instance_of(String), an_instance_of(Hash)).and_emyield(@the_exchange).and_return(@the_exchange)
      @the_connection.stub(:connected?).and_return(true)
      @the_connection.stub(:disconnect) do |block|
        EM.next_tick do
          @callbacks[@the_connection][:on_closed].yield @the_connection if @callbacks[@the_connection][:on_closed]
          block.yield
          $the_messages = EM::Queue.new # reset
        end
      end
      @the_connection.stub(:server_capabilities).and_return(Hash.new)
      @the_connection.stub(:before_recovery)
      @the_connection.stub(:after_recovery)
      @the_connection.stub(:on_connection_interruption)
      @the_connection.stub(:on_closed) do |block| @callbacks[@the_connection][:on_closed] = block end
      @the_connection.stub(:on_possible_authentication_failure)
      @the_connection.stub(:on_tcp_connection_failure) do |block| @callbacks[@the_connection][:on_tcp_connection_failure] = block end
      @the_connection.stub(:on_tcp_connection_loss)
      @the_channel.stub(:queue).with(an_instance_of(String), an_instance_of(Hash)).and_emyield(@the_queue).and_return(@the_queue)
      @the_channel.stub(:close).and_emyield
      @the_channel.stub(:before_recovery)
      @the_channel.stub(:after_recovery)
      @the_channel.stub(:on_connection_interruption)
      @the_channel.stub(:on_error) do |block| @callbacks[@the_channel][:on_error] = block end
      @the_channel.stub(:exec_callback_once_yielding_self).with(:error, "channel close reason object") do
        EM.next_tick do
          @callbacks[@the_channel][:on_error].yield @the_channel if @callbacks[@the_channel][:on_error]
        end
      end
      @the_exchange.stub(:publish).with(an_instance_of(String), an_instance_of(Hash)) do |str, opt|
        $the_messages.push str
      end
      @the_exchange.stub(:before_recovery)
      @the_exchange.stub(:after_recovery)
      @the_exchange.stub(:on_connection_interruption)
      @the_queue.stub(:bind).with(@the_exchange, an_instance_of(Hash)).and_emyield
      @the_queue.stub(:subscribe).with(an_instance_of(Hash)) do |h, block|
        h[:confirm].call mock(Mocker["confirm-ok"]) if h[:confirm] and not h[:nowait]
        cb = lambda do |ev|
          header = AMQP::Header.new @the_channel, nil, Hash.new
          header.stub(:ack)
          block.yield header, ev
          $the_messages.pop(&cb)
        end
        EM.next_tick do
          $the_messages.pop(&cb)
        end
      end
      @the_queue.stub(:before_recovery)
      @the_queue.stub(:after_recovery)
      @the_queue.stub(:on_connection_interruption)
      @the_queue.stub(:default_consumer)
    end

    let(:the_config) { Hash.new }
    it_should_behave_like "Tengine::Mq::Suite"
  end
end
