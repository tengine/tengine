#language:ja
機能: アプリケーション開発者がいろんなパターンのイベントハンドラ定義を試してみる
  [Tengineの導入を検討]するために
  [アプリケーション開発者]
  は [いろいろなパターンのイベントハンドラ定義を登録] したい
  {アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる}のNo.72-84までの基本コースと代替コースを確認するためのテストである
  テスト中に使用しているファイル、ディレクトリの構成は以下のとおり
  ./features/usecases/コア/dsls/
  ├── try_dsl
  │   ├── dir_1
  │   │   ├── dir_2
  │   │   │   └── dsl_a.rb
  │   │   ├── dir_4
  │   │   │   └── dir_5
  │   │   │       └── dsl_b.rb
  │   │   ├── dir_sym -> dir_6
  │   │   ├── dsl_c.rb
  │   │   └── dsl_sym.rb -> dsl_e.rb
  │   ├── dir_11
  │   │   ├── dir_12_unreadable
  │   │   │   └── dsl_j.rb
  │   │   ├── dir_13
  │   │   │   └── dsl_k.rb
  │   │   ├── dir_14
  │   │   │   └── dsl_l_unreadable.rb
  │   │   ├── dsl_m_unreadable.rb
  │   │   └── dsl_n.rb
  │   ├── dir_6
  │   │   └── dsl_d.rb
  │   ├── dir_7
  │   │   ├── dsl_f_unreadable.rb
  │   │   └── dsl_g.rb
  │   ├── dir_8
  │   │   ├── dir_10
  │   │   │   └── dsl_i.rb
  │   │   └── dir_9_unreadable
  │   │       └── dsl_h.rb
  │   ├── dsl_e.rb
  │   ├── error_in_event_driver.rb
  │   ├── error_not_in_event_driver.rb
  │   ├── error_on_execute.rb
  │   ├── no_event_driver.rb
  │   ├── no_event_handler.rb
  │   └── syntax_error.rb
  ├── uc50_commit_event_at_first.rb
  ├── uc51_commit_event_at_first_submit.rb
  ├── uc52_commit_event_after_all_handler_submit.rb
  ├── uc53_submit_outside_of_handler.rb
  ├── uc54_ack_check_at_first.rb
  ├── uc55_ack_check_at_first_submit.rb
  ├── uc56_ack_check_after_all_handler_submit.rb
  ├── uc60_event_in_handler.rb
  ├── uc61_event_outside_of_handler.rb
  ├── uc62_session_in_driver.rb
  ├── uc63_session_outside_of_driver.rb
  ├── uc70_driver_enabled_on_activation.rb
  └── uc71_driver_disabled_on_activation.rb

  背景:
    前提 "DBパッケージ"のインストールおよびセットアップが完了している
    かつ "キューパッケージ"のインストールおよびセットアップが完了している
    かつ "Tengineコアパッケージ"のインストールおよびセットアップが完了している
    かつ "Tengineコンソールパッケージ"のインストールおよびセットアップが完了している
    かつ "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコアプロセス"が停止している
    かつ "Tengineコンソールプロセス"が起動している

  シナリオ: [正常系]アプリケーション開発者がイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_1/dir_2/dsl_a.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_1/dir_2/dsl_a.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver_a|有効|

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    
  シナリオ: [正常系]アプリケーション開発者がディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_1/dir_2"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_1/dir_2"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver_a|有効|

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントハンドラ実行時にエラーとなるイベントハンドラ定義を指定してTengineコアを起動する
  前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/error_on_execute.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/error_on_execute.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver_err|有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "event_err"の"発火"リンクをクリックする
    ならば "event_errを発火しました"と表示されていること 
    ならば "Tengineコアプロセス"の標準出力に"error"と出力されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントドライバが1つもないイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/no_event_driver.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/no_event_driver.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"warning"と出力されていること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ イベントドライバが登録されていないこと

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントハンドラが1つもないイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/no_event_handler.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/no_event_handler.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"warning"と出力されていること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ イベントドライバが登録されていないこと

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントドライバ内に一般的なエラーとなるイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/error_in_event_driver.rb"が存在すること
   
    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/error_in_event_driver.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントドライバ外に一般的なエラーとなるイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/error_not_in_event_driver.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/error_not_in_event_driver.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者がシンタックスエラーとなるイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsls/syntax_error.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/syntax_error.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    
  シナリオ:  [正常系]イベントを受け取ったらすぐにackを返すイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc50_commit_event_at_first.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml --process-stdout-log-output ./tmp/stdout.log -T ./features/usecases/コア/dsls/uc50_commit_event_at_first.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver50|有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event50"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event50を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |付加情報|
    |event50|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|--- {}|

    もし "Tengineコアプロセスのイベント処理ログファイル""./tmp/stdout.log"を参照する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler50:0"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ:  [正常系]ハンドラを実行して最初にSubmitされたときにackを返すイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc51_commit_event_at_first_submit.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml --process-stdout-log-output ./tmp/stdout.log -T ./features/usecases/コア/dsls/uc51_commit_event_at_first_submit.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |  driver51_1  |有効|
    |  driver51_2  |有効|
    |  driver51_3  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event51"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event51を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |付加情報|
    |event51|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|--- {}|

    もし "Tengineコアプロセスのイベント処理ログファイル""./tmp/stdout.log"を参照する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler51_1:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler51_2:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler51_3:0"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ:  [正常系]ハンドラを実行して全てsubmitされたときにackを返すイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc52_commit_event_after_all_handler_submit.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml --process-stdout-log-output ./tmp/stdout.log -T ./features/usecases/コア/dsls/uc52_commit_event_after_all_handler_submit.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |  driver52_1  |有効|
		|  driver52_2  |有効|
    |  driver52_3  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event52"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event52を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |付加情報|
    |event52|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|--- {}|

    もし "Tengineコアプロセスのイベント処理ログファイル""./tmp/stdout.log"を参照する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler52_1:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler52_2:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler52_3:1"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]submitをイベントハンドラ外で使用するイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc53_submit_outside_of_handler.rb"が存在すること
   
    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/uc53_submit_outside_of_handler.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"submit is not available outside of event handler block."と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ:  [正常系]ack_policyによって実行回数が1回になるイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc54_ack_check_at_first.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml --process-stdout-log-output ./tmp/stdout.log -T ./features/usecases/コア/dsls/uc54_ack_check_at_first.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver54_1|有効|
    |driver54_2|有効|


    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event54"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event54を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |付加情報|
    |event54|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|--- {}|

    もし "Tengineコアプロセスのイベント処理ログファイル""./tmp/stdout.log"を参照する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler54_1:1:0"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler54_2:1:0"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler54_3:1:0"と記述されていること
		
    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ:  [正常系]ack_policyによって実行回数が2回になるイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc55_ack_check_at_first_submit.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml --process-stdout-log-output ./tmp/stdout.log -T ./features/usecases/コア/dsls/uc55_ack_check_at_first_submit.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver55_1|有効|
    |driver55_2|有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event55"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event55を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |付加情報|
    |event55|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|--- {}|

    もし "Tengineコアプロセスのイベント処理ログファイル""./tmp/stdout.log"を参照する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler55_1:1:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler55_2:1:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler55_3:1:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler55_1:2:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler55_2:2:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler55_3:2:1"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ:  [正常系]ack_policyによって実行回数が3回になるイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc56_ack_check_after_all_handler_submit.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml --process-stdout-log-output ./tmp/stdout.log -T ./features/usecases/コア/dsls/uc56_ack_check_after_all_handler_submit.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver56_1|有効|
    |driver56_2|有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event56"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event56を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |付加情報|
    |event56|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|--- {}|

    もし "Tengineコアプロセスのイベント処理ログファイル""./tmp/stdout.log"を参照する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler56_1:1:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler56_2:1:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler56_3:1:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler56_1:2:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler56_2:2:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler56_3:2:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler56_1:3:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler56_2:3:1"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler56_3:3:1"と記述されていること


    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ:  [正常系]eventを使ってイベントの情報を取得するイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc60_event_in_handler.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/uc60_event_in_handler.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver60|有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event60"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event60を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |付加情報|
    |event60|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|--- {}|

    もし "Tengineコアプロセスのイベント処理ログファイル""./tmp/stdout.log"を参照する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:event_type_name:???"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:key:???"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:source_name:???"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:occured_at:???"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:notification_level:???"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:notification_confirmed:???"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:sender_name:???"と記述されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:properties:???"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
    
    
  シナリオ: [正常系]eventをイベントハンドラ外で使用するイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc61_event_outside_of_handler.rb"が存在すること
   
    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/uc61_event_outside_of_handler.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"event is not available outside of event handler block."と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ:  [正常系]sessionを使ってセッション情報を取得するイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc62_session_in_driver.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/uc62_session_in_driver.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver62|有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event62"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event60を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |付加情報|
    |event60|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|--- {}|

    もし "Tengineコアプロセスのイベント処理ログファイル""./tmp/stdout.log"を参照する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:101"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
    
    
  シナリオ: [正常系]sessionをイベントドライバ外で使用するイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc63_session_outside_of_driver.rb"が存在すること
   
    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/uc63_session_outside_of_driver.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"session is not available outside of event driver block."と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者がアクティベーション時に有効になるようなイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc70_driver_enabled_on_activation.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/uc70_driver_enabled_on_activation.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver70|有効|

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    
  シナリオ: [正常系]アプリケーション開発者がアクティベーション時に無効になるようなイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/uc71_driver_disabled_on_activation.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/uc71_driver_disabled_on_activation.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver71|有効|

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

    
  シナリオ: [正常系]アプリケーション開発者が存在しないイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dsl_not_exist.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dsl_not_exist.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者が存在しないディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_not_exist.rb"が存在しないこと

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_not_exist"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者が中にファイルが存在しないディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_1/dir_3"が存在しないこと

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/dir_4/dir_3/"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"worning"と出力されていること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ イベントドライバが登録されていないこと

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]階層になったディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_1"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_1"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称     |状態|
    |driver_a|有効|
    |driver_b|有効|
    |driver_e|有効|

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限がないイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_7/dsl_f_unreadable.rb"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_7/dsl_f_unreadable.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限がないディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_8/dir_9_unreadable"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_8/dir_9_unreadable"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限があるイベントハンドラ定義ファイルと読込権限がないイベントハンドラ定義ファイルが混在しているディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_7"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_7"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限があるディレクトリと読込権限がないディレクトリが混在しているディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_8"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_8"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限があるディレクトリに読込権限がないイベントハンドラ定義ファイルがあるディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_11/dir_14"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_11/dir_14"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  シナリオ: [正常系]読込権限が複雑に設定されている階層になったディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_11"が存在すること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_11"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力に"error"と出力されていること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
