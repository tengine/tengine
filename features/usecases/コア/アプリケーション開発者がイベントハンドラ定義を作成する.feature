#language:ja
機能: アプリケーション開発者がイベントハンドラ定義を作成する
  [アプリケーションを開発]するために
  [アプリケーション開発者]
  は[イベントハンドラ定義を作成]したい

  背景:
    # 作成するイベントハンドラ定義とテストファイル、イベントハンドラが作成する一時ファイルを削除する 
    前提 イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"が存在しない
    かつ イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"が存在しない
    かつ イベントハンドラが作成した一時ファイル"tmp/event2.txt"が存在しない

  シナリオ: [正常系] アプリケーション開発者がイベントハンドラ定義を開発する
    # もし アプリケーション開発者はテスティングフレームワークが利用できる環境を構築する。
    # かつ アプリケーション開発者はテスティングフレームワークエクステンションが利用できる環境を構築する。

    もし イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"に以下の記述をする
    """
    describe :driver_example do
      it :event1 が発火すると、/tmp/event2.txtが作成される do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されていること
        File.exists?("/tmp/event2.txt").should be_true
      end
    end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"echo 1"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"failure"と出力されていること

    もし イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"に以下の記述をする
    """
    require 'tengine/core'
    require 'fileutils'

    Tengine.driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      on :event2 do
        # event2 が発火したらファイルを作成する
        FileUtils.touch "/tmp/event2.txt"
      end
    end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"aa"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"bb"と出力されていること
    かつ イベントハンドラが作成したファイル"tmp/event2.txt"が存在すること


  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_イベントハンドラ定義に文法上の誤りがある
    # もし アプリケーション開発者はテスティングフレームワークが利用できる環境を構築する。
    # かつ アプリケーション開発者はテスティングフレームワークエクステンションが利用できる環境を構築する。

    もし イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"に以下の記述をする
    """
    describe :driver_example do
      it :event1 が発火すると、/tmp/event2.txtが作成される do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されていること
        File.exists?("/tmp/event2.txt").should be_true
      end
    end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"echo 1"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"failure"と出力されていること


    #
    # ここから異常系シナリオ
    # イベントハンドラ定義の文法を誤って記述
    #
    もし イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"に以下の記述をする
    """
    require 'tengine/core'
    require 'fileutils'

    Tengine.driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end
    end

    # :event2を　Tengine.driverの外に記述する
    on :event2 do
      # event2 が発火したらファイルを作成する
      FileUtils.touch "/tmp/event2.txt"
    end
    """
    # テストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"aa"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"bb"と出力されていること
    かつ イベントハンドラが作成したファイル"tmp/event2.txt"が存在しないこと
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"に以下の記述をする
    """
    require 'tengine/core'
    require 'fileutils'

    Tengine.driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      on :event2 do
        # event2 が発火したらファイルを作成する
        FileUtils.touch "/tmp/event2.txt"
      end
    end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"aa"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"bb"と出力されていること
    かつ イベントハンドラが作成したファイル"tmp/event2.txt"が存在すること


  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_振る舞いが不正_イベントハンドラ定義に誤りがある
    # もし アプリケーション開発者はテスティングフレームワークが利用できる環境を構築する。
    # かつ アプリケーション開発者はテスティングフレームワークエクステンションが利用できる環境を構築する。

    もし イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"に以下の記述をする
    """
    describe :driver_example do
      it :event1 が発火すると、/tmp/event2.txtが作成される do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されていること
        File.exists?("/tmp/event2.txt").should be_true
      end
    end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"echo 1"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"failure"と出力されていること


    #
    # ここから異常系シナリオ
    # 誤ったイベントハンドラ定義を記述
    #
    もし イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"に以下の記述をする
    """
    require 'tengine/core'
    require 'fileutils'

    Tengine.driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end
    end

    # :event2を　Tengine.driverの外に記述する
    on :event2 do
      # ファイルを作成するのではなく、出力するだけ
      # FileUtils.touch "/tmp/event2.txt"
      puts "/tmp/event2.txt"
    end
    """
    # テストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"aa"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"bb"と出力されていること
    かつ イベントハンドラが作成したファイル"tmp/event2.txt"が存在しないこと
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"に以下の記述をする
    """
    require 'tengine/core'
    require 'fileutils'

    Tengine.driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      on :event2 do
        # event2 が発火したらファイルを作成する
        FileUtils.touch "/tmp/event2.txt"
      end
    end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"aa"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"bb"と出力されていること
    かつ イベントハンドラが作成したファイル"tmp/event2.txt"が存在すること


  シナリオ: [異常系] イベントハンドラ定義のテストで失敗_振る舞いが不正_テストコードに誤りがある
    # もし アプリケーション開発者はテスティングフレームワークが利用できる環境を構築する。
    # かつ アプリケーション開発者はテスティングフレームワークエクステンションが利用できる環境を構築する。


    #
    # ここまで異常系シナリオ
    # 誤ったテストコードを記述する
    #
    もし イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"を作成する
    かつ イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"に以下の記述をする
    """
    describe :driver_example do
      it :event1 が発火すると、/tmp/event2.txtが作成される do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されて「いない」こと
        File.exists?("/tmp/event2.txt").should be_fale
      end
    end
    """
    # イベントハンドラ定義がないのでテストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"echo 1"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"failure"と出力されていること
    #
    # ここまで異常系シナリオ
    #


    もし イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"を作成する
    かつ イベントハンドラ定義ファイル"features/support/dsls/uc_a0_create_dsl.rb"に以下の記述をする
    """
    require 'tengine/core'
    require 'fileutils'

    Tengine.driver :driver_exsample do
      # イベントが発生したら新たなイベントを発火する
      on :event1 do
        fire(:event2)
      end

      on :event2 do
        # event2 が発火したらファイルを作成する
        FileUtils.touch "/tmp/event2.txt"
      end
    end
    """
    # テストに失敗
    かつ "イベントハンドラ定義のテスト"を行うために"aa"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"bb"と出力されていること
    かつ イベントハンドラが作成したファイル"tmp/event2.txt"が存在すること

    もし イベントハンドラ定義のテストファイル"features/support/dsls/uc_a0_create_dsl_spec.rb"に以下の記述をする
    """
    describe :driver_example do
      it :event1 が発火すると、/tmp/event2.txtが作成される do
        # driver_example は event1 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event1)
        # driver_example は event2 を受けてイベントハンドリングする
        driver_example.should_handle_event(:event2)
        # event1 を発火する
        fire(:event1)
        # ファイルが作成されていること
        File.exists?("/tmp/event2.txt").should be_true
      end
    end
    """
    # テストに成功
    かつ "イベントハンドラ定義のテスト"を行うために"aa"というコマンドを実行する
    ならば "イベントハンドラ定義のテスト"の標準出力に"bb"と出力されていること
    かつ イベントハンドラが作成したファイル"tmp/event2.txt"が存在すること
