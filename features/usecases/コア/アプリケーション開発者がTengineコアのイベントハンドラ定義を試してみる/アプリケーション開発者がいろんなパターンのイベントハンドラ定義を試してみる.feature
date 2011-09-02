#language:ja
機能: アプリケーション開発者がいろんなパターンのイベントハンドラ定義を試してみる
  [Tengineの導入を検討]するために
  [アプリケーション開発者]
  は [いろいろなパターンのイベントハンドラ定義を登録] したい
	{アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる}のNo.72-84までを確認するためのテストである

	背景:
    前提 DBパッケージのインストールおよびセットアップが完了している
    かつ キューパッケージのインストールおよびセットアップが完了している
    かつ Tengineコアパッケージのインストールおよびセットアップが完了している
    かつ Tengineコンソールパッケージのインストールおよびセットアップが完了している
    かつ DBプロセスが起動している
    かつ キュープロセスが起動している
    かつ Tengineコアのプロセスが停止している
    かつ Tengineコンソールのプロセスが起動している
		かつ "./feature/event_handler_def/uc01_execute_processing_for_event.rb"というファイルが存在する
		
  シナリオ: [正常系]アプリケーション開発者がイベントハンドラ定義ファイルを指定してTengineコアを起動する
		前提 "./feature/event_handler_def/uc01_execute_processing_for_event.rb"というファイルが存在する
			
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
		ならば "Tengineコアプロセス"が起動していること

		もし "イベントドライバ一覧画面"を表示する
		ならば "イベントドライバ一覧画面"を表示していること
		かつ "driver01"と表示されていること

		もし "Tengineコアプロセス"を Ctl+c で停止する
		ならば "Tengineコアプロセス"が停止していること

  シナリオ: [正常系]アプリケーション開発者がディレクトリを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_dir/"というディレクトリが存在する
	
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
		ならば "Tengineコアプロセス"が起動していること

		もし "イベントドライバ一覧画面"を表示する
		ならば "イベントドライバ一覧画面"を表示していること
		かつ "driver01"と表示されていること

		もし "Tengineコアプロセス"を Ctl+c で停止する
		ならば "Tengineコアプロセス"が停止していること


  シナリオ: [正常系]アプリケーション開発者がイベントハンドラ実行時にエラーとなるイベントハンドラ定義を指定してTengineコアを起動する
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
		ならば "Tengineコアプロセス"が起動していること

		もし "イベントドライバ一覧画面"を表示する
		ならば "イベントドライバ一覧画面"を表示していること
		かつ "driver01"と表示されていること

		もし "イベント発火画面"を表示する
		ならば "イベント発火画面"を表示していること

		もし "event01"の"発火"リンクをクリックする
		ならば "event01を発火しました"と表示されていること 
		ならば "Tengineコアプロセス"のコンソールに"error"と表示されていること

		もし "Tengineコアプロセス"を Ctl+c で停止する
		ならば "Tengineコアプロセス"が停止していること


  シナリオ: [異常系]アプリケーション開発者がイベントドライバが1つもないイベントハンドラ定義ファイルを指定してTengineコアを起動する
		前提 "./feature/event_handler_def_dir/xxxxxxxx.rb"というファイルが存在する
		# TODO : ファイル指定
			
		もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def_dir/xxxxxxxx.rb"というコマンドを実行する
		ならば "Tengineコアプロセス"のコンソールに"warning"と表示されていること
		ならば "Tengineコアプロセス"が起動していること

		もし "イベントドライバ一覧画面"を表示する
		ならば "イベントドライバ一覧画面"を表示していること
		かつ イベントドライバが登録されていないこと

		もし "Tengineコアプロセス"を Ctl+c で停止する
		ならば "Tengineコアプロセス"が停止していること

