# -*- coding: utf-8 -*-
require 'spec_helper'

describe "作成途中のDSLを実行しているとドライバが見つからない場合がある" do
  before do
    Tengine::Core::Driver.delete_all
    Tengine::Core::HandlerPath.delete_all
    Tengine::Core::Event.delete_all
  end

  describe "Tengine::Core::Kernel#evaluate" do
    before do
      config = Tengine::Core::Config::Core.new({
          :tengined => {
            :load_path => File.expand_path('../../../../examples/uc01_execute_processing_for_event.rb', File.dirname(__FILE__)),
          },
        })
      @kernel = Tengine::Core::Kernel.new(config)
      # ドライバ名が "driver01" ではなく "driver00" となっている場合
      @driver = Tengine::Core::Driver.new(:name => "driver00", :version => config.dsl_version, :enabled => true)
      @handler1 = @driver.handlers.new(:filepath => "uc01_execute_processing_for_event.rb", :lineno => 7, :event_type_names => ["event01"])
      @driver.save!
    end

    it "同じバージョンで同じファイル名の異なるドライバが登録されてはいけない" do
      expect {
        expect {
          @kernel.evaluate
        }.to_not change(Tengine::Core::HandlerPath, :count)
      }.to_not change(Tengine::Core::Driver, :count)
    end

  end
end
