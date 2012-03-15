  @08_06_02_01
# start.execution.job.tengine(1) #
  シナリオ: [異常系]start.execution.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、tenginedがダウンする

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
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |初期化済  |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|操作       |
    |jn0004      |初期化済  |監視 ステータス変更 再実行|

    もし "ジョブ実行一覧"画面を表示する
    ならば 以下の行が表示されていること
    |ルートジョブネット|ステータス|
    |jn0004          |状態不明  |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|操作       |
    |jn0004      |初期化済  |監視 ステータス変更 再実行|

    もし "jn0004"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
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

  @08_06_02_02
# start.execution.job.tengine(2) #
  シナリオ: [異常系]start.execution.job.tengineのイベント処理中に、start.jobnet.job.tengineを発火した後に、tenginedがダウンする
    #普通にジョブが実行されるだけだからいらない

  @08_06_02_03
# start.execution.job.tengine(3) #
  シナリオ: [異常系]start.execution.job.tengineのイベント処理中に、スケジュールストアにタイムアウト警告のスケジュールを登録した後に、tenginedがダウンする
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
    かつ "警告設定"に1と入力する
    かつ "事前実行コマンド"に"export J1_SLEEP=120"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |初期化済  |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし 130秒間待機する
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

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること

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

  @08_06_02_04
# start.execution.job.tengine(4) #
  シナリオ: [異常系]start.execution.job.tengineのイベント処理中に、スケジュールストアにタイムアウト強制停止のスケジュールを登録した後に、tenginedがダウンする

  @08_06_02_05
  シナリオ: [異常系]start.execution.job.tengineのイベント処理中に、スケジュールストアにタイムアウト警告のスケジュールを登録した後に、tenginedがダウンする
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
    かつ "強制停止設定"に1と入力する
    かつ "事前実行コマンド"に"export J1_SLEEP=120"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |初期化済  |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし 70秒間待機する
    ならば 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |強制停止済  |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|操作       |
    |jn0004      |強制停止済  |監視 ステータス変更 再実行|

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