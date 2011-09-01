#language:ja
機能: アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる
  [Tengineの導入を検討]するために
  [アプリケーション開発者]
  は [Tengineを評価] したい

	背景:
    前提 DBのインストールおよびセットアップが完了している
    かつ キューのインストールおよびセットアップが完了している
    かつ Tengineコアのインストールおよびセットアップが完了している
    かつ Tengineコンソールのインストールおよびセットアップが完了している
    かつ DBが起動している
    かつ キューが起動している
    かつ Tengineコアのプロセスが停止している
    かつ Tengineコンソールのプロセスが停止している
			
  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する
	  もし "Tengineコンソール"を起動するために""というコマンドを実行する
		ならば "Tengineコンソール"のプロセスが起動していること

		もし "./feature/event_handler_def/uc01_execute_processing_for_event.rb"というイベントハンドラ定義を作成する
		ならば "./feature/event_handler_def/uc01_execute_processing_for_event.rb"というファイルが存在する

		もし "Tengineコア"を起動するために"tengined -k load -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
		ならば "Tengineコア"のコンソールに"load success"と出力されていること

		もし "Tengineコア"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
		ならば "Tengineコア"のプロセスが起動していること

		もし "イベントドライバ管理画面"を表示する
		ならば "イベントドライバ管理画面"を表示していること
		かつ "driver01"と表示されていること

		もし "イベント発火画面"を表示する
		ならば "イベント発火画面"を表示していること

		もし "event01"の"発火"リンクをクリックする
		ならば "event01が発火された"と表示されていること 
		ならば Tengineコアのコンソールに"handler01"と表示されていること

		もし "Tengineコア"を Ctl+c で停止する
		ならば "Tengineコア"のプロセスが停止していること

		もし "Tengineコンソール"を Ctl+c で停止する
		ならば "Tengineコンソール"のプロセスが停止していること

