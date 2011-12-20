#language:ja
機能: アプリケーション運用者がイベント一覧画面でハートビートを確認する
  Tengine周辺のコンポーネントの生存状態を確認するために
  アプリケーション運用者
  ハートビートを確認したい

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

#
# tengined
#
  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でtenginedのハートビートを確認する
    #
    # 【注意】
    # 以降の手順に書いていますが
    # tenginedの終了イベントを受け取るために、もう1個tenginedを起動する必要があります
    #

  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でtenginedの不達イベントを確認する
    #
    # 【注意】
    # 以降の手順に書いていますが
    # tenginedの不達イベントを受け取るために、もう1個tenginedを起動する必要があります
    #

#
# ジョブ
#
  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でジョブのハートビートを確認する
    #
    # 【注意】
    # ジョブの実行中に確認、オペレーションをする必要があるため、時間がかかるジョブを実行します
    #

  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でジョブの不達イベントを確認する
    #
    # 【注意】
    # ジョブの実行中に確認、オペレーションをする必要があるため、時間がかかるジョブを実行します
    #

#
# ハートビートウォッチャ
#
  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でハートビートウォッチャのハートビートを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "rails runner "Tengine::Core::Event.delete_all" -e production

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |hbw.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用する
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |hbw.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|
    かつ "発生時刻"が"+30"秒変更されていること # ハートビートの送信間隔
    かつ "イベントキー"が変更されていないこと

    もし 以下のコマンドを実行し、"ハートビートウォッチャプロセス"を停止する　#Ctrl+cで停止してもいいです
    # cap -f Capfile_daemon production deploy:heartbeat_watchd:stop

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                       |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |finished.process.hbw.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|info     |false     |process:/<PID>|
    かつ "イベントキー"が変更されていないこと

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |hbw.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でハートビートウォッチャの不達イベントを確認する
    #
    # 【注意】
    # 以降の手順に書いていますが
    # ハートビートウォッチャのハートビートを監視するためにもう1個ハートビートウォッチャを起動する必要があります
    #

    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "rails runner "Tengine::Core::Event.delete_all" -e production

    # expired.job.heartbeat.tengine を発生させるために tengine_heartbeat_watchd を追加する
    かつ 以下のコマンドを実行し、"tengine_heartbeat_watchd"を起動する
    # tengine_heartbeat_watchd -f ./config/hbw.yml.erb -D
    かつ 標準出力からPIDを取得する

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # すでに起動しているプロセスと追加起動したプロセスの2件
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |hbw.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|
    |hbw.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

    もし 以下のコマンドを実行し、"tengine_heartbeat_watchd"を強制停止する # 取得したPIDを引数に追加起動したプロセスを停止する
    # kill -9 <PID>

    もし 120秒待機する # 不達イベントを検知する時間はデフォルトで120秒です

    もし "イベント一覧画面"を表示する
    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                        |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |expired.hbw.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|error    |false     |process:/<PID>|
    |hbw.heartbeat.tengine        |<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

#
# リソースウォッチャ
#
  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でリソースウォッチャのハートビートを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "rails runner "Tengine::Core::Event.delete_all" -e production
    前提 "リソースウォッチャプロセス"が起動している
    # cap -f Capfile_daemon production deploy:resource_watchd:start

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |resourcew.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用する
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |resourcew.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|
    かつ "発生時刻"が"+30"秒変更されていること # ハートビートの送信間隔
    かつ "イベントキー"が変更されていないこと

    もし 以下のコマンドを実行し、"リソースウォッチャプロセス"を停止する　#Ctrl+cで停止してもいいです
    # cap -f Capfile_daemon production deploy:resource_watchd:stop

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                             |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |finished.process.resourcew.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|info     |false     |process:/<PID>|
    かつ "イベントキー"が変更されていないこと

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名                      |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |resourcew.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でリソースウォッチャの不達イベントを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "rails runner "Tengine::Core::Event.delete_all" -e production
    かつ "リソースウォッチャプロセス"が起動している
    # cap -f Capfile_daemon production deploy:resource_watchd:start

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # すでに起動しているプロセスと追加起動したプロセスの2件
    |種別名                      |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |resourcew.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

    もし 以下のコマンドを実行し、"tengine_resource_watchd"のPIDを取得する
    # ps -ef | grep tengine_resource_watchd | grep -v grep
    かつ 以下のコマンドを実行し、"tengine_resource_watchd"を強制停止する # 追加起動したプロセスを停止する
    # kill -9 <PID>

    もし 120秒待機する # 不達イベントを検知する時間はデフォルトで120秒です

    もし "イベント一覧画面"を表示する
    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                              |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |expired.resourcew.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|error    |false     |process:/<PID>|

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名                      |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |resourcew.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|


#
# スケジュールキーパー
#
  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でスケジュールキーパーのハートビートを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "rails runner "Tengine::Core::Event.delete_all" -e production
    かつ "スケジュールキーパープロセス"が起動している
    # cap -f Capfile_daemon production deploy:atd:start

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |atd.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

    もし 30秒待機する # ハートビートの送信間隔はデフォルトで30秒です

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # ハートビート関連のイベントは一連のハートビートで同じイベントキーを使用する
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |atd.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|
    かつ "発生時刻"が"+30"秒変更されていること # ハートビートの送信間隔
    かつ "イベントキー"が変更されていないこと

    もし 以下のコマンドを実行し、"ハートビートウォッチャプロセス"を停止する　#Ctrl+cで停止してもいいです
    # cap -f Capfile_daemon production deploy:atd:stop

    もし "イベント一覧画面"を表示する

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                       |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |finished.process.atd.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|info     |false     |process:/<PID>|
    かつ "イベントキー"が変更されていないこと

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |atd.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

  @manual
  シナリオ: [正常系]アプリケーション運用者がイベント一覧画面でスケジュールキーパーの不達イベントを確認する
    前提 以下のコマンドを実行し、イベントのデータを全削除している
    # rails runner "rails runner "Tengine::Core::Event.delete_all" -e production
    かつ "スケジュールキーパープロセス"が起動している
    # cap -f Capfile_daemon production deploy:atd:start

    もし "イベント一覧画面"を表示する
    ならば イベント一覧に以下の行が存在すること # すでに起動しているプロセスと追加起動したプロセスの2件
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |atd.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|

    もし 以下のコマンドを実行し、"tengine_resource_watchd"のPIDを取得する
    # ps -ef | grep tengine_atd | grep -v grep
    かつ 以下のコマンドを実行し、"tengine_atd"を強制停止する # 追加起動したプロセスを停止する
    # kill -9 <PID>

    もし 120秒待機する # 不達イベントを検知する時間はデフォルトで120秒です

    もし "イベント一覧画面"を表示する
    # 一連のハートビートで同じイベントキーを使用していることを確認する
    ならば イベント一覧に以下の行が存在すること
    |種別名                        |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |expired.atd.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|error    |false     |process:/<PID>|

    # 一連のハートビートで同じイベントキーを使用していることを確認する
    かつ イベント一覧に以下の行が存在しないこと
    |種別名                |イベントキー|発生源名       |発生時刻                 |通知レベル|通知確認済み|送信者名       |
    |atd.heartbeat.tengine|<uuid>    |process:/<PID>|yyyy-MM-dd HH:mm:ss+0900|debug    |false     |process:/<PID>|
