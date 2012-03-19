  @08_06_04_01
# start.job.job.tengine(1) #
# (1)
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、tenginedがダウンする
  
    もし Coreサーバのドライバの場所を確認するために"Coreサーバ1, Coreサーバ2"で"cd tengine_console && echo `bundle exec gem which tengine_job`|sed -e 's/\(.*\)tengine_job.rb/\1/'|xargs -i echo {}tengine/job/drivers"コマンドを実行する
    かつ オリジナルのドライバを退避する為に"Coreサーバ1, Coreサーバ2"で"echo `bundle exec gem which tengine_job`|sed -e 's/\(.*\)tengine_job.rb/\1/'|xargs -i \cp -rf {}tengine/job/drivers /tmp"コマンドを実行する
    #tengine_consoleのパスを適切なパスに変更して下さい
    かつ Coreサーバを落とすテストのためのドライバに置き換えるために"Coreサーバ1, Coreサーバ2"、"echo `bundle exec gem which tengine_job`|sed -e 's/\(.*\)tengine_job.rb/\1/'|xargs -i \cp -rf tengine_console/features/usecases/アプリケーション運用者がジョブを実行中にtenginedがダウンしたことを確認してフェイルバックする/driver/start.job.job.tengine/1/1/drivers {}tengine/job/drivers"コマンドを実行する

    もし "Coreサーバ2"上で"Tengineコアプロセス1"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス1"の状態が"稼働中"であることを確認できること
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

    もし "Coreサーバ1, Coreサーバ2"で"/tmp/core_server_down_txt"を表示し続けている
    かつ "/tmp/core_server_down_txt"に"please poweroff this server"と表示される
    かつ "please poweroff this server"と表示された"Coreサーバ"をダウン(電源断)する
    かつ 120秒間待機する
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |状態不明  |表示 ステータス変更 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし test_server1でj1のスクリプトが実行されたか、スクリプトログを見て確認する
    ならば 実行されていないことを確認すること

    もし "j1"の"ステータス変更"リンクをクリックする
    ならば "ジョブステータス変更"画面を表示していること

    もし "ステータス"として"初期化済"を選択する
    かつ "更新する"ボタンをクリックする
    ならば  "ジョブネット監視画面"が表示されていること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |初期化済  |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし "j1"の"再実行"リンクをクリックする
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

  @08_06_04_02
# start.job.job.tengine(2) #
# (1)
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、sshでtengine_job_agent_runを実行してからスクリプトのPIDが返ってくる間に、tenginedがダウンする
    #実はいらない?

  @08_06_04_03
# start.job.job.tengine(3) #
# (1)
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、スクリプトのPIDが帰ってきてからジョブストアのジョブネットの状態を更新する間に、tenginedがダウンする_finished.process.job.tengineがイベント処理失敗イベントの前に処理される
  
    もし Coreサーバのドライバの場所を確認するために"Coreサーバ1, Coreサーバ2"で"cd tengine_console && echo `bundle exec gem which tengine_job`|sed -e 's/\(.*\)tengine_job.rb/\1/'|xargs -i echo {}tengine/job/drivers"コマンドを実行する
    かつ オリジナルのドライバを退避する為に"Coreサーバ1, Coreサーバ2"で"echo `bundle exec gem which tengine_job`|sed -e 's/\(.*\)tengine_job.rb/\1/'|xargs -i \cp -rf {}tengine/job/drivers /tmp"コマンドを実行する
    #tengine_consoleのパスを適切なパスに変更して下さい
    かつ Coreサーバを落とすテストのためのドライバに置き換えるために"Coreサーバ1, Coreサーバ2"、"echo `bundle exec gem which tengine_job`|sed -e 's/\(.*\)tengine_job.rb/\1/'|xargs -i \cp -rf tengine_console/features/usecases/アプリケーション運用者がジョブを実行中にtenginedがダウンしたことを確認してフェイルバックする/driver/start.job.job.tengine/3/1/drivers {}tengine/job/drivers"コマンドを実行する

    もし "Coreサーバ2"上で"Tengineコアプロセス1"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス1"の状態が"稼働中"であることを確認できること
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

    もし 10秒間待機する
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |正常終了  |表示 再実行  |
    |j2        |準備中  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし "Coreサーバ1, Coreサーバ2"で"/tmp/core_server_down_txt"を表示し続けている
    かつ "/tmp/core_server_down_txt"に"please poweroff this server"と表示される
    かつ "please poweroff this server"と表示された"Coreサーバ"をダウン(電源断)する
    かつ 120秒間待機する
    ならば 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |状態不明  |表示 ステータス変更 再実行  |
    |j2        |正常終了  |表示 再実行  |
    |j3        |正常終了  |表示 再実行  |
    |j4        |正常終了  |表示 再実行  |
    |finally   |正常終了  |表示 再実行  |
    |  jn0004_f|正常終了  |表示 再実行  |

    もし test_server1でj1のスクリプトが実行されたか、スクリプトログを見て確認する
    ならば 正常終了していることを確認すること

    もし "j1"の"ステータス変更"リンクをクリックする
    ならば "ジョブステータス変更"画面を表示していること

    もし "ステータス"として"正常終了"を選択する
    かつ "更新する"ボタンをクリックする
    ならば  "ジョブネット監視画面"が表示されていること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |正常終了  |表示 再実行  |
    |j2        |正常終了  |表示 再実行  |
    |j3        |正常終了  |表示 再実行  |
    |j4        |正常終了  |表示 再実行  |
    |finally   |正常終了  |表示 再実行  |
    |  jn0004_f|正常終了  |表示 再実行  |

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

  @08_06_04_04
# (2)
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、スクリプトのPIDが帰ってきてからジョブストアのジョブネットの状態を更新する間に、tenginedがダウンする_finished.process.job.tengineがイベント失敗イベントの後に処理される
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

    もし 10秒間待機する
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |状態不明  |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし 10秒間待機する
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |状態不明  |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし test_server1でj1のスクリプトが実行されたか、スクリプトログを見て確認する
    ならば 正常終了していることを確認すること

    もし "j1"の"ステータス変更"リンクをクリックする
    ならば "ジョブステータス変更"画面を表示していること


    もし "ステータス"として"正常終了"を選択する
    かつ "更新する"ボタンをクリックする
    ならば  "ジョブネット監視画面"が表示されていること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |正常終了  |表示 再実行  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |


    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |正常終了    |表示 強制停止  |
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

  @08_06_04_05
# start.job.job.tengine(4) #
# (1)
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、スクリプトのPIDが帰ってきてジョブストアのジョブネットの状態を更新した後に、tenginedがダウンする_finished.process.job.tengineがイベント失敗イベントの前に処理される

    もし Coreサーバのドライバの場所を確認するために"Coreサーバ1, Coreサーバ2"で"cd tengine_console && echo `bundle exec gem which tengine_job`|sed -e 's/\(.*\)tengine_job.rb/\1/'|xargs -i echo {}tengine/job/drivers"コマンドを実行する
    かつ オリジナルのドライバを退避する為に"Coreサーバ1, Coreサーバ2"で"echo `bundle exec gem which tengine_job`|sed -e 's/\(.*\)tengine_job.rb/\1/'|xargs -i \cp -rf {}tengine/job/drivers /tmp"コマンドを実行する
    #tengine_consoleのパスを適切なパスに変更して下さい
    かつ Coreサーバを落とすテストのためのドライバに置き換えるために"Coreサーバ1, Coreサーバ2"、"echo `bundle exec gem which tengine_job`|sed -e 's/\(.*\)tengine_job.rb/\1/'|xargs -i \cp -rf tengine_console/features/usecases/アプリケーション運用者がジョブを実行中にtenginedがダウンしたことを確認してフェイルバックする/driver/start.job.job.tengine/3/1/drivers {}tengine/job/drivers"コマンドを実行する

    もし "Coreサーバ2"上で"Tengineコアプロセス1"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス1"の状態が"稼働中"であることを確認できること
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

    もし 10秒間待機する
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |正常終了  |表示 再実行  |
    |j2        |準備中  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし "Coreサーバ1, Coreサーバ2"で"/tmp/core_server_down_txt"を表示し続けている
    かつ "/tmp/core_server_down_txt"に"please poweroff this server"と表示される
    かつ "please poweroff this server"と表示された"Coreサーバ"をダウン(電源断)する
    かつ 120秒間待機する
    ならば 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |状態不明  |表示 ステータス変更 再実行  |
    |j2        |正常終了  |表示 再実行  |
    |j3        |正常終了  |表示 再実行  |
    |j4        |正常終了  |表示 再実行  |
    |finally   |正常終了  |表示 再実行  |
    |  jn0004_f|正常終了  |表示 再実行  |

    もし test_server1でj1のスクリプトが実行されたか、スクリプトログを見て確認する
    ならば 正常終了していることを確認すること

    もし "j1"の"ステータス変更"リンクをクリックする
    ならば "ジョブステータス変更"画面を表示していること

    もし "ステータス"として"正常終了"を選択する
    かつ "更新する"ボタンをクリックする
    ならば  "ジョブネット監視画面"が表示されていること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |正常終了  |表示 再実行  |
    |j2        |正常終了  |表示 再実行  |
    |j3        |正常終了  |表示 再実行  |
    |j4        |正常終了  |表示 再実行  |
    |finally   |正常終了  |表示 再実行  |
    |  jn0004_f|正常終了  |表示 再実行  |


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


