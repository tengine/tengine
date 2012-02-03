#language:ja
機能: アプリケーション運用者がTengineを自動起動する
  Tengineをミスなく、簡単に起動するために
  アプリケーション運用者
  はTengineを自動起動したい

  #
  # 登場する物理サーバと仮想サーバ
  # zbtgn001(物理サーバ)
  #   zbtgnmq2(MQサーバ2)
  #   zbtgndb1(DBサーバ1)
  #   zbtgnwb2(フロントエンドサーバ2)
  #   zbtgncr1(コアサーバ1)
  # zbtgn002(物理サーバ)
  #   zbtgnsc1(SCMサーバ1)
  #   zbtgnmq1(MQサーバ1)
  #   zbtgndb2(DBサーバ2)
  # zbtgn003(物理サーバ)
  #   zbtgnsc2(SCMサーバ2)
  #   zbtgndb3(DBサーバ3)
  #   zbtgnwb1(フロントエンドサーバ1)
  #   zbtgncr2(コアサーバ2)
  #

  # 自動起動・停止の設定
  #
  # 仮想サーバの起動
  #  virsh autostart <ドメイン名> を設定し、物理サーバ起動時に仮想サーバを起動するようにする
  #
  # heartbeat(RabbitMQ) … MQサーバ
  #  heartbeat を chkconfig に追加する
  #  Runlevel => heaetbeat 0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #
  # MongoDB … DBサーバ
  #  mongod を起動、停止するためのスクリプトを作成し /etc/init.d に配置する
  #  Runlevel => mongod 0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #
  # Apache(tengine_console) … フロントエンドサーバ
  #  Apacheを起動、停止するためのスクリプトを作成し /etc/init.d に配置追加する
  #  Runlevel => tengine_console 0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #  注) Apacheを起動する際は、RabbitMQ、MongoDB が起動していることを確認してApacheを起動する
  #
  # tengined, tengine_heartbeat_watchd, tengine_atd, tengine_resource_watchd … コアサーバ
  #  tengined, tengine_heartbeat_watchd, tengine_atd, tengine_resource_watchd を起動、停止するためのスクリプトを作成し /etc/init.d に配置に追加する
  #  RabbitMQ、MongoDBと接続できない場合は、起動を行わない。
  #  tengine_resource_watchd のみ Wakameと接続できない場合は起動しない
  #  Runlevel => tengined                 0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #              tengine_heartbeat_watchd 0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #              tengine_atd              0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #              tengine_resource_watchd  0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #
  # Red Hatのランレベル
  #  0: システム停止
  #  1: シングルユーザモード
  #  2: 未使用
  #  3: マルチユーザモード
  #  4: 未使用
  #  5: GUIマルチユーザモード
  #  6: システム再起動
  #

  #
  # @manual
  # 背景に関しては@manualタグを付けることができないのでコメントアウトしています
  背景:
    前提 日本語でアクセスする
    かつ 物理サーバが停止している
    かつ 物理サーバ起動時に仮想サーバを自動起動する設定をしている
    かつ DBサーバ起動時に"DBプロセス"を起動する設定をしている
    かつ MQサーバ起動時に"キュープロセス"を起動する設定をしている
    かつ フロントエンドサーバ起動時に"Tengineコンソールプロセス"を起動する設定をしている
    かつ コアサーバ起動時に"Tengineコアプロセス"を起動する設定をしている
    かつ コアサーバ起動時に"Tengineスケジュールキーパープロセス"を起動する設定をしている
    かつ コアサーバ起動時に"Tengineハートビートウォッチャプロセス"を起動する設定をしている
    かつ コアサーバ起動時に"Tengineリソースウォッチャプロセス"を起動する設定をしている


  #
  # 正常系
  #
  @manual
  シナリオ: [正常系]アプリケーション運用者がTengineを自動起動する

    #
    # 物理サーバの起動
    #
    もし "zbtgn001"物理サーバを起動する
    かつ "zbtgn002"物理サーバを起動する
    かつ "zbtgn003"物理サーバを起動する


    # 仮想サーバが起動するまで待機する
    もし 120秒待機する

    #
    # 仮想サーバが起動していることを確認する
    #
    もし "zbtgn001"物理サーバにログインする
    かつ `sudo virsh list`コマンドを実行する
    ならば 以下の結果を含んでいること
    """
    ** zbtgnmq2             running
    ** zbtgndb1             running
    ** zbtgnwb2             running
    ** zbtgncr1             running
    """

    もし "zbtgn002"物理サーバにログインする
    かつ `sudo virsh list`コマンドを実行する
    ならば 以下の結果を含んでいること
    """
    ** zbtgnsc1             running
    ** zbtgnmq1             running
    ** zbtgndb2             running
    """

    もし "zbtgn003"物理サーバにログインする
    かつ `sudo virsh list`コマンドを実行する
    ならば 以下の結果を含んでいること
    """
    ** zbtgnsc2             running
    ** zbtgndb3             running
    ** zbtgnwb1             running
    ** zbtgncr2             running
    """


    もし "zbtgn001"物理サーバにログインする

    #
    # DBプロセスが正しく起動していることを確認する
    #
    # rs_status.js は shellPrint(rs.status()) を実行するのみのスクリプトを作成する
    もし `ssh tengine@zbtgndb1 /usr/local/mongodb/bin/mongo admin rs_status.js`コマンドを実行する
    ならば 以下の記述が存在すること
    """
    "name" : "zbtgndb1:27017",
    "health" : 1,
    "state" : [1-2],
    """
    かつ 以下の記述が存在すること
    """
    "name" : "zbtgndb2:27017",
    "health" : 1,
    "state" : [1-2],
    """
    かつ 以下の記述が存在すること
    """
    "name" : "zbtgndb3:27017",
    "health" : 1,
    "state" : [1-2],
    ""

    #
    # キュープロセスが正しく起動していることを確認する
    #
    もし `ssh root@zbtgnmq1 crm_mon -1`コマンドを実行する
    ならば 以下の記述が存在すること
    """
    Online: [ zbtgnmq1 zbtgnmq2 ]
    """
    かつ 以下の記述が存在すること
    """
    drbd_fs	(ocf::heartbeat:Filesystem):	Started zbtgnmq1
    Master/Slave Set: drbd_ms
        Masters: [ zbtgnmq1 ]
        Slaves: [ zbtgnmq2 ]
    bunny	(ocf::rabbitmq:rabbitmq-server):	Started zbtgnmq1
    ip	(ocf::heartbeat:IPaddr2):	Started zbtgnmq1
    """

    #
    # Tengineコンソールプロセスが起動していることを確認する
    #
    もし ` ssh tengine@zbtgnwb1 ps aux | grep -e apache | grep -v grep`コマンドを実行する
    ならば 以下の記述が複数存在すること
    """
    apache   *****  ***  *** ******  **** *        *    *****   **** /usr/sbin/httpd

    """

    もし ` ssh tengine@zbtgnwb2 ps aux | grep -e apache | grep -v grep`コマンドを実行する
    ならば 以下の記述が複数存在すること
    """
    apache   *****  ***  *** ******  **** *        *    *****   **** /usr/sbin/httpd

    """

    #
    # Tengineコアプロセス
    # Tengineハートビートウォッチャプロセス
    # Tengineリソースウォッチャプロセス
    # Tengineスケジュールキーパープロセス
    #   が起動していることを確認する
    #
    もし `ssh tengine@zbtgncr1 ps aux | grep -e tengined -e tengine_heartbeat_watchd -e tengine_atd -e tengine_resource_watchd | grep -v grep`コマンドを実行する
    ならば 以下の記述が存在すること
    """
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengined.0
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_atd
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_heartbeat_watchd
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_resource_watchd
    """

    もし `ssh tengine@zbtgncr2 ps aux | grep -e tengined -e tengine_heartbeat_watchd -e tengine_atd -e tengine_resource_watchd | grep -v grep`コマンドを実行する
    ならば 以下の記述が存在すること
    """
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengined.0
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_atd
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_heartbeat_watchd
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_resource_watchd
    """


  #
  # Frontendサーバ異常系
  # RabbitMQ、MongoDBに接続できない状態で、Frontendサーバを起動しても httpd を起動しない
  # RabbitMQ、MongoDBに接続出来なかった場合、接続に失敗したことをブートログに出力しリトライを行う。
  # さらにリトライ回数が指定回数に達した場合は、自動起動に失敗したことをブートログに出力する。
  #
  # ブートログ…/var/log/boot.log
  # リトライは30秒おきに10回行う
  #

  @manual
  シナリオ: [異常系]アプリケーション運用者がMQサーバ停止時にFrontendサーバを起動する

    前提 "zbtgn001"物理サーバが起動している
    かつ "zbtgn002"物理サーバが起動している
    かつ "zbtgn003"物理サーバが起動している

    # Frontendサーバ…停止
    かつ "zbtgnwb1"仮想サーバが停止している
    かつ "zbtgnwb2"仮想サーバが停止している
    # MQサーバ…停止
    かつ "zbtgnmq1"仮想サーバが停止している
    かつ "zbtgnmq2"仮想サーバが停止している
    # DBサーバ…起動
    かつ "zbtgndb1"仮想サーバが起動している
    かつ "zbtgndb2"仮想サーバが起動している
    かつ "zbtgndb3"仮想サーバが起動している

    #
    # Frontendサーバ起動
    #
    もし "zbtgnwb1"仮想サーバを起動する
    もし 300秒待機する #リトライを諦めるの3が約270秒

    もし `ssh tengine@zbtgnwb1 ps aux | grep -e apache | grep -v grep`コマンドを実行する
    ならば 以下の記述を含んでいなこと
    """
    apache   *****  ***  *** ******  **** *        *    *****   **** /usr/sbin/httpd

    """

    #
    # ログを確認して、原因を調べる
    #
    もし `ssh tengine@zbtgnwb1 cat /var/log/boot.log`コマンドを実行する
    ならば 以下の記述を含んでいること
    """
    Starting tengine console:                                           [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <MQのVIP>:5672
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

  @manual
  シナリオ: [異常系]アプリケーション運用者がDBサーバが停止時にFrontendサーバを起動する

    前提 "zbtgn001"物理サーバが起動している
    かつ "zbtgn002"物理サーバが起動している
    かつ "zbtgn003"物理サーバが起動している

    # Frontendサーバ…停止
    かつ "zbtgnwb1"仮想サーバが停止している
    かつ "zbtgnwb2"仮想サーバが停止している
    # MQサーバ…起動
    かつ "zbtgnmq1"仮想サーバが起動している
    かつ "zbtgnmq2"仮想サーバが起動している
    # DBサーバ…停止
    かつ "zbtgndb1"仮想サーバが停止している
    かつ "zbtgndb2"仮想サーバが停止している
    かつ "zbtgndb3"仮想サーバが停止している

    #
    # Frontendサーバ起動
    #
    もし "zbtgnwb1"仮想サーバを起動する
    もし 300秒待機する #リトライを諦めるのが約270秒

    もし `ssh tengine@zbtgnwb1 ps aux | grep -e apache | grep -v grep`コマンドを実行する
    ならば 以下の記述を含んでいなこと
    """
    apache   *****  ***  *** ******  **** *        *    *****   **** /usr/sbin/httpd

    """

    #
    # ログを確認して、原因を調べる
    #
    もし `ssh tengine@zbtgnwb1 cat /var/log/boot.log`コマンドを実行する
    ならば 以下の記述を含んでいること
    """
    Starting tengine_console:                                           [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <zbtgndb1のIP>:27017
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

  #
  # RabbitMQ、MongoDBに接続できない状態で、Coreサーバを起動しても tengined, tengine_heartbeat_watchd, tengine_atd, tengine_resource_watchd を起動しない
  # Wakameに接続できない状態で、Coreサーバを起動しても tengine_resource_watchd を起動しない
  # RabbitMQ、MongoDB(、Wakame)に接続出来なかった場合、接続に失敗したことをブートログに出力しリトライを行う。
  # さらにリトライ回数が指定回数に達した場合は、自動起動に失敗したことをブートログに出力する。
  #
  # ブートログ…/var/log/boot.log
  # リトライは30秒おきに10回行う
  #
  @manual
  シナリオ: [異常系]アプリケーション運用者がMQサーバ停止時にCoreサーバを起動する
    前提 "zbtgn001"物理サーバが起動している
    かつ "zbtgn002"物理サーバが起動している
    かつ "zbtgn003"物理サーバが起動している

    # Coreサーバ…停止
    かつ "zbtgncr1"仮想サーバが停止している
    かつ "zbtgncr2"仮想サーバが停止している
    # MQサーバ…停止
    かつ "zbtgnmq1"仮想サーバが停止している
    かつ "zbtgnmq2"仮想サーバが停止している
    # DBサーバ…起動
    かつ "zbtgndb1"仮想サーバが起動している
    かつ "zbtgndb2"仮想サーバが起動している
    かつ "zbtgndb3"仮想サーバが起動している

    かつ Wakameに接続できる

    #
    # Coreサーバ起動
    #
    もし "zbtgncr1"仮想サーバを起動する
    もし 300秒待機する #リトライを諦めるのが約270秒

    もし `ssh tengine@zbtgncr1 ps aux | grep -e tengined -e tengine_heartbeat_watchd -e tengine_atd -e tengine_resource_watchd | grep -v grep`コマンドを実行する
    ならば 以下の記述が存在しないこと
    """
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengined.0
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_atd
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_heartbeat_watchd
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_resource_watchd
    """

    #
    # ログを確認して、原因を調べる
    #
    もし `ssh tengine@zbtgnwb1 cat /var/log/boot.log`コマンドを実行する
    ならば 以下の記述を含んでいること

    # tengined が自動起動に失敗
    """
    Starting tengined:                                           [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <MQのVIP>:5672
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

    # tengine_atd が自動起動に失敗
    かつ 以下の記述を含んでいること
    """
    Starting tengine_atd:                                        [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <MQのVIP>:5672
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

    # tengine_heartbeat_watchd が自動起動に失敗
    かつ 以下の記述を含んでいること
    """
    Starting tengine_heartbeat_watchd:                           [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <MQのVIP>:5672
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

    # tengine_resource_watchd が自動起動に失敗
    かつ 以下の記述を含んでいること
    """
    Starting tengine_resource_watchd:                            [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <MQのVIP>:5672
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

  @manual
  シナリオ: [異常系]アプリケーション運用者がDBサーバ停止時にCoreサーバを起動する
    前提 "zbtgn001"物理サーバが起動している
    かつ "zbtgn002"物理サーバが起動している
    かつ "zbtgn003"物理サーバが起動している

    # Coreサーバ…停止
    かつ "zbtgncr1"仮想サーバが停止している
    かつ "zbtgncr2"仮想サーバが停止している
    # MQサーバ…起動
    かつ "zbtgnmq1"仮想サーバが起動している
    かつ "zbtgnmq2"仮想サーバが起動している
    # DBサーバ…停止
    かつ "zbtgndb1"仮想サーバが停止している
    かつ "zbtgndb2"仮想サーバが停止している
    かつ "zbtgndb3"仮想サーバが停止している

    かつ Wakameに接続できる

    #
    # Coreサーバ起動
    #
    もし "zbtgncr1"仮想サーバを起動する
    もし 300秒待機する #リトライを諦めるのが約270秒

    もし `ssh tengine@zbtgncr1 ps aux | grep -e tengined -e tengine_heartbeat_watchd -e tengine_atd -e tengine_resource_watchd | grep -v grep`コマンドを実行する
    ならば 以下の記述が存在しないこと
    """
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengined.0
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_atd
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_heartbeat_watchd
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_resource_watchd
    """

    #
    # ログを確認して、原因を調べる
    #
    もし `ssh tengine@zbtgnwb1 cat /var/log/boot.log`コマンドを実行する
    ならば 以下の記述を含んでいること

    # tengined が自動起動に失敗
    """
    Starting tengined:                                           [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <zbtgndb1のIP>:27017
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

    # tengine_atd が自動起動に失敗
    かつ 以下の記述を含んでいること
    """
    Starting tengine_atd:                                        [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <zbtgndb1のIP>:27017
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

    # tengine_heartbeat_watchd が自動起動に失敗
    かつ 以下の記述を含んでいること
    """
    Starting tengine_heartbeat_watchd:                           [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <zbtgndb1のIP>:27017
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

    # tengine_resource_watchd が自動起動に失敗
    かつ 以下の記述を含んでいること
    """
    Starting tengine_resource_watchd:                            [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <zbtgndb1のIP>:27017
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """

  @manual
  シナリオ: [異常系]アプリケーション運用者がWakameに接続できない時にCoreサーバを起動する
    前提 "zbtgn001"物理サーバが起動している
    かつ "zbtgn002"物理サーバが起動している
    かつ "zbtgn003"物理サーバが起動している

    # Coreサーバ…停止
    かつ "zbtgncr1"仮想サーバが停止している
    かつ "zbtgncr2"仮想サーバが停止している
    # MQサーバ…起動
    かつ "zbtgnmq1"仮想サーバが起動している
    かつ "zbtgnmq2"仮想サーバが起動している
    # DBサーバ…起動
    かつ "zbtgndb1"仮想サーバが起動している
    かつ "zbtgndb2"仮想サーバが起動している
    かつ "zbtgndb3"仮想サーバが起動している

    かつ Wakameに接続できない

    #
    # Coreサーバ起動
    #
    もし "zbtgncr1"仮想サーバを起動する
    もし 300秒待機する #リトライを諦めるのが約270秒

    # tengined, tengine_heartbeat_watchd, tengine_atd は起動する。
    # tengine_resource_watchd は起動しない。
    もし `ssh tengine@zbtgncr1 ps aux | grep -e tengined -e tengine_heartbeat_watchd -e tengine_atd -e tengine_resource_watchd | grep -v grep`コマンドを実行する
    ならば 以下の記述が存在すること
    """
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengined.0
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_atd
    tengined *****  ***  *** ******* ***** *       **   ***** ****** tengine_heartbeat_watchd
    """

    #
    # ログを確認して、原因を調べる
    #
    もし `ssh tengine@zbtgnwb1 cat /var/log/boot.log`コマンドを実行する
    ならば 以下の記述を含んでいること

    """
    Starting tengine_resource_watchd:                            [FAILED]

    """
    かつ 以下の記述を10回含んでいること
    """
    Connecting to <zbtgndb1のIP>:27017
    Errno::ECONNREFUSED: Connection refused - connect(2)
    """
