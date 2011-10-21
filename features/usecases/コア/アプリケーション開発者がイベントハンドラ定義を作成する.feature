#language:ja
機能: アプリケーション開発者がイベントハンドラ定義を作成する
  [アプリケーションを開発]するために
  [アプリケーション開発者]
  は[イベントハンドラ定義を作成]したい

  # 正常系でテストするイベントハンドラ定義
  # # -*- coding: utf-8 -*-
  # require 'tengine/core'
  # require 'fileutils'
  # 
  # driver :driver_example do
  #   # event1を受け取るとevent2を発火する
  #   on:event1 do
  #     fire("event2")
  #   end
  # end

  # テストコード
  # # -*- coding: utf-8 -*-
  # require 'spec_helper'
  # 
  # describe :driver_example do
  #   include Tengine::RSpec::Extension
  #
  #   target_dsl File.expand_path("../app/sample_dsl.rb", File.dirname(__FILE__))
  #   driver :driver_example
  # 
  #   it "event1 を受け取るとevent2が発火すること" do
  #     tengine.should_fire("event2")
  #     tengine.receive("event1")
  #   end
  # end


  背景:
    前提 "DBパッケージ"のインストールおよびセットアップが完了している
    かつ "キューパッケージ"のインストールおよびセットアップが完了している
    かつ "Tengineコアパッケージ"のインストールおよびセットアップが完了している

    # 作成するイベントハンドラ定義とテストファイル、イベントハンドラが作成する一時ファイルを削除する 
    前提 イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"が存在しない
    かつ イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"が存在しない
    かつ イベントハンドラが作成した一時ファイル"./tmp/end_to_end_test/event2.txt"が存在しない
    かつ Tengineを使ったアプリケーションのプロジェクトを"./tmp/end_to_end_test/sample_app"に新規で作成する
    かつ spec_helperファイル"./tmp/end_to_end_test/sample_app/spec/spec_helper.rb"が以下の内容で存在する
    """
# -*- coding: utf-8 -*-
require "bundler/setup"

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'

require 'tengine_core'
require 'tengine/rspec'
config = nil
begin
  config = Tengine::Core::Config.new(@hash)
  config.setup_loggers
rescue Exception
  puts "[#{$!.class.name}] #{$!.message}\n  " << $!.backtrace.join("\n  ")
  raise
end

require 'mongoid'
Mongoid::Document.module_eval do
  include Tengine::Core::CollectionAccessible
end
Mongoid.config.from_hash(config[:db])
Tengine::Core::MethodTraceable.disabled = true

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

require 'logger'
log_path = File.expand_path("../test.log", File.dirname(__FILE__))
Tengine.logger = Logger.new(log_path)
Tengine.logger.level = Logger::DEBUG
Tengine::Core.stdout_logger = Logger.new(log_path)
Tengine::Core.stdout_logger.level = Logger::DEBUG
Tengine::Core.stderr_logger = Logger.new(log_path)
Tengine::Core.stderr_logger.level = Logger::DEBUG
    """

  @u03-f01-s01
  シナリオ: [正常系] アプリケーション開発者がイベントハンドラ定義を開発する
    # シナリオの概要
    # テストファーストを考慮して、はじめに失敗をさせています
    # 1. テストコード作成
    # 2. テスト実行 -> 失敗
    # 3. イベントハンドラ定義作成
    # 4. テスト実行 -> 成功
    
    もし イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'spec_helper'

describe :driver_example do
  include Tengine::RSpec::Extension
  
  target_dsl File.expand_path("../app/sample_dsl.rb", File.dirname(__FILE__))
  driver :driver_example

  it "event1 を受け取るとevent2が発火すること" do
    tengine.should_fire("event2")
    tengine.receive("event1")
  end
end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること

    もし イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'tengine/core'
require 'fileutils'

driver :driver_example do
  # event1を受け取るとevent2を発火する
  on:event1 do
    fire("event2")
  end
end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること

  @u03-f01-s02
  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_イベントハンドラ定義に文法上の誤りがある
    # シナリオの概要
    # テストファーストを考慮して、はじめに失敗をさせています
    # 1. テストコード作成
    # 2. テスト実行 -> 失敗
    # 3. イベントハンドラ定義作成(文法に誤りがある)
    # 4. テスト実行 -> 失敗
    # 5. イベントハンドラ定義修正
    # 6. テスト実行 -> 成功

    もし イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'spec_helper'

describe :driver_example do
  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../app/sample_dsl.rb", File.dirname(__FILE__))
  driver :driver_example

  it "event1 を受け取るとevent2が発火すること" do
    tengine.should_fire("event2")
    tengine.receive("event1")
  end
end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること


    #
    # ここから異常系シナリオ
    # イベントハンドラ定義の文法を誤って記述
    #
    もし イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'tengine/core'
require 'fileutils'

driver :driver_example do
end
# driverの外に記述する
on:event1 do
  fire("event2")
end
    """
    # テストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること
    #
    # ここまで異常系シナリオ
    #

    もし イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'tengine/core'
require 'fileutils'

driver :driver_example do
  # event1を受け取るとevent2を発火する
  on:event1 do
    fire("event2")
  end
end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること

  @u03-f01-s03
  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_振る舞いが不正_イベントハンドラ定義に誤りがある
    # シナリオの概要
    # テストファーストを考慮して、はじめに失敗をさせています
    # 1. テストコード作成
    # 2. テスト実行 -> 失敗
    # 3. イベントハンドラ定義作成(想定外の振る舞いを実装)
    # 4. テスト実行 -> 失敗
    # 5. イベントハンドラ定義修正
    # 6. テスト実行 -> 成功
    
    もし イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'spec_helper'

describe :driver_example do
  include Tengine::RSpec::Extension
  
  target_dsl File.expand_path("../app/sample_dsl.rb", File.dirname(__FILE__))
  driver :driver_example

  it "event1 を受け取るとevent2が発火すること" do
    tengine.should_fire("event2")
    tengine.receive("event1")
  end
end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること


    #
    # ここから異常系シナリオ
    # 誤ったイベントハンドラ定義を記述
    #
    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'tengine/core'
require 'fileutils'

driver :driver_example do
  # 正しい振る舞いのevent2の発火ではなく、誤ってevent3を発火するような記述をしてしまった。
  on:event1 do
    fire("event3")
  end
end
    """
    # テストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'tengine/core'
require 'fileutils'

driver :driver_example do
  # event1を受け取るとevent2を発火する
  on:event1 do
    fire("event2")
  end
end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること

  @u03-f01-s04
  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_振る舞いが不正_テストコードに誤りがある
    # シナリオの概要
    # テストファーストを考慮して、はじめに失敗をさせています
    # 1. テストコード作成(誤ったテストコード)
    # 2. テスト実行 -> 失敗
    # 3. イベントハンドラ定義作成
    # 4. テスト実行 -> 失敗
    # 5. テストコード修正
    # 6. テスト実行 -> 成功
    
    #
    # ここまで異常系シナリオ
    # 誤ったテストコードを記述する
    #
    もし イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'spec_helper'

describe :driver_example do
  include Tengine::RSpec::Extension
  
  target_dsl File.expand_path("../app/sample_dsl.rb", File.dirname(__FILE__))
  driver :driver_example

  it "event1 を受け取るとevent2が発火すること" do
    # 正しくは event2 が発火されるところを、テストコードに誤って event3 が発火されると記述してしまった。
    tengine.should_fire("event3")
    tengine.receive("event1")
  end
end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'tengine/core'
require 'fileutils'

driver :driver_example do
  # event1を受け取るとevent2を発火する
  on:event1 do
    fire("event2")
  end
end
    """
    # テストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること

    もし イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'spec_helper'

describe :driver_example do
  include Tengine::RSpec::Extension
  
  target_dsl File.expand_path("../app/sample_dsl.rb", File.dirname(__FILE__))
  driver :driver_example

  it "event1 を受け取るとevent2が発火すること" do
    tengine.should_fire("event2")
    tengine.receive("event1")
  end
end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること

    # 作成したファイルの削除
    もし イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"を削除する
    かつ イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"を削除する

  @pending
  @u03-f01-s05
  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_振る舞いが不正_イベントハンドラ定義に循環参照がある
    # シナリオの概要
    # テストファーストを考慮して、はじめに失敗をさせています
    # 1. テストコード作成
    # 2. テスト実行 -> 失敗
    # 3. イベントハンドラ定義作成(循環参照がある振る舞いを実装)
    # 4. テスト実行 -> 警告
    # 5. イベントハンドラ定義修正
    # 6. テスト実行 -> 成功
    
    もし イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"に以下の記述をする
    """
    # TODO
    # specをどのように書くかテスティングフレームワークエクステンションの検討と実装が必要です。
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること


    #
    # ここから異常系シナリオ
    # 循環参照があるイベントハンドラ定義を記述
    #
    もし イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'tengine/core'
require 'fileutils'

driver :driver_example do
  # event1 を受け取ると、イベント処理が循環します。
  on:event1 do
    fire("event1")
  end
end
    """
    # テストで警告が出力
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failure"と出力されていること
    かつ "イベントハンドラ定義のテスト"の標準出力に"[warn] Circular reference"と出力されていること
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"に以下の記述をする
    """
# -*- coding: utf-8 -*-
require 'tengine/core'
require 'fileutils'

driver :driver_example do
  # 循環しないように発火するイベント種別を修正します。
  on:event1 do
    fire("event2")
  end
end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec -r ./tmp/end_to_end_test/sample_app/spec/spec_helper.rb ./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb "というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること

    # 作成したファイルの削除
    もし イベントハンドラ定義ファイル"./tmp/end_to_end_test/sample_app/app/sample_dsl.rb"を削除する
    かつ イベントハンドラ定義のテストファイル"./tmp/end_to_end_test/sample_app/spec/sample_dsl_spec.rb"を削除する
