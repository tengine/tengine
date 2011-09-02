#language:ja
機能: アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる
  [Tengineの導入を検討]するために
  [アプリケーション開発者]
  は [Tengineを評価] したい
  {アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる}のユースケースのうち、No.5,6,7を確認するためのテストである

  背景:
    前提 DBパッケージのインストールおよびセットアップが完了している
    かつ キューパッケージのインストールおよびセットアップが完了している
    かつ Tengineコアパッケージのインストールおよびセットアップが完了している
    かつ Tengineコンソールパッケージのインストールおよびセットアップが完了している
    かつ DBプロセスがコマンド"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"で起動している
    かつ キュープロセスが起動している
    かつ Tengineコアのプロセスが停止している
    かつ Tengineコンソールのプロセスが停止している
    かつ "./feature/event_handler_def/uc01_execute_processing_for_event.rb"というファイルが存在する
		
  シナリオ:  [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する
    もし "Tengineコンソールプロセス"を起動を行うために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動を行うために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント発火画面が表示されない_Tengineコンソールが起動してない
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctl+c で停止する
    ならば "Tengineコンソール"のプロセスが停止していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_キューが起動していない
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    


    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためキュープロセスを停止する
    もし キューを停止する
    ならば キューが停止していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"キューへの接続に失敗しました"と表示されていること

    # 復旧させるためにキューを起動する
    もし キューを起動する
    ならば キューが起動していること

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントキューが存在しない
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|


    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためイベントキューを削除する
    もし イベントキューを削除する
    ならば イベントキューを削除していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"イベントキューが存在しません"と表示されていること 

    # 復旧させるためにコアプロセスを停止し、起動する
    もし "Tengineコア"を Ctl+c で停止する
    ならば "Tengineコア"のプロセスが停止していること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|


    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントエクスチェンジがバインディングされていない
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためイベントキューをアンバインドする
    もし イベントキューをアンバインドする
    ならば イベントキューをアンバインドしていること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    # 復旧させるためにコアプロセスを停止し、起動する
    もし "Tengineコア"を Ctl+c で停止する
    ならば "Tengineコア"のプロセスが停止していること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントエクスチェンジが存在しない
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためイベントエクスチェンジを削除する
    もし イベントエクスチェンジを削除する
    ならば イベントエクスチェンジを削除していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"イベントエクスチェンジが存在しません"と表示されていること 
 
    # 復旧させるためにコアプロセスを停止し、起動する
    もし "Tengineコア"を Ctl+c で停止する
    ならば "Tengineコア"のプロセスが停止していること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_Tengineコンソールが起動してない
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 
    ならば "railsのログ"に"プロセスが停止したログ"が含まれていること

    # 復旧させるためにTengineコンソールのプロセスを再度起動して処理を再度行う
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_DBが起動していない
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためDBを停止する
    もし DBを停止するために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js""というコマンドを実行する
    ならば DBが停止していることを"ps -eo pid PID"で確認できること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されていないこと
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていないこと

    もし "プロセスログ"を表示する
    ならば "プロセスログ"に"DBが終了しました"と表示していること

    # 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_Tengineコアのコードにバグがあった場合
    前提 Tengineコアのコードにバグがある_(保留)

    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "Tengineユーザグループ、またはTengineサポート窓口に問い合わせを行ってください。"と表示されていること

    #(保留)
    もし "プロセスログ"を表示する
    ならば "Tengineコアプロセス"の標準出力に"異常終了しました"と表示していること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_DBが停止したことが原因でTengineコアが停止した
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためDB停止する
    もし DBを停止するために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js""というコマンドを実行する
    ならば DBが停止していることを"ps -eo pid PID"で確認できること


    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されていないこと
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていないこと

    # 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_Tengineコアが停止した
    もし "Tengineコンソールプロセス"を起動するために"rails -s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためTengineコアを停止する
    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "event_type"に"event01"と入力する
    かつ "sourch_name"に"tengine_console"と入力する
    かつ "occurred_at"に"2011/09/01 12:00:00"と入力する
    かつ "notification_level"から"info"を選択する
    かつ "sender_name"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること 

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されていないこと
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていないこと

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること    

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |TRUE      |tengine_console|       |
 
    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンールプロセス"が停止していることを"ps -eo pid PID"で確認できること
