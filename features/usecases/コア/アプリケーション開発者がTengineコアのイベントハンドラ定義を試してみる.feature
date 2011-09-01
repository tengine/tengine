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


  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント発火画面が表示されない_Tengineコンソールが起動してない
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

		# 異常を発生させるためTengineコンソールのプロセスを停止する
		もし "Tengineコンソール"を Ctl+c で停止する
		ならば "Tengineコンソール"のプロセスが停止していること

		もし "イベント発火画面"を表示する
		ならば "イベント発火画面"を表示していないこと
		ならば "railsのログ"の"Tengineコンソールのログ"に"プロセスが停止したログ"が含まれていること

		# 復旧させるためにTengineコンソールのプロセスを再度起動して処理を再度行う
	  もし "Tengineコンソール"を起動するために""というコマンドを実行する
		ならば "Tengineコンソール"のプロセスが起動していること

		もし "イベント発火画面"を表示する
		ならば "イベント発火画面"を表示していること

		もし "event01"の"発火"リンクをクリックする
		ならば "event01が発火された"と表示されていること 
		ならば Tengineコアのコンソールに"handler01"と表示されていること

		もし "Tengineコア"を Ctl+c で停止する
		ならば "Tengineコア"のプロセスが停止していること

		もし "Tengineコンソール"を Ctl+c で停止する
		ならば "Tengineコンソール"のプロセスが停止していること


  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_キューが起動していない
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

		# 異常を発生させるためキュープロセスを停止する
		もし キューを停止する
		ならば キューが停止していること

		もし "event01"の"発火"リンクをクリックする
		ならば "キューへの接続に失敗しました"と表示されてないこと

		# 復旧させるためにキューを起動する
		もし キューを起動する
		ならば キューが起動していること

		もし "イベント発火画面"を表示する
		ならば "イベント発火画面"を表示していること

		もし "event01"の"発火"リンクをクリックする
		ならば "event01が発火された"と表示されていること 
		ならば Tengineコアのコンソールに"handler01"と表示されていること

		もし "Tengineコア"を Ctl+c で停止する
		ならば "Tengineコア"のプロセスが停止していること

		もし "Tengineコンソール"を Ctl+c で停止する
		ならば "Tengineコンソール"のプロセスが停止していること


  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントキューが存在しない
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

		# 異常を発生させるためイベントキューを削除する
		もし イベントキューを削除する
		ならば イベントキューを削除していること

		もし "event01"の"発火"リンクをクリックする
		ならば "イベントキューが存在しません"と表示されていること

		# 復旧させるためにコアプロセスを停止し、起動する
		もし "Tengineコア"を Ctl+c で停止する
		ならば "Tengineコア"のプロセスが停止していること

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



  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントエクスチェンジがバインディングされていない
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

		# 異常を発生させるためイベントキューをアンバインドする
		もし イベントキューをアンバインドする
		ならば イベントキューをアンバインドしていること

		もし "event01"の"発火"リンクをクリックする
		ならば "イベントエクスチェンジがバインディングされていません。"と表示されていること

		# 復旧させるためにコアプロセスを停止し、起動する
		もし "Tengineコア"を Ctl+c で停止する
		ならば "Tengineコア"のプロセスが停止していること

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


  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントエクスチェンジが存在しない
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

		# 異常を発生させるためイベントエクスチェンジを削除する
		もし イベントエクスチェンジを削除する
		ならば イベントエクスチェンジを削除していること

		もし "event01"の"発火"リンクをクリックする
		ならば "イベントエクスチェンジが存在しません。"と表示されていること

		# 復旧させるためにコアプロセスを停止し、起動する
		もし "Tengineコア"を Ctl+c で停止する
		ならば "Tengineコア"のプロセスが停止していること

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


  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_Tengineコンソールが起動してない
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

		# 異常を発生させるためTengineコンソールのプロセスを停止する
		もし "Tengineコンソール"を Ctl+c で停止する
		ならば "Tengineコンソール"のプロセスが停止していること

		もし "event01"の"発火"リンクをクリックする
		ならば "イベント発火画面"を表示していないこと
		ならば "railsのログ"の"Tengineコンソールのログ"に"プロセスが停止したログ"が含まれていること

		# 復旧させるためにTengineコンソールのプロセスを再度起動して処理を再度行う
	  もし "Tengineコンソール"を起動するために""というコマンドを実行する
		ならば "Tengineコンソール"のプロセスが起動していること

		もし "イベント発火画面"を表示する
		ならば "イベント発火画面"を表示していること

		もし "event01"の"発火"リンクをクリックする
		ならば "event01が発火された"と表示されていること 
		ならば Tengineコアのコンソールに"handler01"と表示されていること

		もし "Tengineコア"を Ctl+c で停止する
		ならば "Tengineコア"のプロセスが停止していること

		もし "Tengineコンソール"を Ctl+c で停止する
		ならば "Tengineコンソール"のプロセスが停止していること


  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_DBが起動していない
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

		# 異常を発生させるためDBを停止する
		もし DBを停止する
		ならば DBが停止していること
		
		もし "event01"の"発火"リンクをクリックする
		ならば "event01が発火された"と表示されていること 
		ならば Tengineコアのコンソールに"handler01"と表示されていないこと

		もし "イベントドライバ管理画面"を表示する
		ならば "イベントドライバ管理画面"を表示していること
		かつ "DBへの接続に失敗しました"と表示されていること

		もし "プロセスログ"を表示する
		ならば "プロセスログ"に"DBが終了しました"と表示していること

		# 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
		もし DBを起動する
		ならば DBが起動していること

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


  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_Tengineコアのコードにバグがあった場合
	  前提 Tengineコアのコードにバグがある
		
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
		ならば Tengineコアのコンソールに"handler01"と表示されていないこと

		もし "イベント通知画面"を表示する
		ならば "イベント通知画面"を表示していること
		かつ "Tengineユーザグループ、またはTengineサポート窓口に問い合わせを行ってください。"と表示されていること

		もし "プロセスログ"を表示する
		ならば "プロセスログ"に"異常終了しました"と表示していること


  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_DBが停止したことが原因でTengineコアが停止した
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

		# 異常を発生させるためDBを停止する
		もし DBを停止する
		ならば DBが停止していること

		もし "event01"の"発火"リンクをクリックする
		ならば "event01が発火された"と表示されていること 
		ならば Tengineコアのコンソールに"handler01"と表示されてないこと

		もし "プロセスログ"を表示する
		ならば "プロセスログ"に"DBが終了しました"と表示していること

		# 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
		もし DBを起動する
		ならば DBが起動していること

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


  シナリオ: アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_Tengineコアが停止した
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

		# 異常を発生させるためDBを停止する
		もし DBを停止する
		ならば DBが停止していること

		もし "event01"の"発火"リンクをクリックする
		ならば "event01が発火された"と表示されていること 
		ならば Tengineコアのコンソールに"handler01"と表示されてないこと

		もし "プロセスログ"を表示する
		ならば "プロセスログ"に"DBが終了しました"と表示していること

		# 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
		もし DBを起動する
		ならば DBが起動していること

		もし "Tengineコア"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
		ならば "Tengineコア"のプロセスが起動していること

		もし "イベントドライバ管理画面"を表示する
		ならば "イベントドライバ管理画面"を表示していること
		かつ "driver01"と表示されていること

		もし "イベント発火画面"を表示する
		ならば "イベント発火画面"を表示していること

		# 異常を発生させるためTengineコアのプロセスを停止する
		もし "Tengineコア"を Ctl+c で停止する
		ならば "Tengineコア"のプロセスが停止していること

		もし "event01"の"発火"リンクをクリックする
		ならば "event01が発火された"と表示されていること 
		ならば Tengineコアのコンソールに"handler01"と表示されてないこと

		もし "プロセスログ"を表示する
		ならば "プロセスログ"に"Tengineコアが終了しました"と表示していること

		# 復旧させるためにTengineの起動して処理を再度行う
		もし "Tengineコア"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
		ならば "Tengineコア"のプロセスが起動していること
		ならば Tengineコアのコンソールに"handler01"と表示されていること

		もし "Tengineコア"を Ctl+c で停止する
		ならば "Tengineコア"のプロセスが停止していること

		もし "Tengineコンソール"を Ctl+c で停止する
		ならば "Tengineコンソール"のプロセスが停止していること
