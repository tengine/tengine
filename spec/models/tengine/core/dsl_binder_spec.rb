# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::DslBinder do

  describe :evaluate do
    before do
      @config = {
        :dsl_store_path => File::expand_path("../../../../usecases/コア/dsls/"),
        :dsl_file => "uc01_execute_processing_for_event.rb",
      }
      @binder = Tengine::Core::DslEnv.new(@config)
      @binder.extend(Tengine::Core::DslBinder)
    end

    describe "イベントハンドラ定義ストア" do
      it "ディレクトリがLOAD_PATHに追加されていること" do
        @binder.evaluate
        $LOAD_PATH.include?(@config[:dsl_store_path]).should be_true
      end
    end
  end

end
