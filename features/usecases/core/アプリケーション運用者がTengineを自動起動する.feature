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
  #    Runlevel => 0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #
  # MongoDB … DBサーバ
  #  mogod を起動、停止するためのスクリプトを作成し /etc/init.d に配置する
  #    Runlevel => 0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #  Replica Setsのステータスを取得するため、rs.staus() の実行結果を返す、スクリプトを zbtgndb1 に配置する
  #
  # Apache(tengine_console) … フロントエンドサーバ
  #  Apacheを起動、停止するためのスクリプトを作成し /etc/init.d に配置追加する
  #    Runlevel => 0:off 1:off 2:on 3:on 4:on 5:on 6:off
  #  注) Apacheを起動する際は、RabbitMQ、MongoDB が起動していることを確認してApacheを起動する
  #
  # tengined, tengine_heartbeat_watchd, tengine_atd, tengine_resource_watchd … コアサーバ
  #  tengined, tengine_heartbeat_watchd, tengine_atd, tengine_resource_watchd を起動、停止するためのスクリプトを作成し /etc/init.d に配置に追加する
  #    Runlevel => 0:off 1:off 2:on 3:on 4:on 5:on 6:off
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
