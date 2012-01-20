#language:ja
機能: アプリケーション運用者がtengine_atdがフェイルオーバーした後にフェイルバックする

  tengine_atdがダウンした際に、
  アプリケーション運用者
  は、フェイルオーバーしていることを確認した後、フェイルバックを行いたい

  背景:tengine_atdプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がtengine_atdプロセスをフェールバックする
    前提 "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している
    かつ テンプレートジョブが1件も登録されていない
    かつ 実行ジョブが1件もない
    かつ イベントが1件もない
    かつ 仮想サーバがインスタンス識別子:"test_server1"で登録されていること
    かつ 認証情報が名称:"test_credential1"で登録されている
    かつ イベントキューにメッセージが1件もない
    かつ atd.yml.erbに以下の設定がされてる
    process:
      daemon:  true
      pid_dir: "/tmp/tengine_test/pids"
    かつ /tmp/tengine_test/pidsディレクトリが存在する
    # mkdir -p /tmp/tengine_test/pids
    かつ "tengine_atdプロセス"が2台のサーバで起動している
    かつ サーバ1で起動しているtengine_atdプロセスを"atd1"と呼ぶ
    かつ サーバ2で起動しているtengine_atdプロセスを"atd2"と呼ぶ
    かつ atd1が動作しているサーバのIPを"atd1_ip"と呼ぶ
    かつ atd2が動作しているサーバのIPを"atd2_ip"と呼ぶ
    かつ atd1のPIDを"atd1_pid"と呼ぶ
    かつ atd2のPIDを"atd2_pid"と呼ぶ


  @success
  @1000
  シナリオ: [異常系]ジョブのスクリプト実行中にtengine_atdのプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がtengine_atdプロセスをフェールバックする

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし "仮想サーバ一覧画面"を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|仮想サーバは起動していません。|||||||

    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること

    もし "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "仮想サーバ名"に"run_virtual_servers"と入力する
    かつ "物理サーバ名"に"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"に"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "起動サーバ数"に1を選択する
    かつ "説明"に"仮想サーバを1台起動テストの説明"と入力する
    かつ "起動"ボタンをクリックする
    ならば "仮想サーバ起動結果"画面が表示されること
    かつ  "仮想サーバ起動結果"画面に以下の表示があること
    virtual_server_uuid_01

    もし "閉じる"ボタンを押下する
    ならば "仮想サーバ一覧"画面が表示されていること

    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # ステータスがstartingになるまで時間がかかります(環境によって異なります)
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_1_virtual_servers001|virtual_server_uuid_01|仮想サーバを1台起動テストの説明|private_ip_address: 192.168.1.1|starting|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

   もし atd1をダウンさせるために"ssh root@#{atd1_ip} command \"kill -9 #{atd1_pid}\""コマンドを実行する
   かつ 10秒間待機する
   かつ atd1がダウンしているか確認するために"ssh root@#{atd1_ip} command \"ps aux|grep tengine_atd|grep -v grep\""コマンドを実行する
   ならば atd1がダウンしていること

   もし 120秒間待機する
   かつ "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # ステータスがrunningになるまで時間がかかります(環境によって異なります)
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_1_virtual_servers001|virtual_server_uuid_01|仮想サーバを1台起動テストの説明|private_ip_address: 192.168.1.1|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

   もし tengine_atdプロセスを起動しなおすために"ssh root@#{atd1_ip} command \"rm -rf /tmp/tengine_test/pids/tengine_atd0.pid && cd #{tengine_atdのデプロイ先のパス} && bundle exec tengine_atd -k start -f config/atd.yml.erb\""コマンドを実行する
   かつ tengine_atdプロセスが起動していることを確認するために"ssh root@#{atd1_ip} command \"ps aux|grep tengine_atd|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   ならば tengine_atdプロセスが起動していること

   #これでシナリオを終了する
   #このシナリオの最後の状態は、MongoDBが正しく動く状態となっているため、再度ジョブを流し直す必要はありません

