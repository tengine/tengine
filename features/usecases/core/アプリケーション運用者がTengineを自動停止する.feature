#language:ja
機能: アプリケーション運用者がTengineを自動停止する
  Tengineをミスなく、安全かつ簡単に停止するために
  アプリケーション運用者
  はTengineを自動停止したい

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
  # 自動停止スクリプト概要
  #
  # 自動停止スクリプトでは[仮想サーバを停止する順序](後述)の仮想サーバ群を停止する
  # 物理サーバの停止は行わないので、手動で停止を行う必要がある
  #
  # 仮想サーバの停止コマンド実行後、仮想サーバが停止するまで指定時間(リトライ回数と間隔)の待ち合わせを行う
  # 仮想サーバが停止したことを受けて、次の仮想サーバの停止を行う
  # 停止対象の仮想サーバがすでに停止している場合、スキップする
  #
  # 仮想サーバの停止コマンド
  # `virsh destroy <ドメイン名>`
  #
  # 仮想サーバが停止していることを確認するコマンド
  # `virsh domstate <ドメイン名>` の実行結果が "shut off"であること
  #

  #
  # 仮想サーバを停止する順序
  #
  # 1. コアサーバ(zbtgncr1, zbtgncr2)
  # 2. フロントエンドサーバ(zbtgnwb1, zbtgnwb2)
  # 3. MQサーバ(zbtgnmq1, zbtgnwb2)
  # 4. DBサーバ(zbtgndb1, zbtgndb2, zbtgndb3)
  # 5. SCMサーバ(zbtgnsc1, zbtgnsc2)
  #

  # @manual
  # 背景に関しては@manualタグを付けることができないのでコメントアウトしています
  背景:
    前提 日本語でアクセスする
    かつ 物理サーバ起動している
    かつ DBサーバ停止時に"DBプロセス"を停止する設定をしている
    かつ MQサーバ停止時に"キュープロセス"を停止する設定をしている
    かつ フロントエンドサーバ起動時に"Tengineコンソールプロセス"を停止する設定をしている
    かつ コアサーバ停止時に"Tengineコアプロセス"を停止する設定をしている
    かつ コアサーバ停止時に"Tengineスケジュールキーパープロセス"を停止する設定をしている
    かつ コアサーバ停止時に"Tengineハートビートウォッチャプロセス"を停止する設定をしている
    かつ コアサーバ停止時に"Tengineリソースウォッチャプロセス"を停止する設定をしている

  @manual
  シナリオ: [正常系]アプリケーション運用者がTengineを自動停止する

    #
    # 仮想サーバのシャットダウン
    #
    もし "zbtgn001"物理サーバにログインする
    # 仮想サーバシャットダウンスクリプトの実行
    かつ `~/shutdown_virtual_servers.sh `コマンドを実行する
    ならば 以下の結果を含んでいること
    """
    yyyy-MM-dd HH:mm:ss zbtgncr1 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgncr2 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgnwb1 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgnwb2 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgnmq1 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgnmq2 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgndb1 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgndb2 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgndb3 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgnsc1 state is shut off
    yyyy-MM-dd HH:mm:ss zbtgnsc2 state is shut off
    """

    #
    # 仮想サーバが停止していることを確認する
    #
    もし "zbtgn001"物理サーバにログインする
    かつ `sudo virsh list --all`コマンドを実行する
    ならば 以下の結果を含んでいること
    """
       zbtgnmq2             shut off
       zbtgndb1             shut off
       zbtgnwb2             shut off
       zbtgncr1             shut off
    """

    もし "zbtgn002"物理サーバにログインする
    かつ `sudo virsh list --all`コマンドを実行する
    ならば 以下の結果を含んでいること
    """
       zbtgnsc1             shut off
       zbtgnmq1             shut off
       zbtgndb2             shut off
    """

    もし "zbtgn003"物理サーバにログインする
    かつ `sudo virsh list --all`コマンドを実行する
    ならば 以下の結果を含んでいること
    """
       zbtgnsc2             shut off
       zbtgndb3             shut off
       zbtgnwb1             shut off
       zbtgncr2             shut off
    """

    #
    # 物理サーバのシャットダウン
    #
    もし "zbtgn001"物理サーバを手動でシャットダウンする
    かつ "zbtgn002"物理サーバを手動でシャットダウンする
    かつ "zbtgn003"物理サーバを手動でシャットダウンする
