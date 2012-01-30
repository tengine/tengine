#language:ja
機能: アプリケーション運用者が状態不明になったジョブを再実行する

  ジョブ実行中にジョブが状態不明になった際に、
  アプリケーション運用者
  は、ジョブエージェントのプロセスが異常終了していることを確認した後、ジョブの再実行したい

  背景:ジョブ実行中にジョブエージェントが異常終了し、その後アプリケーション運用者がジョブの再実行する
    前提 "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ イベントキューにメッセージが1件もない
    かつ "Tengineコンソールプロセス"が起動している
    かつ テンプレートジョブが1件も登録されていない
    かつ 実行ジョブが1件もない
    かつ 仮想サーバがインスタンス識別子:"test_server1"で登録されている
    かつ 認証情報が名称:"test_credential1"で登録されている
    かつ "test_setver1"サーバにtengine_job_agentがインストールされている
    かつ "test_servet1"サーバに"test_credential1"認証情報にてログインできる

  @success
  @1000
  シナリオ: [異常系]ジョブの実行中にジョブエージェントのプロセスが異常終了した際、アプリケーション運用者がジョブの再実行をする

    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している
    かつ "Tengineハートビートウォッチャプロセス"が起動している

    #
    # ジョブの実行を行う
    #
    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J3_SLEEP=120"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                         |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する # j3 が実行中まで待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時                 |終了日時                 |ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|                         |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行  |

    #
    # tengine_job_agent_watchdog プロセスが実行中であることを確認し、kill する
    #
    もし "test_server1"サーバにログインする
    かつ `ps -ef | grep tengine_job_agent_watchdog | grep -v grep`コマンドを実行する
    ならば "tengine_job_agent_watchdog"プロセスが存在すること
    もし "tengine_job_agent_watchdog"のPIDを取得する

    # tengine_job_agent_watchdog を強制終了する
    もし `kill #{PID}`コマンド を実行する
    かつ `ps -ef | grep tengine_job_agent_watchdog | grep -v grep`コマンドを実行する
    ならば "tengine_job_agent_watchdog"プロセスが存在しないこと

    #
    # ジョブが「状態不明」になる
    #
    もし 20秒間待機する # tengine_heartbeat_watchd がジョブのハートビート異常を検知するのが20秒

    もし "実行中のジョブ一覧"画面を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明      |開始日時                 |終了日時 |ステータス                      |操作       |
    |  |jn0004        |jn0004    |yyyy-MM-dd HH:mm:ss +0900|         |実行中[状態が不明なジョブあり]  |監視 再実行|

    もし "jn0004"の"監視"リンクをクリックする
    ならば "ジョブネット監視"画面を表示していること
    かつ 以下の行が表示されていること # j3 のステータスが「状態不明」になっている
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時                 |終了日時                 |ステータス|次のジョブ|操作                       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j2, j3    |表示 再実行                |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j4        |表示 再実行                |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|                         |状態不明  |j4        |表示 ステータス変更 再実行 |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行                |
    |  |finally   |finally  |                             |test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行                |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行                |

    #
    # 状態不明のジョブが実行され、終了しているかを確認
    #
    もし 100秒間待機する # j3のスリープを120秒としているため。
    もし "test_server1"サーバにログインする
    かつ "~/tengine_job_test.log"を開く
    ならば 以下の記述があること # tengine_job_agent_watchdog が停止すると、スクリプトも停止するため、 /jn0004/j3 finish は出力されない
    """"""""""""""""""""""""""""""
    Mon Jan 30 15:13:20 JST 2012 tengine_job_test /jn0004/j1 start
    Mon Jan 30 15:13:20 JST 2012 tengine_job_test /jn0004/j1 finish
    Mon Jan 30 15:13:21 JST 2012 tengine_job_test /jn0004/j2 start
    Mon Jan 30 15:13:21 JST 2012 tengine_job_test /jn0004/j2 finish
    Mon Jan 30 15:13:23 JST 2012 tengine_job_test /jn0004/j3 start
    """"""""""""""""""""""""""""""

    もし `ps -ef | grep 0004_retry_one_layer.sh | grep -v grep`コマンドを実行する
    ならば "0004_retry_one_layer.sh"プロセスが存在しないこと

    #
    # 状態不明になったジョブのステータスをエラー終了に変更する
    #
    もし "実行中のジョブ一覧"画面を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明      |開始日時                 |終了日時 |ステータス                      |操作       |
    |  |jn0004        |jn0004    |yyyy-MM-dd HH:mm:ss +0900|         |実行中[状態が不明なジョブあり]  |監視 再実行|

    もし "jn0004"の"監視"リンクをクリックする
    ならば "ジョブネット監視"画面を表示していること
    かつ "j3"の"ステータス変更"リンクをクリックする
    ならば "ジョブステータス変更"画面を表示していること

    もし "ステータス"として"エラー終了"を選択する
    かつ "更新する"ボタンをクリックする
    ならば "ジョブネット監視"画面を表示していること
    かつ 以下の行が表示されていること # j4 のステータスが「正常終了」になっている
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時                 |終了日時                 |ステータス|次のジョブ|操作        |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j2, j3    |表示 再実行 |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j4        |表示 再実行 |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|                         |エラー終了|j4        |表示 再実行 |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行 |
    |  |finally   |finally  |                             |test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行 |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行 |

    #
    # ジョブの再実行を行う
    #
    もし "j3"の"再実行"ボタンをクリックする
    ならば "ジョブネット再実行設定"画面を表示していること
    もし "再実行方法"として"選択したジョブを起点をして再実行する。"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視"画面を表示していること
    かつ 以下の行が表示されていること #j4以降が正常終了となっている
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時                 |終了日時                 |ステータス|次のジョブ|操作          |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j2, j3    |表示 再実行   |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j4        |表示 再実行   |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|                         |実行中    |j4        |表示 強制停止 |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行   |
    |  |finally   |finally  |                             |test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行   |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                         |                         |初期化済  |          |表示 再実行   |


    ならば 以下の行が表示されていること #j4以降が正常終了となっている
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時                 |終了日時                 |ステータス|次のジョブ|操作        |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j2, j3    |表示 再実行 |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |j4        |表示 再実行 |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|                         |正常終了  |j4        |表示 再実行 |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |          |表示 再実行 |
    |  |finally   |finally  |                             |test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |          |表示 再実行 |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |          |表示 再実行 |

    もし "実行中のジョブ一覧"画面を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明      |開始日時                 |終了日時                 |ステータス|操作       |
    |  |jn0004        |jn0004    |yyyy-MM-dd HH:mm:ss +0900|yyyy-MM-dd HH:mm:ss +0900|正常終了  |監視 再実行|

    #
    # ジョブ実行サーバのログを確認
    #
    もし "test_server1"サーバにログインする
    かつ "~/tengine_job_test.log"を開く
    ならば 以下の記述があること # jn0004/j4 以降が実行されていることを確認する
    """"""""""""""""""""""""""""""
    Mon Jan 30 15:13:20 JST 2012 tengine_job_test /jn0004/j1 start
    Mon Jan 30 15:13:20 JST 2012 tengine_job_test /jn0004/j1 finish
    Mon Jan 30 15:13:21 JST 2012 tengine_job_test /jn0004/j2 start
    Mon Jan 30 15:13:21 JST 2012 tengine_job_test /jn0004/j2 finish
    Mon Jan 30 15:13:23 JST 2012 tengine_job_test /jn0004/j3 start
    Mon Jan 30 15:19:48 JST 2012 tengine_job_test /jn0004/j3 start
    Mon Jan 30 15:19:48 JST 2012 tengine_job_test /jn0004/j3 finish
    Mon Jan 30 15:19:50 JST 2012 tengine_job_test /jn0004/j4 start
    Mon Jan 30 15:19:50 JST 2012 tengine_job_test /jn0004/j4 finish
    Mon Jan 30 15:19:51 JST 2012 tengine_job_test /jn0004/finally/jn0004_f start
    Mon Jan 30 15:19:51 JST 2012 tengine_job_test /jn0004/finally/jn0004_f finish
    """"""""""""""""""""""""""""""
