#language:ja
機能: アプリケーション開発者がいろんなパターンのイベントハンドラ定義を試してみる
  [Tengineの導入を検討]するために
  [アプリケーション開発者]
  は [いろいろなパターンのイベントハンドラ定義を登録] したい
  {アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる}のNo.72-84までの基本コースと代替コースを確認するためのテストである
  テスト中に使用しているファイル、ディレクトリの構成は以下のとおり
  ./features/usecases/コア/dsls/try_dsl
  ├── dir_1
  │   ├── dir_2
  │   │   └── dsl_a.rb     driver_a(event_a -> handler_a)
  │   ├── dir_3
  │   ├── dir_4
  │   │   └── dir_5
  │   │       └── dsl_b.rb driver_b(event_b -> handler_b)
  │   ├── dir_sym -> dir_6
  │   ├── dsl_c.rb          driver_c(event_c -> handler_c)
  │   └── dsl_sym.rb -> dsl_e.rb
  ├── dir_6
  │   └── dsl_d.rb          driver_d(event_d -> handler_d)
  ├── dsl_e.rb               driver_e(event_e -> handler_e)
  ├── dir_7
  │   ├── dsl_f.rb          driver_f(event_f -> handler_f) (not readable)
  │   └── dsl_g.rb          driver_g(event_g -> handler_g)
  ├── dir_8
  │   ├── dir_9 (not readable)
  │   │   └── dsl_h.rb     driver_h(event_h -> handler_h)
  │   └── dir_10 
  │   │   └── dsl_i.rb     driver_i(event_i -> handler_i)
  ├── dir_11
  │   ├── dir_12 (not readable)
  │   │   └── dsl_j.rb     driver_j(event_j -> handler_j)
  │   ├── dir_13
  │   │   └── dsl_k.rb     driver_k(event_k -> handler_k)
  │   ├── dir_14
  │   │   └── dsl_l.rb     driver_l(event_l -> handler_l) (not readable)
  │   ├── dsl_m.rb          driver_m(event_m -> handler_m)
  │   └── dsl_n.rb          driver_n(event_n -> handler_n) (not readable)
  ├── error_in_event_driver.rb
  ├── error_not_in_event_driver.rb
  ├── error_on_execute.rb
  ├── no_event_driver.rb
  └── no_event_handler.rb


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

    もし "Tengineコアプロセス"を起動を行うために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_1/dir_2/dsl_a.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver_a  |有効|

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

  シナリオ: [正常系]アプリケーション開発者がディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_1/dir_2"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_1/dir_2"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver_a  |有効|

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントハンドラ実行時にエラーとなるイベントハンドラ定義を指定してTengineコアを起動する
  前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/error_on_execute.rb"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/error_on_execute.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver_err  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "event_err"の"発火"リンクをクリックする
    ならば "event_errを発火しました"と表示されていること 
    ならば "Tengineコアプロセス"のコンソールに"error"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントドライバが1つもないイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/no_event_driver.rb"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/no_event_driver.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"warning"と表示されていること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ イベントドライバが登録されていないこと

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントハンドラが1つもないイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/no_event_handler.rb"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/no_event_handler.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"warning"と表示されていること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ イベントドライバが登録されていないこと

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントドライバ内にシンタックスエラーとなるイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/error_in_event_driver.rb"が存在すること
   
    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/error_in_event_driver.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントドライバ外にシンタックスエラーとなるイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/error_not_in_event_driver.rb.rb"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/error_not_in_event_driver.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が存在しないイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dsl_not_exist.rb"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dsl_not_exist.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が存在しないディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_not_exist.rb"が存在しないこと

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_not_exist"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が中にファイルが存在しないディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_1/dir_3"が存在しないこと

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/dir_4/dir_3/"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"warning"と表示されていること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ イベントドライバが登録されていないこと

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]階層になったディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_1"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_1"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver_a  |有効|
    |  driver_b  |有効|
    |  driver_e  |有効|

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限がないイベントハンドラ定義ファイルを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_7/dsl_f.rb"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_7/dsl_f.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限がないディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_8/dir_9"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_8/dir_9"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限があるイベントハンドラ定義ファイルと読込権限がないイベントハンドラ定義ファイルが混在しているディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_7"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_7"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限があるディレクトリと読込権限がないディレクトリが混在しているディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_8"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_8"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限があるディレクトリに読込権限がないイベントハンドラ定義ファイルがあるディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_11/dir_14"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_11/dir_14"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]読込権限が複雑に設定されている階層になったディレクトリを指定してTengineコアを起動する
    前提 イベントハンドラ定義ファイル"./features/usecases/コア/dsls/try_dsl/dir_11"が存在すること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./features/usecases/コア/dsls/try_dsl/dir_11"というコマンドを実行する
    かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること
