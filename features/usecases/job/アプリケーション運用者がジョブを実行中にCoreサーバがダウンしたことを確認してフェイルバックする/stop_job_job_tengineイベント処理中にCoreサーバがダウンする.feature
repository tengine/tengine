# stop.job.job.tengine(1) #
  シナリオ: [異常系]stop.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする
    もし Coreサーバを落とすために"Coreサーバ1"で"\cp -f tengine_console/feature/config/emergency_test/start.execution.job.tengine_1_yml tengine_console/config/emergency_test.yml"コマンドを実行する
    もし "Coreサーバ1"上で"Tengineコアプロセス1"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス1"の状態が"稼働中"であることを確認できること

    もし Coreサーバを落とすために"Coreサーバ2"で"\cp -f tengine_console/feature/config/emergency_test/start.execution.job.tengine_1_yml tengine_console/config/emergency_test.yml"コマンドを実行する
    もし "Coreサーバ2"上で"Tengineコアプロセス2"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス2"の状態が"稼働中"であることを確認できること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_SLEEP=120 && export J2_SLEEP=60 && export J1_SLEEP=60 "と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 10秒間待機する
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |実行中  |表示 ステータス変更 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし "jn0004"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |強制停止中|j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

   もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |状態不明  |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし test_server1にsshでログインし、j1の#{PID}を下にスクリプトをkillする
    ならば ps aux|grep #{PID}コマンドでスクリプトが停止したことを確認する

    もし "j1"の"ステータス変更"リンクをクリックする
    ならば "ジョブステータス変更"画面を表示していること

    もし "ステータス"として"エラー終了"を選択する
    かつ "更新する"ボタンをクリックする
    ならば  "ジョブネット監視画面"が表示されていること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |エラー終了 |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |
 

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|操作       |
    |jn0004      |エラー終了  |監視 ステータス変更 再実行|

# 以下フェイルバックの確認

    もし "Coreサーバ1"か"Coreサーバ2"のどちらかが落ちた事を確認し、落ちたサーバを"down_server"と呼ぶ
    かつ down_serverのIPを"down_server_ip"と呼ぶ
    かつ down_serverを再起動する
    ならば down_server上で動作していた"Tengineコアプロセス","tengine_resouce_watchd","heartbeat_watchd1","atd1"のPIDファイルを削除する
    かつ down_server上で動作していた"Tengineコアプロセス"のstatusファイルを削除する

    もし フェイルバックしたことの確認のために"Coreサーバ1"で"\rm -f tengine_console/config/emergency_test.yml"コマンドを実行する
    かつ フェイルバックしたことの確認のために"Coreサーバ2"で"\rm -f tengine_console/config/emergency_test.yml"コマンドを実行する
    かつ "down_server"上で"Tengineコアプロセス_failback"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス_failback"の状態が"稼働中"であることを確認できること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |実行中    |表示 強制停止  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |正常終了    |表示 再実行  |
    |j2        |正常終了  |表示 再実行  |
    |j3        |正常終了  |表示 再実行  |
    |j4        |正常終了  |表示 再実行  |
    |finally   |正常終了  |表示 再実行  |
    |  jn0004_f|正常終了  |表示 再実行  |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|操作       |
    |jn0004      |正常終了  |監視 ステータス変更 再実行|


# stop.job.job.tengine(2) #
  シナリオ: [異常系]stop.job.job.tengineのイベント処理中に、sshでスクリプトを停止するコマンドを実行した後に、Coreサーバがダウンする_finished.process.job.tengineがイベント処理失敗イベントの前に処理される
    もし Coreサーバを落とすために"Coreサーバ1"で"\cp -f tengine_console/feature/config/emergency_test/start.execution.job.tengine_1_yml tengine_console/config/emergency_test.yml"コマンドを実行する
    もし "Coreサーバ1"上で"Tengineコアプロセス1"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス1"の状態が"稼働中"であることを確認できること

    もし Coreサーバを落とすために"Coreサーバ2"で"\cp -f tengine_console/feature/config/emergency_test/start.execution.job.tengine_1_yml tengine_console/config/emergency_test.yml"コマンドを実行する
    もし "Coreサーバ2"上で"Tengineコアプロセス2"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス2"の状態が"稼働中"であることを確認できること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_SLEEP=120 && export J2_SLEEP=60 && export J1_SLEEP=60 "と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 10秒間待機する
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |実行中  |表示 ステータス変更 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし "jn0004"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |強制停止中|j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

   もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |強制停止済  |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

   もし 60秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |状態不明  |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし test_server1でj1のスクリプトが実行されたか、スクリプトログを見て確認する
    ならば エラー終了であること

    もし "j1"の"ステータス変更"リンクをクリックする
    ならば "ジョブステータス変更"画面を表示していること

    もし "ステータス"として"エラー終了"を選択する
    かつ "更新する"ボタンをクリックする
    ならば  "ジョブネット監視画面"が表示されていること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |エラー終了 |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |
 

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|操作       |
    |jn0004      |エラー終了  |監視 ステータス変更 再実行|

# 以下フェイルバックの確認

    もし "Coreサーバ1"か"Coreサーバ2"のどちらかが落ちた事を確認し、落ちたサーバを"down_server"と呼ぶ
    かつ down_serverのIPを"down_server_ip"と呼ぶ
    かつ down_serverを再起動する
    ならば down_server上で動作していた"Tengineコアプロセス","tengine_resouce_watchd","heartbeat_watchd1","atd1"のPIDファイルを削除する
    かつ down_server上で動作していた"Tengineコアプロセス"のstatusファイルを削除する

    もし フェイルバックしたことの確認のために"Coreサーバ1"で"\rm -f tengine_console/config/emergency_test.yml"コマンドを実行する
    かつ フェイルバックしたことの確認のために"Coreサーバ2"で"\rm -f tengine_console/config/emergency_test.yml"コマンドを実行する
    かつ "down_server"上で"Tengineコアプロセス_failback"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス_failback"の状態が"稼働中"であることを確認できること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |実行中    |表示 強制停止  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |正常終了    |表示 再実行  |
    |j2        |正常終了  |表示 再実行  |
    |j3        |正常終了  |表示 再実行  |
    |j4        |正常終了  |表示 再実行  |
    |finally   |正常終了  |表示 再実行  |
    |  jn0004_f|正常終了  |表示 再実行  |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|操作       |
    |jn0004      |正常終了  |監視 ステータス変更 再実行|