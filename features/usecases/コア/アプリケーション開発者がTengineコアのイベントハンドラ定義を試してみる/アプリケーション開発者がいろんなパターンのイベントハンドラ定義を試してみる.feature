#language:ja
機能: アプリケーション開発者がいろんなパターンのイベントハンドラ定義を試してみる
  [Tengineの導入を検討]するために
  [アプリケーション開発者]
  は [いろいろなパターンのイベントハンドラ定義を登録] したい
	{アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる}のNo.72-84までの基本コースと代替コースを確認するためのテストである
	テスト中に使用しているファイル、ディレクトリの構成は以下のとおり
  	.
  ├── dir_4
  │   ├── dir_1
  │   │   └── dsl_a.rb driver_a(event_a -> handler_a)
  │   ├── dir_3
  │   └── dsl_c.rb driver_c(event_c -> handler_c)
  ├── dir_8             (readable)
  │   ├── dir_5         (not readable)
  │   │   └── dsl_d.rb (readable) driver_d(event_d -> handler_d)
  │   ├── dir_6         (readable)
  │   │   └── dsl_e.rb (readable) driver_e(event_e -> handler_e)
  │   ├── dir_7         (readable)
  │   │   └── dsl_f.rb (not readable)
  │   ├── dsl_g.rb      (readable) driver_g(event_g -> handler_g)
  │   └── dsl_h.rb      (not readable)
  ├── error_test.rb driver_err(event_err -> handler_err)
  ├── no_event_driver_test.rb
  └── no_event_handler_test.rb


	背景:
    前提 DBパッケージのインストールおよびセットアップが完了している
    かつ キューパッケージのインストールおよびセットアップが完了している
    かつ Tengineコアパッケージのインストールおよびセットアップが完了している
    かつ Tengineコンソールパッケージのインストールおよびセットアップが完了している
    かつ DBプロセスがコマンド"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"で起動している
    かつ キュープロセスが起動している
    かつ Tengineコアのプロセスが停止している
    かつ Tengineコンソールのプロセスが停止している
		
  シナリオ: [正常系]アプリケーション開発者がイベントハンドラ定義ファイルを指定してTengineコアを起動する
		前提 "./feature/event_handler_def/uc01_execute_processing_for_event.rb"というファイルが存在する
			
    もし "Tengineコアプロセス"を起動を行うために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

		もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

  シナリオ: [正常系]アプリケーション開発者がディレクトリを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/dir_4/dir_1/"というディレクトリが存在する
	
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_dir/dir_4/dir_1"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver_a  |有効|

		もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントハンドラ実行時にエラーとなるイベントハンドラ定義を指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/error_test.rb"というファイルが存在する

		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/error_test.rb"というコマンドを実行する
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
		前提 "./feature/event_handler_def_test_dir/no_event_driver_test.rb"というファイルが存在する
		# TODO : ファイル構成と内容の整理
			
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/no_event_driver_test.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
		かつ "Tengineコアプロセス"のコンソールに"warning"と表示されていること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

		もし "イベントドライバ一覧画面"を表示する
		ならば "イベントドライバ一覧画面"を表示していること
		かつ イベントドライバが登録されていないこと

		もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者がイベントハンドラが1つもないイベントハンドラ定義ファイルを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/no_event_handler_test.rb"というファイルが存在する
			
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/no_event_handler_test.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
		かつ "Tengineコアプロセス"のコンソールに"warning"と表示されていること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

		もし "イベントドライバ一覧画面"を表示する
		ならば "イベントドライバ一覧画面"を表示していること
		かつ イベントドライバが登録されていないこと

		もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者がシンタックスエラーとなるイベントハンドラ定義ファイルを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/syntax_error_test.rb"というファイルが存在する
			
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/syntax_error_test.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
		かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が存在しないイベントハンドラ定義ファイルを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/dsl_b.rb"というファイルが存在しない
			
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/dsl_b.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
		かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が存在しないディレクトリを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/dir_2/"というディレクトリが存在しない

		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/dir_2/"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
		かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が中にファイルが存在しないディレクトリを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/dir_4/dir_3/"というディレクトリが存在する
		かつ "./feature/event_handler_def_test_dir/dir_4/dir_3/"というディレクトリには0個のファイルが含まれている
			
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
		前提 "./feature/event_handler_def_test_dir/dir_4/"というディレクトリが存在する
	
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/dir_4/"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver_a  |有効|
    |  driver_c  |有効|
		
		もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限がないイベントハンドラ定義ファイルを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/dir_8/dsl_g.rb"というファイルが存在する
		かつ "./feature/event_handler_def_test_dir/dir_8/dsl_g.rb"というファイルの読込権限がない

		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/dir_8/dsl_g.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
		かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]アプリケーション開発者が読込権限がないディレクトリを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/dir_8/dir_5/"というディレクトリが存在する
		かつ "./feature/event_handler_def_test_dir/dir_8/dir_5/"というディレクトリの読込権限がない

		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/dir_8/dir_5/"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
		かつ "Tengineコアプロセス"のコンソールに"error"と表示されていること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系]読込権限が複雑に設定されている階層になったディレクトリを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_test_dir/dir_8/"というディレクトリが存在する
	
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_test_dir/dir_8/"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver_e  |有効|
    |  driver_g  |有効|

		もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること


