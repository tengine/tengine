#language:ja
機能: アプリケーション開発者がイベントハンドラ定義を作成する
  [アプリケーションを開発]するために
  [アプリケーション開発者]
  は[イベントハンドラ定義を作成]したい

  # 正常系でテストするイベントハンドラ定義
  #  require 'tengine/core'
  #  require 'fileutils'
  #
  #  driver :driver_exsample do
  #    # イベントが発生したら新たなイベントを発火する
  #    on :event1 do
  #      fire(:event2)
  #    end
  #
  #    on :event2 do
  #      # event2 が発火したらファイルを作成する
  #      FileUtils.touch "./tmp/e2e_test/event2.txt"
  #    end
  #  end

  # テストコード
  #  require 'spec_helper'
  #
  #  describe :driver_example do
  #    it ":event1 が発火すると、./tmp/e2e_test/event2.txtが作成される" do
  #      # driver_example は event1 を受けてイベントハンドリングする
  #      driver_example.should_handle_event(:event1)
  #      # driver_example は event2 を受けてイベントハンドリングする
  #      driver_example.should_handle_event(:event2)
  #      # event1 を発火する
  #      fire(:event1)
  #      # ファイルが作成されていること
  #      File.exists?("./tmp/e2e_test/event2.txt").should be_true
  #    end
  #  end

  背景:
    前提 "DBパッケージ"のインストールおよびセットアップが完了している
    かつ "キューパッケージ"のインストールおよびセットアップが完了している
    かつ "Tengineコアパッケージ"のインストールおよびセットアップが完了している
    # かつ "DBプロセス"が起動している
    # かつ "キュープロセス"が起動している

    # 作成するイベントハンドラ定義とテストファイル、イベントハンドラが作成する一時ファイルを削除する 
    前提 イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"が存在しない
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"が存在しない
    かつ イベントハンドラが作成した一時ファイル"./tmp/e2e_test/event2.txt"が存在しない


  シナリオ: [正常系] アプリケーション開発者がイベントハンドラ定義を開発する
    # シナリオの概要
    # テストファーストを考慮して、はじめに失敗をさせています
    # 1. テストコード作成
    # 2. テスト実行 -> 失敗
    # 3. イベントハンドラ定義作成
    # 4. テスト実行 -> 成功

    もし イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'spec_helper'
    
    describe :driver_example do
      it ":event1 が発火すると、./tmp/e2e_test/event2.txtが作成される" do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されていること
        File.exists?("./tmp/e2e_test/event2.txt").should be_true
      end
    end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること

    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'tengine/core'
    require 'fileutils'

    driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      on :event2 do
        # event2 が発火したらファイルを作成する
        FileUtils.touch "./tmp/e2e_test/event2.txt"
      end
    end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること
    かつ イベントハンドラが作成したファイル"./tmp/e2e_test/event2.txt"が存在すること

    # 作成したファイルの削除
    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を削除する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を削除する
    かつ イベントハンドラが作成した一時ファイル"./tmp/e2e_test/event2.txt"を削除する


  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_イベントハンドラ定義に文法上の誤りがある
    # シナリオの概要
    # テストファーストを考慮して、はじめに失敗をさせています
    # 1. テストコード作成
    # 2. テスト実行 -> 失敗
    # 3. イベントハンドラ定義作成(文法に誤りがある)
    # 4. テスト実行 -> 失敗
    # 5. イベントハンドラ定義修正
    # 6. テスト実行 -> 成功

    もし イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'spec_helper'
    
    describe :driver_example do
      it ":event1 が発火すると、./tmp/e2e_test/event2.txtが作成される" do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されていること
        File.exists?("./tmp/e2e_test/event2.txt").should be_true
      end
    end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること


    #
    # ここから異常系シナリオ
    # イベントハンドラ定義の文法を誤って記述
    #
    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'tengine/core'
    require 'fileutils'

    driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end
    end

    # :event2を　driverの外に記述する
    on :event2 do
      # event2 が発火したらファイルを作成する
      FileUtils.touch "./tmp/e2e_test/event2.txt"
    end
    """
    # テストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること
    かつ イベントハンドラが作成したファイル"./tmp/e2e_test/event2.txt"が存在しないこと
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'tengine/core'
    require 'fileutils'

    driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      on :event2 do
        # event2 が発火したらファイルを作成する
        FileUtils.touch "./tmp/e2e_test/event2.txt"
      end
    end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること
    かつ イベントハンドラが作成したファイル"./tmp/e2e_test/event2.txt"が存在すること

    # 作成したファイルの削除
    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を削除する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を削除する
    かつ イベントハンドラが作成した一時ファイル"./tmp/e2e_test/event2.txt"を削除する


  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_振る舞いが不正_イベントハンドラ定義に誤りがある
    # シナリオの概要
    # テストファーストを考慮して、はじめに失敗をさせています
    # 1. テストコード作成
    # 2. テスト実行 -> 失敗
    # 3. イベントハンドラ定義作成(想定外の振る舞いを実装)
    # 4. テスト実行 -> 失敗
    # 5. イベントハンドラ定義修正
    # 6. テスト実行 -> 成功

    もし イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'spec_helper'
    
    describe :driver_example do
      it ":event1 が発火すると、./tmp/e2e_test/event2.txtが作成される" do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されていること
        File.exists?("./tmp/e2e_test/event2.txt").should be_true
      end
    end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること


    #
    # ここから異常系シナリオ
    # 誤ったイベントハンドラ定義を記述
    #
    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'tengine/core'
    require 'fileutils'

    driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end
    end

    # :event2を　driverの外に記述する
    on :event2 do
      # ファイルを作成するのではなく、出力するだけ
      # FileUtils.touch "./tmp/e2e_test/event2.txt"
      puts "./tmp/e2e_test/event2.txt"
    end
    """
    # テストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること
    かつ イベントハンドラが作成したファイル"./tmp/e2e_test/event2.txt"が存在しないこと
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'tengine/core'
    require 'fileutils'

    driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      on :event2 do
        # event2 が発火したらファイルを作成する
        FileUtils.touch "./tmp/e2e_test/event2.txt"
      end
    end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること
    かつ イベントハンドラが作成したファイル"./tmp/e2e_test/event2.txt"が存在すること

    # 作成したファイルの削除
    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を削除する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を削除する
    かつ イベントハンドラが作成した一時ファイル"./tmp/e2e_test/event2.txt"を削除する


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
    もし イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'spec_helper'
    
    describe :driver_example do
      it ":event1 が発火すると、./tmp/e2e_test/event2.txtが作成される" do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されて「いない」こと
        File.exists?("./tmp/e2e_test/event2.txt").should be_fale
      end
    end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'tengine/core'
    require 'fileutils'

    driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      on :event2 do
        # event2 が発火したらファイルを作成する
        FileUtils.touch "./tmp/e2e_test/event2.txt"
      end
    end
    """
    # テストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること
    かつ イベントハンドラが作成したファイル"./tmp/e2e_test/event2.txt"が存在すること

    もし イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'spec_helper'
    
    describe :driver_example do
      it ":event1 が発火すると、./tmp/e2e_test/event2.txtが作成される" do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されていること
        File.exists?("./tmp/e2e_test/event2.txt").should be_true
      end
    end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること
    かつ イベントハンドラが作成したファイル"./tmp/e2e_test/event2.txt"が存在すること

    # 作成したファイルの削除
    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を削除する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を削除する
    かつ イベントハンドラが作成した一時ファイル"./tmp/e2e_test/event2.txt"を削除する


  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_振る舞いが不正_イベントハンドラ定義に循環参照がある
    # シナリオの概要
    # テストファーストを考慮して、はじめに失敗をさせています
    # 1. テストコード作成
    # 2. テスト実行 -> 失敗
    # 3. イベントハンドラ定義作成(循環参照がある振る舞いを実装)
    # 4. テスト実行 -> 警告
    # 5. イベントハンドラ定義修正
    # 6. テスト実行 -> 成功

    もし イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"に以下の記述をする
    """
    # Todo
    # specをどのように書くか?

    # -*- coding: utf-8 -*-
    require 'spec_helper'
    
    describe :driver_example do
      it ":event1 が発火すると、./tmp/e2e_test/event2.txtが作成される" do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されていること
        File.exists?("./tmp/e2e_test/event2.txt").should be_true
      end
    end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 1 failure"と出力されていること


    #
    # ここから異常系シナリオ
    # 循環参照があるイベントハンドラ定義を記述
    #
    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'tengine/core'
    require 'fileutils'

    driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      # イベントが発生したら新たなイベントを発火する
      on :event2 do
        fire(:event1)
      end

      # event1 -> event2 -> event1 -> … と循環する
    end

    """
    # テストで警告が出力
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failure"と出力されていること
    かつ "イベントハンドラ定義のテスト"の標準出力に"[warn] Circular reference"と出力されていること
    かつ イベントハンドラが作成したファイル"./tmp/e2e_test/event2.txt"が存在しないこと
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"に以下の記述をする
    """
    # -*- coding: utf-8 -*-
    require 'tengine/core'
    require 'fileutils'

    driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      on :event2 do
        # event2 が発火したらファイルを作成する
        FileUtils.touch "./tmp/e2e_test/event2.txt"
      end
    end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"rspec ./tmp/e2e_test/uca0_create_dsl_spec.rb"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"1 example, 0 failures"と出力されていること
    かつ イベントハンドラが作成したファイル"./tmp/e2e_test/event2.txt"が存在すること

    # 作成したファイルの削除
    もし イベントハンドラ定義ファイル"./tmp/e2e_test/uca0_create_dsl.rb"を削除する
    かつ イベントハンドラ定義のテストファイル"./tmp/e2e_test/uca0_create_dsl_spec.rb"を削除する
    かつ イベントハンドラが作成した一時ファイル"./tmp/e2e_test/event2.txt"を削除する
