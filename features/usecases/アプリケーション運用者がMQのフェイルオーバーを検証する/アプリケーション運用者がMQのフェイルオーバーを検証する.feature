#language:ja

@manual
機能: アプリケーション運用者がMQのフェイルオーバーを検証する [コア編]

  MQサーバがダウンした際に、
  アプリケーション運用者
  は、MQサーバがフェイルオーバーすることを検証したい。

  @manual
  背景:

    前提 MQサーバAが存在する。これのIPアドレスをzbtgnmq1であるとする
    かつ MQサーバBが存在する。これのIPアドレスをzbtgnmq2であるとする
    かつ VIPがセットアップされている
    かつ tenginedの設定ファイルはVIPにアクセスするように設定されている

    かつ このファイルと同じディレクトリにあるdslディレクトリを $dsl と呼ぶことにする
    かつ Pacemakerで管理しているMQのリソース名を bunny であるとする
    かつ Pacemakerで管理しているVIPのリソース名を ip であるとする
    かつ MQサーバの仮想マシンを停止/再開する方法を調べておく

  @manual
  @10_01_01_01
  シナリオ：[異常系]tenginedがイベントハンドリング中に、MQプロセスがダウンした際にフェールオーバーする

    前提 コアサーバ1、コアサーバ2上に "/tmp/tmp.txt" ファイルが存在しないこと

    もし "Tengineコアプロセス1"の起動を行うためにコアサーバ1で"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス1"の標準出力からPIDを確認する
    もし "Tengineコアプロセス1"の状態が"稼働中"であることを確認する

    もし "Tengineコアプロセス2"の起動を行うためにコアサーバ2で"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス2"の標準出力からPIDを確認する
    もし "Tengineコアプロセス2"の状態が"稼働中"であることを確認する

    もし イベント発火画面から"event_sleep_and_after_all"を発火する

    ならば zbtgnmq1で"mq_list_queues"を行い、consumersが2であること
    かつ messages_unacknowledgedが1であること

    # MQの停止から再起動
    もし 10秒間待機する
    もし zbtgnmq1の仮想マシンを落とす
    もし zbtgnmq2で"crm_mon -f"を行いVIPが切り替わってzbtgnmq2を向いたことを確認する

    もし 30秒間待機する
    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_sleep_and_after_all called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "I'll sleep for 60 secs." と書かれていること
    かつ "/tmp/tmp.txt" を開くと "I woke up." と書かれていること
    かつ イベント一覧画面に"event_sleep_after_all.failed.tengined"が表示されていること
    かつ コアサーバ1とコアサーバ2で"ps aux | grep -e tengined"を実行し、プロセスが落ちていなこと

  @manual
  @10_01_01_02
  シナリオ: [異常系]tengined起動時、MQプロセスがダウンした際にフェイルオーバーする

    前提 コアサーバ上に "/tmp/tmp.txt" ファイルが存在しないこと

    # MQの停止

    MQのプロセスを停止するためにPacemakerから"sudo crm_resource -r bunny -p target-role -v Stopped"を実行する。

    # 1回目

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    ならば tenginedが起動しないことを確認する。

    # MQの再起動

    MQのプロセスを起動するためにPacemakerから"sudo crm_resource -r bunny -p target-role -v Started"を実行する。
    # rabbitmq-serverが起動してきたことをなんらかの方法で確認する

    # 2回目

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし イベント発火画面から"event_at_first"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first called" と書かれていること


  @manual
  @10_01_02_01
  シナリオ: [異常系]tengined起動時、MQサーバがダウンした際にフェイルオーバーする

    前提 コアサーバ上に "/tmp/tmp.txt" ファイルが存在しないこと

    # MQの停止

    VIPを停止するためにPacemakerから"sudo crm_resource -r ip -p target-role -v Stopped"を実行する

    # 1回目

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    ならば tenginedが起動しないことを確認する。

    # MQの停止

    VIPを起動するためにPacemakerから"sudo crm_resource -r ip -p target-role -v Started"を実行する

    # 2回目

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし イベント発火画面から"event_at_first"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first called" と書かれていること


  ################################################################################################################################################

  @manual
  @10_01_02_02
  シナリオ: [異常系]イベント受信後、MQプロセスがダウンした際にフェイルオーバーする(ack at_first)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # MQの停止から再起動

    # rabbitmqを直接落として、Pacemakerに再起動させる
    もし MQプロセスを停止するために zbtgnmq1にて "sudo rabbitmqctl -n rabbit@localhost stop"というコマンドを実行する
    もし PacemakerがMQプロセスを再起動してくるのを確認するために "sudo rabbitmqctl -n rabbit@localhost status"というコマンドを実行する
    ならば '{running_applications,[{rabbit,"RabbitMQ",' という内容を含む出力を得ること

    # イベント実行

    もし イベント発火画面から"event_at_first"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first called" と書かれていること


  @manual
  @10_01_02_03
  シナリオ: [異常系]イベント送信後、MQサーバがダウンした際にフェイルオーバーする(ack at_first)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # MQの停止から再起動

    もし zbtgnmq1の仮想マシンを落とす
    もし VIPが切り替わってzbtgnmq2を向いたことを確認する # pingとか

    # 2回目

    もし イベント発火画面から"event_at_first"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first called" と書かれていること


  @manual
  @10_01_01_03
  シナリオ: [異常系]イベント受信後、MQプロセスがダウンした際にフェイルオーバーする(ack at_first)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # 1回目

    もし イベント発火画面から"event_at_first"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first called" と書かれていること

    # MQの停止から再起動

    もし MQプロセスを停止するために zbtgnmq1にて "sudo rabbitmqctl -n rabbit@localhost stop"というコマンドを実行する
    もし PacemakerがMQプロセスを再起動してくるのを確認するために "sudo rabbitmqctl -n rabbit@localhost status"というコマンドを実行する
    ならば '{running_applications,[{rabbit,"RabbitMQ",' という内容を含む出力を得ること

    # 2回目

    もし コアサーバ上で"/tmp/tmp.txt"を削除する
    かつ イベント発火画面から"event_at_first"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first called" と書かれていること


  @manual
  @10_01_02_04
  シナリオ: [異常系]イベント送信後、MQサーバがダウンした際にフェイルオーバーする(ack at_first)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # 1回目

    もし イベント発火画面から"event_at_first"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first called" と書かれていること

    # MQの停止から再起動

    もし zbtgnmq1の仮想マシンを落とす
    もし VIPが切り替わってzbtgnmq2を向いたことを確認する # pingとか

    # 2回目

    もし コアサーバ上で"/tmp/tmp.txt"を削除する
    かつ イベント発火画面から"event_at_first"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first called" と書かれていること


  ################################################################################################################################################

  # 既知の動かないシナリオ
  @manual
  @10_01_01_04
  シナリオ: [異常系]イベント受信後、MQプロセスがダウンした際にフェイルオーバーする(ack at_first_submit)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # MQの停止から再起動

    もし MQプロセスを停止するために zbtgnmq1にて "sudo rabbitmqctl -n rabbit@localhost stop"というコマンドを実行する
    もし PacemakerがMQプロセスを再起動してくるのを確認するために "sudo rabbitmqctl -n rabbit@localhost status"というコマンドを実行する
    ならば '{running_applications,[{rabbit,"RabbitMQ",' という内容を含む出力を得ること

    # イベント実行

    もし イベント発火画面から"event_at_first_submit"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit2 called" と書かれていること


  # 既知の動かないシナリオ
  @manual
  @10_01_02_05
  シナリオ: [異常系]イベント送信後、MQサーバがダウンした際にフェイルオーバーする(ack at_first_submit)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # MQの停止から再起動

    もし zbtgnmq1の仮想マシンを落とす
    もし VIPが切り替わってzbtgnmq2を向いたことを確認する # pingとか

    # 2回目

    もし イベント発火画面から"event_at_first_submit"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit2 called" と書かれていること


  # 既知の動かないシナリオ
  @manual
  @10_01_01_05
  シナリオ: [異常系]イベント受信後、MQプロセスがダウンした際にフェイルオーバーする(ack at_first_submit)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # 1回目

    もし イベント発火画面から"event_at_first_submit"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit2 called" と書かれていること

    # MQの停止から再起動

    もし MQプロセスを停止するために zbtgnmq1にて "sudo rabbitmqctl -n rabbit@localhost stop"というコマンドを実行する
    もし PacemakerがMQプロセスを再起動してくるのを確認するために "sudo rabbitmqctl -n rabbit@localhost status"というコマンドを実行する
    ならば '{running_applications,[{rabbit,"RabbitMQ",' という内容を含む出力を得ること

    # 2回目

    もし コアサーバ上で"/tmp/tmp.txt"を削除する
    かつ イベント発火画面から"event_at_first_submit"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit2 called" と書かれていること


  # 既知の動かないシナリオ
  @manual
  @10_01_02_06
  シナリオ: [異常系]イベント送信後、MQサーバがダウンした際にフェイルオーバーする(ack at_first_submit)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # 1回目

    もし イベント発火画面から"event_at_first_submit"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit2 called" と書かれていること

    # MQの停止から再起動

    もし zbtgnmq1の仮想マシンを落とす
    もし VIPが切り替わってzbtgnmq2を向いたことを確認する # pingとか

    # 2回目

    もし コアサーバ上で"/tmp/tmp.txt"を削除する
    かつ イベント発火画面から"event_at_first_submit"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_at_first_submit2 called" と書かれていること

  ################################################################################################################################################

  @manual
  @10_01_01_06
  シナリオ: [異常系]イベント受信後、MQプロセスがダウンした際にフェイルオーバーする(ack after_all)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # MQの停止から再起動

    もし MQプロセスを停止するために zbtgnmq1にて "sudo rabbitmqctl -n rabbit@localhost stop"というコマンドを実行する
    もし PacemakerがMQプロセスを再起動してくるのを確認するために "sudo rabbitmqctl -n rabbit@localhost status"というコマンドを実行する
    ならば '{running_applications,[{rabbit,"RabbitMQ",' という内容を含む出力を得ること

    # イベント実行

    もし イベント発火画面から"event_after_all"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all2 called" と書かれていること


  @manual
  @10_01_02_07
  シナリオ: [異常系]イベント送信後、MQサーバがダウンした際にフェイルオーバーする(ack after_all)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # MQの停止から再起動

    もし zbtgnmq1の仮想マシンを落とす
    もし VIPが切り替わってzbtgnmq2を向いたことを確認する # pingとか

    # 2回目

    もし イベント発火画面から"event_after_all"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all2 called" と書かれていること


  @manual
  @10_01_01_07
  シナリオ: [異常系]イベント受信後、MQプロセスがダウンした際にフェイルオーバーする(ack after_all)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # 1回目

    もし イベント発火画面から"event_after_all"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all2 called" と書かれていること

    # MQの停止から再起動

    もし MQプロセスを停止するために zbtgnmq1にて "sudo rabbitmqctl -n rabbit@localhost stop"というコマンドを実行する
    もし PacemakerがMQプロセスを再起動してくるのを確認するために "sudo rabbitmqctl -n rabbit@localhost status"というコマンドを実行する
    ならば '{running_applications,[{rabbit,"RabbitMQ",' という内容を含む出力を得ること

    # 2回目

    もし コアサーバ上で"/tmp/tmp.txt"を削除する
    かつ イベント発火画面から"event_after_all"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all2 called" と書かれていること


  @manual
  シナリオ: [異常系]イベント送信後、MQサーバがダウンした際にフェイルオーバーする(ack after_all)

    前提 VIPの設定がzbtgnmq1を向いていること

    もし "Tengineコアプロセス"の起動を行うために"tengined -T $dsl"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # 1回目

    もし イベント発火画面から"event_after_all"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all2 called" と書かれていること

    # MQの停止から再起動

    もし zbtgnmq1の仮想マシンを落とす
    もし VIPが切り替わってzbtgnmq2を向いたことを確認する # pingとか

    # 2回目

    もし コアサーバ上で"/tmp/tmp.txt"を削除する
    かつ イベント発火画面から"event_after_all"を発火する

    ならば コアプロセスが起動したサーバ上で "/tmp/tmp.txt" が存在すること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all1 called" と書かれていること
    かつ "/tmp/tmp.txt" を開くと "FileWritingDriver#event_after_all2 called" と書かれていること


