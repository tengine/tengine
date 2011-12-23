#language:ja
機能: アプリケーション開発者がTengineコアが運用に耐えられるか検証する
  [Tengineの導入を検討]するために
  [アプリケーション開発者]
  は [Tengineコアを評価] したい


  背景:
	  # 前提 "Tengineコアプロセス"が起動していないこと
    # かつ "DBプロセス"が起動している
    # かつ "キュープロセス"が起動している
    # かつ "Tengineリソースウォッチャプロセス"が起動している


  シナリオ: [異常系]仮想サーバの起動する前に片系のTengineコアプロセスを強制的に停止する

    前提 仮想サーバが起動していないこと
	
    もし "仮想サーバ一覧"画面を表示する
    # 仮想サーバが起動していないことを確認します
    # 物理サーバ名は実際の環境に応じて読み替えてください
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|仮想サーバは起動していません。|||||||
	
	  # tenginedのプロセスを2つ起動します。起動したプロセスをそれぞれ"TengineコアプロセスA","TengineコアプロセスB"と呼ぶことにします。
    もし "TengineコアプロセスA"の起動を行うために"tengined -T ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する
    かつ "TengineコアプロセスB"の起動を行うために"tengined -T ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する
	
    # 片系のtenginedプロセスをkillし、tenginedを強制的に停止する
		もし "TengineコアプロセスB"のPIDを確認する
    かつ "TengineコアプロセスB"を"kill -9 #{PID}"で強制停止する

		# イベント処理が行われることを確認して、フェイルオーバーしたことを確認します。
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること
    もし "種別名"に"handler01"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "handler01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する     
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    | 種別名    |
    | handler01|
		
    # フェイルバックを行います。
		# kill -9 で強制停止した場合、pidファイルが残ってしまうので削除する必要があります。
		# ./tmp/tengined_pids/tengined.*.pid を開きPIDを確認して、強制停止したプロセスのPIDファイルを削除してください
    もし  強制停止を行ったTengineコアプロセスのPIDファイルを削除する
		# Tengineコアプロセスを起動します。"TengineコアプロセスC"と呼ぶことにします。
    もし "TengineコアプロセスC"の起動を行うために"tengined --tengined-skip-load -T ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する


		# フェイルバックで起動したTengineコアプロセスでイベント処理が行われることを確認して、フェイルバックしたことを確認します。
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること
    もし "種別名"に"handler01"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "handler01を発火しました"と表示されていること

    ならば "TengineコアプロセスC"の標準出力に"handler01"と表示されること
		# タイミング次第で"TengineコアプロセスA"でイベント処理が行われる場合があります。
		# そのときは、"TengineコアプロセスC"イベント処理が行われることが確認できるまで、
		# 1０回程度は、種別名"handler01"のイベントを発火してください。
		
    もし "イベント通知画面"を表示する     
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    | 種別名    |
    | handler01|

		

  シナリオ: [異常系]仮想サーバの起動中にTengineコアプロセスを強制的に停止する
    # 強制停止した片系のTengineコアプロセスを再度起動する
    # 「仮想サーバ一覧」を開く。
    # 「仮想サーバ一覧」から、「仮想サーバを起動」ボタンを押下し、「仮想サーバ起動」画面に遷移する
    # 「仮想サーバ起動」画面から物理サーバ名、仮想サーバ名、仮想サーバイメージ名、インスタンスタイプ、起動サーバ数を入力して「起動ボタン」を押下する
    # 「仮想サーバ一覧」で起動した仮想サーバが起動中であることを確認する
    # スクリプトの実行中に片系のtenginedプロセスをkillし、tenginedを強制的に停止する
    # 「イベント発火」でイベントを発火する
    # 「イベント一覧」でイベントを発火したことを確認する

    # 「仮想サーバ一覧」で起動した仮想サーバが稼働中であることを確認する
    # 「イベント一覧」で仮想サーバのステータスが変更されたイベントを確認する


    前提 仮想サーバが起動していないこと

	  # tenginedのプロセスを2つ起動します。起動したプロセスをそれぞれ"TengineコアプロセスA","TengineコアプロセスB"と呼ぶことにします。
    もし "TengineコアプロセスA"の起動を行うために"tengined -T ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する
    かつ "TengineコアプロセスB"の起動を行うために"tengined -T ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する

    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # 物理サーバ名は実際の環境に応じて読み替えてください
    # また、環境によってはすでに仮想サーバが起動しています
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|仮想サーバは起動していません。|||||||

    # 起動可能数の確認
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    ならば "起動可能数"を確認する # 後に実行する仮想サーバ起動の後に起動可能数が増加することを確認します

    # 仮想サーバを3台起動
    もし "仮想サーバ名"に"run_3_virtual_servers"と入力する
    かつ "物理サーバ名"に"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"に"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "起動サーバ数"に3を選択する
    かつ "説明"に"仮想サーバを3台起動テストの説明"と入力する
    かつ "起動"ボタンをクリックする
    ならば tengine_console のログに以下の文言が表示されること
    """
    Tama::Controllers::TamaTestController#run_instances("virtual_server_image_uuid_01", 3, 3, [], nil, "", nil, "virtual_server_spec_uuid_01", nil, nil, "physical_server_uuid_01", nil)
    """
    ならば "仮想サーバ起動結果"画面が表示されること
    かつ  "仮想サーバ起動結果"画面に以下の表示があること
    virtual_server_uuid_01
    virtual_server_uuid_02
    virtual_server_uuid_03
    もし "閉じる"ボタンを押下する
    ならば "仮想サーバ一覧"画面が表示されていること


    # 片系のtenginedプロセスをkillし、tenginedを強制的に停止する
		もし "TengineコアプロセスB"のPIDを確認する
    かつ "TengineコアプロセスB"を"kill -9 #{PID}"で強制停止する

		# イベント処理が行われることを確認して、フェイルオーバーしたことを確認します。
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること
    もし "種別名"に"handler01"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "handler01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する     
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    | 種別名    |
    | handler01|


    # 起動後の画面状態を確認
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # ステータスがrunningになるまで時間がかかります(環境によって異なります)
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_3_virtual_servers001|virtual_server_uuid_01|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.1|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers002|virtual_server_uuid_02|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.2|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers003|virtual_server_uuid_03|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.3|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

    # 起動イベントの確認
    もし"イベント一覧"画面を表示する
    ならば "種別名"に"Tengine::Resource::VirtualServer.updated.tengine_resource_watchd"のイベントが3件表示されていること


		
    # フェイルバックを行います。
		# kill -9 で強制停止した場合、pidファイルが残ってしまうので削除する必要があります。
		# ./tmp/tengined_pids/tengined.*.pid を開きPIDを確認して、強制停止したプロセスのPIDファイルを削除してください
    もし  強制停止を行ったTengineコアプロセスのPIDファイルを削除する
		# Tengineコアプロセスを起動します。"TengineコアプロセスC"と呼ぶことにします。
    もし "TengineコアプロセスC"の起動を行うために"tengined --tengined-skip-load -T ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する


		# フェイルバックで起動したTengineコアプロセスでイベント処理が行われることを確認して、フェイルバックしたことを確認します。
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること
    もし "種別名"に"handler01"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "handler01を発火しました"と表示されていること

    ならば "TengineコアプロセスC"の標準出力に"handler01"と表示されること
		# タイミング次第で"TengineコアプロセスA"でイベント処理が行われる場合があります。
		# そのときは、"TengineコアプロセスC"イベント処理が行われることが確認できるまで、
		# 1０回程度は、種別名"handler01"のイベントを発火してください。
		
    もし "イベント通知画面"を表示する     
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    | 種別名    |
    | handler01|

		

  シナリオ: [異常系]仮想サーバを起動した後にTengineコアプロセスを強制的に停止する

    前提 仮想サーバが1台起動していること
	
    もし "仮想サーバ一覧"画面を表示する
    # 仮想サーバが起動していないことを確認します
    # 物理サーバ名は実際の環境に応じて読み替えてください
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_3_virtual_servers001|virtual_server_uuid_01|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.1|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers002|virtual_server_uuid_02|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.2|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers003|virtual_server_uuid_03|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.3|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

	
	  # tenginedのプロセスを2つ起動します。起動したプロセスをそれぞれ"TengineコアプロセスA","TengineコアプロセスB"と呼ぶことにします。
    もし "TengineコアプロセスA"の起動を行うために"tengined -T ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する
    かつ "TengineコアプロセスB"の起動を行うために"tengined -T ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する
	
    # 片系のtenginedプロセスをkillし、tenginedを強制的に停止する
		もし "TengineコアプロセスB"のPIDを確認する
    かつ "TengineコアプロセスB"を"kill -9 #{PID}"で強制停止する

		# イベント処理が行われることを確認して、フェイルオーバーしたことを確認します。
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること
    もし "種別名"に"handler01"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "handler01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する     
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    | 種別名    |
    | handler01|
		
    # フェイルバックを行います。
		# kill -9 で強制停止した場合、pidファイルが残ってしまうので削除する必要があります。
		# ./tmp/tengined_pids/tengined.*.pid を開きPIDを確認して、強制停止したプロセスのPIDファイルを削除してください
    もし  強制停止を行ったTengineコアプロセスのPIDファイルを削除する
		# Tengineコアプロセスを起動します。"TengineコアプロセスC"と呼ぶことにします。
    もし "TengineコアプロセスC"の起動を行うために"tengined --tengined-skip-load -T ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する


		# フェイルバックで起動したTengineコアプロセスでイベント処理が行われることを確認して、フェイルバックしたことを確認します。
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること
    もし "種別名"に"handler01"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "handler01を発火しました"と表示されていること

    ならば "TengineコアプロセスC"の標準出力に"handler01"と表示されること
		# タイミング次第で"TengineコアプロセスA"でイベント処理が行われる場合があります。
		# そのときは、"TengineコアプロセスC"イベント処理が行われることが確認できるまで、
		# 1０回程度は、種別名"handler01"のイベントを発火してください。
		
    もし "イベント通知画面"を表示する     
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    | 種別名    |
    | handler01|

