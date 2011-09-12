# -*- coding: utf-8 -*-
require 'spec_helper'

describe "uc50_commit_event_at_first" do
  before do
    config = Tengine::Core::Config.new({
        :tengined => {
          :load_path => File.expand_path('../../../../../examples/uc50_commit_event_at_first.rb', File.dirname(__FILE__)),
        },
      })
    @bootstrap = Tengine::Core::Bootstrap.new(config)
    @bootstrap.load_dsl
    @kernel = Tengine::Core::Kernel.new(config)
    @kernel.bind
  end

  it "必ずACKされている" do
    handler_invoked = false
    @kernel.dsl_env.should_receive(:puts).with("handler50 acknowledged").and_return{handler_invoked = true}
    @kernel.activate do |mq|
      run = lambda do
        EM.add_timer(0.5) do
          sender = Tengine::Event::Sender.new(mq)
          sender.fire(:event50)
        end
        require 'timeout'
        timeout(3) do
          sleep(0.1) until handler_invoked
        end
      end
      teardown = lambda do |result|
        @kernel.stop(true) # イベント処理中なので、無理矢理終了させます
        # EM.add_timer(0.1){ EM.stop }
      end
      EM.defer(run, teardown)
    end
  end

end
