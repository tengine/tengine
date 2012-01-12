#language:ja
機能: アプリケーション運用者がイベント一覧画面でハートビートを確認する
  Tengine周辺のコンポーネントの生存状態を確認するために
  アプリケーション運用者
  ハートビートを確認したい

  #
  # 各シナリオのおおまかな流れ
  #   シナリオ: [正常系]アプリケーション運用者がイベント一覧画面で***のハートビートを確認する
  #     * ハートビートと終了イベントを確認します
  #     1. 確認対象のデーモンプロセスを起動
  #     2. イベント一覧画面でハートビートイベントの確認
  #     3. 一定時間後、イベント一覧画面でハートビートイベント発生時刻が変わっていることを確認
  #       * ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用していること
  #     4. 監視対象のデーモンプロセスを終了する
  #     5. イベント一覧画面で終了イベントの確認
  #       * ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用していること
  #   シナリオ: [正常系]アプリケーション運用者がイベント一覧画面で***の不達イベントを確認する
  #     * ハートビートと不達イベントを確認します
  #     1. 確認対象のデーモンプロセスを起動
  #     2. イベント一覧画面でハートビートイベントの確認
  #     3. 監視対象のデーモンプロセスを強制終了する
  #     4. イベント一覧画面で不達イベントの確認
  #       * ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用していること
  #

  # @manual
  # 背景に関しては@manualタグを付けることができないのでコメントアウトしています
  背景:
    前提 日本語でアクセスする
    かつ "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している
    かつ "Tengineコアプロセス"が起動している
    かつ "ハートビートウォッチャプロセス"が起動している
    # cap -f Capfile_daemon production deploy:heartbeat_watchd:start


  ####################
  #
  # tengined
  #
  ####################
  @6001
  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でtenginedのハートビートを確認する
    #
    # 【注意】
    # 以降の手順に書いていますが
    # tenginedの終了イベントを受け取るために、もう1個tenginedを起動する必要があります
    # シナリオではappディレクトリにデプロイされたdslを読み込んで実行しています
    #

    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production

    # tenginedの終了イベントを受け取るためにtengined を追加する
    かつ 以下のコマンドを実行し、"tengined"を起動する
    # tengined -f ./config/tengine.yml.erb -T .app --process-daemon
    かつ 標準出力からPIDを取得する

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # tengined を複数起動ているので、2つのハートビートが送られます
    |種別名                |イベントキー|発生源名       |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |core.heartbeat.tengine|<uuid>      |process:/<PID> |yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|
    |core.heartbeat.tengine|<uuid>      |process:/<PID> |yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用する
    |種別名                 |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名      |
    |core.heartbeat.tengine |<uuid>      |process:/<PID> |yyyy-MM-dd HH:mm:ss+0900 |debug     |true        |process:/<PID>|
    |core.heartbeat.tengine |<uuid>      |process:/<PID> |yyyy-MM-dd HH:mm:ss+0900 |debug     |true        |process:/<PID>|
    かつ "発生時刻"が"+30"秒変更されていること # ハートビートの送信間隔
    かつ "イベントキー"が変更されていないこと

    もし 以下のコマンドを実行し、"tengined"を停止する # 取得したPIDを引数に追加起動したプロセスを停止する
    # kill -2 <PID>

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                       |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名      |
    |core.heartbeat.tengine       |<uuid>      |process:/<PID> |yyyy-MM-dd HH:mm:ss+0900 |debug     |true        |process:/<PID>|
    |finished.process.core.tengine|<uuid>      |process:/<PID> |yyyy-MM-dd HH:mm:ss+0900 |info      |false       |process:/<PID>|
    かつ "イベントキー"が変更されていないこと

  @manual
  @6002
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でtenginedの不達イベントを確認する
    #
    # 【注意】
    # 以降の手順に書いていますが
    # tenginedの不達イベントを受け取るために、もう1個tenginedを起動する必要があります
    # シナリオではappディレクトリにデプロイされたdslを読み込んで実行しています
    #

    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production

    # tenginedの終了イベントを受け取るためにtengined を追加する
    かつ 以下のコマンドを実行し、"tengined"を起動する
    # tengined -f ./config/tengine.yml.erb -T .app --process-daemon
    かつ 標準出力からPIDを取得する

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # tengined を複数起動ているので、2つのハートビートが送られます
    |種別名                 |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名      |
    |core.heartbeat.tengine |<uuid>      |process:/<PID> |yyyy-MM-dd HH:mm:ss+0900 |debug     |true        |process:/<PID>|
    |core.heartbeat.tengine |<uuid>      |process:/<PID> |yyyy-MM-dd HH:mm:ss+0900 |debug     |true        |process:/<PID>|

    もし 以下のコマンドを実行し、"tengined"を強制停止する # 取得したPIDを引数に追加起動したプロセスを停止する
    # kill -9 <PID>

    かつ "tengined.*.pid"ファイルを削除する
    # kill -9 で強制停止した場合、pidファイルが残ってしまうので削除する必要があります
    # ./config/tengined.yml.erb の process:pid_dir にpidファイルの保存先を指定しています
    # 特に設定ファイルを変更していない場合は、以下の場所にあります
    #  => /var/lib/tengine_core/shared/tmp/tengined_pids/
    #  この中から強制停止したPIDが記載されているPIDファイルを削除してください

    もし 120秒待機する # 不達イベントの検知秒数はデフォルトで120秒です

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                        |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |core.heartbeat.tengine        |<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|
    |expired.core.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|error     |false       |process:/<PID>|
    かつ "イベントキー"が変更されていないこと


  ####################
  #
  # ジョブ
  #
  ####################
  @manual
  @6003
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でジョブのハートビートを確認する
    #
    # 【注意】
    # ジョブの実行中に確認、オペレーションをする必要があるため、時間がかかるジョブを実行します
    # シナリオでは tengine_job/examples/0004_retry_one_layer.rb をデプロイしている前提で記述します
    #
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production

    # ジョブの実行
    もし "テンプレートジョブネット一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|説明   |操作     |
    |jn0004        |jn0004 |閲覧 実行|

    もし "ジョブネット名"が"jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること
    かつ "事前実行コマンド"に"export J2_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする

    # ジョブの実行開始確認
    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|
    |jn0004        |実行中    |

    もし 5秒待機する # ハートビートの送信間隔はデフォルトで5秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること
    |種別名               |イベントキー|発生源名          |発生時刻                |通知レベル|通知確認済み|送信者名                              |
    |job.heartbeat.tengine|<uuid>      |job:/<PID>/xxx/xxx|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |agent:<Host名>/<PID>/tengine_job_agent|

    もし 5秒待機する # ハートビートの送信間隔はデフォルトで5秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用する
    |種別名               |イベントキー|発生源名          |発生時刻                |通知レベル|通知確認済み|送信者名                              |
    |job.heartbeat.tengine|<uuid>      |job:/<PID>/xxx/xxx|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |agent:<Host名>/<PID>/tengine_job_agent|
    かつ "発生時刻"が"+5"秒変更されていること # ハートビートの送信間隔
    かつ "イベントキー"が変更されていないこと

    もし 60秒待機する # 実行中のジョブが完了するまで待ちます

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                      |イベントキー|発生源名          |発生時刻                |通知レベル|通知確認済み|送信者名                              |
    |finished.process.job.tengine|<uuid>      |job:/<PID>/xxx/xxx|yyyy-MM-dd HH:mm:ss+0900|info      |false       |agent:<Host名>/<PID>/tengine_job_agent|
    かつ "イベントキー"が変更されていないこと

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名               |イベントキー|発生源名          |発生時刻                |通知レベル|通知確認済み|送信者名                              |
    |job.heartbeat.tengine|<uuid>      |job:/<PID>/xxx/xxx|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |agent:<Host名>/<PID>/tengine_job_agent|

    # ジョブの終了確認
    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|
    |jn0004        |正常終了  |

  @manual
  @6004
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でジョブの不達イベントを確認する
    #
    # 【注意】
    # ジョブの実行中に確認、オペレーションをする必要があるため、時間がかかるジョブを実行します
    # シナリオでは tengine_job/examples/0004_retry_one_layer.rb をデプロイしている前提で記述します
    #
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production

    # ジョブの実行
    もし "テンプレートジョブネット一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|説明   |操作     |
    |jn0004        |jn0004 |閲覧 実行|

    もし "ジョブネット名"が"jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること
    かつ "事前実行コマンド"に"export J2_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする

    # ジョブの実行開始確認
    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|
    |jn0004        |実行中    |

    もし 5秒待機する # ハートビートの送信間隔はデフォルトで5秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること
    |種別名               |イベントキー|発生源名          |発生時刻                |通知レベル|通知確認済み|送信者名                              |
    |job.heartbeat.tengine|<uuid>      |job:/<PID>/xxx/xxx|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |agent:<Host名>/<PID>/tengine_job_agent|

    もし 以下のコマンドを実行し、"tengine_job_agent_watchdog"のPIDを取得する
    # ps -ef | grep tengine_job_agent_watchdog | grep -v grep
    かつ 以下のコマンドを実行し、"tengine_job_agent_watchdog"を強制停止する
    # kill -9 <PID>

    もし 20秒待機する # 不達イベントの検知秒数はデフォルトで20秒です

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                       |イベントキー|発生源名          |発生時刻                |通知レベル|通知確認済み|送信者名                              |
    |expired.job.heartbeat.tengine|<uuid>      |job:/<PID>/xxx/xxx|yyyy-MM-dd HH:mm:ss+0900|error     |false       |agent:<Host名>/<PID>/tengine_job_agent|
    かつ "イベントキー"が変更されていないこと

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名               |イベントキー|発生源名          |発生時刻                |通知レベル|通知確認済み|送信者名                              |
    |job.heartbeat.tengine|<uuid>      |job:/<PID>/xxx/xxx|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |agent:<Host名>/<PID>/tengine_job_agent|

    # ジョブのが実行中であることを確認
    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス                    |
    |jn0004        |実行中[状態が不明なジョブあり]|


  ####################
  #
  # ハートビートウォッチャ
  #
  ####################
  @manual
  @6005
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でハートビートウォッチャのハートビートを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること
    |種別名               |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |hbw.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用する
    |種別名               |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |hbw.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|
    かつ "発生時刻"が"+30"秒変更されていること # ハートビートの送信間隔
    かつ "イベントキー"が変更されていないこと

    もし 以下のコマンドを実行し、"ハートビートウォッチャプロセス"を停止する #Ctrl+cで停止してもいいです
    # bundle exec cap -f Capfile_daemons deploy:heartbeat_watchd:stop

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                      |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |finished.process.hbw.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|info      |false       |process:/<PID>|
    かつ "イベントキー"が変更されていないこと

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名               |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |hbw.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

  @manual
  @6006
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でハートビートウォッチャの不達イベントを確認する
    #
    # 【注意】
    # 以降の手順に書いていますが
    # ハートビートウォッチャのハートビートを監視するためにもう1個ハートビートウォッチャを起動する必要があります
    #

    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production

    # expired.hbw.heartbeat.tengine を発生させるために tengine_heartbeat_watchd を追加する
    かつ 以下のコマンドを実行し、"tengine_heartbeat_watchd"を起動する
    # cap -f Capfile_daemons deploy:heartbeat_watchd:start
    かつ 標準出力からPIDを取得する

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # すでに起動しているプロセスと追加起動したプロセスの2件
    |種別名               |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |hbw.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|
    |hbw.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

    もし 以下のコマンドを実行し、"tengine_heartbeat_watchd"を強制停止する # 取得したPIDを引数に追加起動したプロセスを停止する
    # kill -9 <PID>

    かつ "tengine_heartbeat_watchd*.pid"ファイルを削除する
    # kill -9 で強制停止した場合、pidファイルが残ってしまうので削除する必要があります
    # ./config/heartbeat_watchd.yml.erb の process:pid_dir にpidファイルの保存先を指定しています
    # 特に設定ファイルを変更していない場合は、以下の場所にあります
    #  => /var/lib/tengine_daemons/shared/pids/
    #  この中のtengine_heartbeat_watchd*.pidから強制停止したPIDが記載されているPIDファイルを削除してください

    もし 120秒待機する # 不達イベントを検知する時間はデフォルトで120秒です

    もし "イベント一覧画面"を表示する
    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                       |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |expired.hbw.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|error     |false       |process:/<PID>|
    |hbw.heartbeat.tengine        |<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |false       |process:/<PID>|


  ####################
  #
  # リソースウォッチャ
  #
  ####################
  @manual
  @6007
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でリソースウォッチャのハートビートを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production
    前提 "リソースウォッチャプロセス"が起動している
		# cap -f Capfile_daemons deploy:resource_watchd:start

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること
    |種別名                     |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |resourcew.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用する
    |種別名                     |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |resourcew.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|
    かつ "発生時刻"が"+30"秒変更されていること # ハートビートの送信間隔
    かつ "イベントキー"が変更されていないこと

    もし 以下のコマンドを実行し、"リソースウォッチャプロセス"を停止する #Ctrl+cで停止してもいいです
    # cap -f Capfile_daemon production deploy:resource_watchd:stop

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                            |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |finished.process.resourcew.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|info      |false       |process:/<PID>|
    かつ "イベントキー"が変更されていないこと

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名                     |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |resourcew.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

  @manual
  @6008
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でリソースウォッチャの不達イベントを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production
    かつ "リソースウォッチャプロセス"が起動している
		# cap -f Capfile_daemons deploy:resource_watchd:start

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # すでに起動しているプロセスと追加起動したプロセスの2件
    |種別名                     |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |resourcew.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

    もし 以下のコマンドを実行し、"tengine_resource_watchd"のPIDを取得する
    # ps -ef | grep tengine_resource_watchd | grep -v grep
    かつ 以下のコマンドを実行し、"tengine_resource_watchd"を強制停止する # 追加起動したプロセスを停止する

    # kill -9 <PID>

    かつ "tengine_resourcewd*.pid"ファイルを削除する
    # kill -9 で強制停止した場合、pidファイルが残ってしまうので削除する必要があります
    # ./config/tengined.yml.erb の process:pid_dir にpidファイルの保存先を指定しています
    # 特に設定ファイルを変更していない場合は、以下の場所にあります
    #  => /var/lib/tengine_daemons/shared/pids/
    #  この中のtengine_resourcewd*.pidに強制停止したPIDが記載されている事を確認して削除してください

    もし 120秒待機する # 不達イベントを検知する時間はデフォルトで120秒です

    もし "イベント一覧画面"を表示する
    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                             |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |expired.resourcew.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|error     |false       |process:/<PID>|

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名                     |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |resourcew.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|


  ####################
  #
  # スケジュールキーパー
  #
  ####################
  @manual
  @6009
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でスケジュールキーパーのハートビートを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production
    かつ "スケジュールキーパープロセス"が起動している
    # cap -f Capfile_daemons deploy:atd:start

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること
    |種別名               |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |atd.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用する
    |種別名               |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |atd.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|
    かつ "発生時刻"が"+30"秒変更されていること # ハートビートの送信間隔
    かつ "イベントキー"が変更されていないこと

    もし 以下のコマンドを実行し、"ハートビートウォッチャプロセス"を停止する #Ctrl+cで停止してもいいです
    # cap -f Capfile_daemon production deploy:atd:stop

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                      |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |finished.process.atd.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|info      |false       |process:/<PID>|
    かつ "イベントキー"が変更されていないこと

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名               |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |atd.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

  @manual
  @6010
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でスケジュールキーパーの不達イベントを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "Tengine::Core::Event.delete_all" -e production
    かつ "スケジュールキーパープロセス"が起動している
    # cap -f Capfile_daemons deploy:atd:start

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # すでに起動しているプロセスと追加起動したプロセスの2件
    |種別名               |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |atd.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|

    もし 以下のコマンドを実行し、"tengine_atd"のPIDを取得する
    # ps -ef | grep tengine_atd | grep -v grep
    かつ 以下のコマンドを実行し、"tengine_atd"を強制停止する # 追加起動したプロセスを停止する
    # kill -9 <PID>

    かつ "tengine_atd*.pid"ファイルを削除する
    # kill -9 で強制停止した場合、pidファイルが残ってしまうので削除する必要があります
    # ./config/atd.yml.erb の process:pid_dir にpidファイルの保存先を指定しています
    # 特に設定ファイルを変更していない場合は、以下の場所にあります
    #  => /var/lib/tengine_daemons/shared/pids/
    #  この中のtengine_atd*.pidに強制停止したPIDが記載されている事を確認して削除してください

    もし 120秒待機する # 不達イベントを検知する時間はデフォルトで120秒です

    もし "イベント一覧画面"を表示する
    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                       |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |expired.atd.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|error     |false       |process:/<PID>|

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名               |イベントキー|発生源名      |発生時刻                |通知レベル|通知確認済み|送信者名      |
    |atd.heartbeat.tengine|<uuid>      |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug     |true        |process:/<PID>|
