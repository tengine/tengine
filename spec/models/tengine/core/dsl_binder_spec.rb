# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::DslBinder do

  describe :evaluate do
    before do
      config = Tengine::Core::Config.new({
        :tengined_load_path => File.expand_path('dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__)),
      })
      @binder = Tengine::Core::DslEnv.new
      @binder.config = config
    end
  end

end
