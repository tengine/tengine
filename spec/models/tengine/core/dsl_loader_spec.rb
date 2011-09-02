# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tempfile'

describe Tengine::Core::DslLoader do

  describe :evaluate do
    before :all do
      @temp_dir = Dir.tmpdir
      @temp_dsl_01 = Tempfile::new("temp_dsl_01.rb", @temp_dir)
      @temp_dsl_01.puts(<<-EOS)
# -*- coding: utf-8 -*-
require 'tengine/core'
Tengine.driver :driver01 do
  # イベントに対応する処理の実行する
  on:event01 do
    puts "handler01"
  end
end
      EOS
      @temp_dsl_02 = Tempfile::new("temp_dsl_02.rb", @temp_dir)
      @temp_dsl_02.puts(<<-EOS)
# -*- coding: utf-8 -*-
require 'tengine/core'
Tengine.driver :driver02 do
  on:event02_1 do
    puts "handler02_1"
    fire(:event02_2)
  end
  on:event02_2 do
    puts "handler02_2"
  end
end
      EOS
    end

    after :all do
      @temp_dsl_01.close(true)
      @temp_dsl_02.close(true)
    end

    context "イベントハンドラ定義のファイル名まで指定されている" do
      before do
        @config = {
          :dsl_store_path => @temp_dir,
          :dsl_file => @temp_dsl_01.path,
        }
        @loader = Tengine::Core::DslEnv.new(@config)
        @loader.extend(Tengine::Core::DslLoader)
      end

      it "ディレクトリが $LOAD_PATH に追加されていること" do
        @loader.evaluate
        $LOAD_PATH.include?(@config[:dsl_store_path]).should be_true
      end

      it "イベントハンドラ定義がロードされていること" do
        pending "Tengine.driver 未実装"
        Tengine.should_receive(:driver).with(:driver01)
        @loader.evaluate
      end

    end

    describe "イベントハンドラの評価" do
      describe :driver do
        it "Tengine.driverが呼び出されること"
        it "DslEnvが生成されていること"
        it "driverが登録されていること"
      end
    end
  end

end
