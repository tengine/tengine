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
  #  ReplicaSetのステータスを取得するため、rs.staus() の実行結果を返す、スクリプトを zbtgndb1 に配置する
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
  # Redhatのランレベル
  #  0: システム停止
  #  1: シングルユーザモード
  #  2: 未使用
  #  3: マルチユーザモード
  #  4: 未使用
  #  5: GUIマルチユーザモード
  #  6: システム再起動
  #

  #
  # 仮想サーバを停止する順序
  #
  # 1. コアサーバ
  # 2. フロントエンドサーバ
  # 3. MQサーバ
  # 4. DBサーバ
  # 5. SCMサーバ
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
  シナリオ: [正常系]アプリケーション運用者がTengineを自動起動する

    #
    # 仮想サーバのシャットダウン
    #
    もし "zbtgn001"物理サーバにログインする
    # 仮想サーバシャットダウンスクリプトの実行
    かつ `~/tengine_virtual_servers.sh `コマンドを実行する
    ならば 以下の結果を含んでいること
    """
    yyyy-MM-dd HH:mm:ss zbtgncr1 server stopped
    yyyy-MM-dd HH:mm:ss zbtgncr2 server stopped
    yyyy-MM-dd HH:mm:ss zbtgnwb1 server stopped
    yyyy-MM-dd HH:mm:ss zbtgnwb2 server stopped
    yyyy-MM-dd HH:mm:ss zbtgnmq1 server stopped
    yyyy-MM-dd HH:mm:ss zbtgnmq2 server stopped
    yyyy-MM-dd HH:mm:ss zbtgndb1 server stopped
    yyyy-MM-dd HH:mm:ss zbtgndb2 server stopped
    yyyy-MM-dd HH:mm:ss zbtgndb3 server stopped
    yyyy-MM-dd HH:mm:ss zbtgnsc1 server stopped
    yyyy-MM-dd HH:mm:ss zbtgnsc2 server stopped
    """

    #
    # 仮想サーバが停止していることを確認する
    #
    もし "zbtgn001"物理サーバにログインする
    かつ `sudo virsh list`コマンドを実行する
    ならば 以下の結果を含んでいること
    """
       zbtgnmq2             shut off
       zbtgndb1             shut off
       zbtgnwb2             shut off
       zbtgncr1             shut off
    """

    もし "zbtgn002"物理サーバにログインする
    かつ `sudo virsh list`コマンドを実行する
    ならば 以下の結果を含んでいること
    """
       zbtgnsc1             shut off
       zbtgnmq1             shut off
       zbtgndb2             shut off
    """

    もし "zbtgn003"物理サーバにログインする
    かつ `sudo virsh list`コマンドを実行する
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
    もし "zbtgn001"物理サーバをシャットダウンする
    かつ "zbtgn002"物理サーバをシャットダウンする
    かつ "zbtgn003"物理サーバをシャットダウンする
