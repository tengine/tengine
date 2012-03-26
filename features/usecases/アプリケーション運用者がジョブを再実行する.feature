language:ja
機能: アプリケーション運用者がジョブを再実行する
  

  おかしくなったジョブや誤ったジョブを強制停止したり、ジョブが失敗した場合
  アプリケーション運用者
  はジョブをリカバリして再実行したい

  背景:
    前提 日本語でアクセスする
    かつ tenginedハートビートの発火間隔が3と設定されている
    かつ "Tengineコアプロセス"が停止している
    かつ "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している
    かつ Tengine周辺のサーバの時刻が同期されている

  @04_01_01_01
  シナリオ: [正常系]fork前、ルートジョブネットの最初_指定したジョブのみ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ

    もし "j1"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j1_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_02
  シナリオ: [正常系]fork前、ルートジョブネットの最初_正常終了したジョブ_指定したジョブのみ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ

    もし "j1"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j1_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|


  @04_01_01_03
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_両方とも異常終了_片方のジョブを指定して再実行_指定したジョブのみ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true && export J3_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j2_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_04
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が異常終了、もう片方が正常終了_エラー終了したジョブを再実行_指定したジョブのみ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j2_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_05
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が異常終了、もう片方が正常終了_正常終了したジョブから再実行_指定したジョブのみ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ

    もし "j3"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j3_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_06
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_両方とも正常終了_片方のジョブを指定して再実行_指定したジョブのみ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j2_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_07
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が異常終了、もう片方が初期化済_指定したジョブのみ_追い越さない
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "事前実行コマンド"に"export J2_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j2_start_end_pid"が更新されていること

    もし "j3"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_08
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が正常終了、もう片方が実行中で、正常終了したジョブを再実行_指定したジョブのみ_追い越さない
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_SLEEP=20"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ

    もし "j3"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "事前実行コマンド"に"export J3_SLEEP=20"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j3_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_09
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が異常終了、もう片方が初期化済_指定したジョブのみ_再実行したジョブが追い越す
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "事前実行コマンド"に"export J2_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "j3"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "事前実行コマンド"に"export J3_SLEEP=30"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_10
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が正常終了、もう片方が実行中で、正常終了したジョブを再実行_指定したジョブのみ_追いぬく
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_SLEEP=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ

    もし "j3"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j3_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_11
  シナリオ: [正常系]フォークしたジョブの片方がエラー終了しており、もう片方のジョブが実行中に失敗したジョブのみを再実行する_再実行のジョブが先に終わる
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true && export J3_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    かつ 20秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    かつ 20秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j2_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|


  @04_01_01_12
  シナリオ: [正常系]fork前、ルートジョブネットの最初_指定したジョブ起点
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "j1"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j1_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_13
  シナリオ: [正常系]fork前、ルートジョブネットの最初_正常終了したジョブ_指定したジョブを起点
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ
    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ
    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ
    かつ "j4"の"開始日時","終了日時","PID"を"j4_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "j1"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    かつ "j1_start_end_pid"が更新されていること
    かつ "j2_start_end_pid"が更新されていること
    かつ "j3_start_end_pid"が更新されていること
    かつ "j4_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|


  @04_01_01_14
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_両方とも異常終了_片方のジョブを指定して再実行_指定したジョブを起点
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true && export J3_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "j2_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_15
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が異常終了、もう片方が正常終了_指定した正常終了したジョブを起点
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ

    もし "j3"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "j3_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_16
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方がエラー終了、もう片方が正常終了_指定した正常終了したジョブを起点
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了 |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ

    もし "j3"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "j3_start_end_pid"が更新されていること
    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j2_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|


  @04_01_01_17
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が異常終了、もう片方が初期化済
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "事前実行コマンド"に"export J2_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "j2_start_end_pid"が更新されていること
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "j3"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_18
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が異常終了、もう片方が初期化済_指定したジョブのみ_追い越す
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|


    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "事前実行コマンド"に"export J2_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "j3"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "事前実行コマンド"に"export J3_SLEEP=30"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |エラー終了|監視 再実行|

  @04_01_01_19
  シナリオ: [正常系]フォークしたジョブの片方がエラー終了しており、もう片方のジョブが実行中に失敗したジョブを起点に再実行する_再実行のジョブが先に終わる
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true && export J3_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    かつ 20秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点に再実行する"を選択する
    かつ "実行"ボタンをクリックする
    かつ 20秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j2_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_20
  シナリオ: [正常系]フォークしたジョブの片方が正常終了しており、もう片方のジョブが実行中に正常終了したジョブを起点に再実行する_再実行のジョブが先に終わる
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J3_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    かつ 20秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    かつ 20秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j2_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|


  @04_01_01_21
  シナリオ: [正常系]フォークしたジョブの片方が正常終了しており、もう片方のジョブが実行中に正常終了したジョブを起点に再実行する_再実行でないジョブが先に終わる
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J3_SLEEP=30"と入力する
    かつ "実行"ボタンをクリックする
    かつ 10秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ

    もし "j2"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "事前実行コマンド"に"export J2_SLEEP=30"と入力する
    かつ "実行"ボタンをクリックする
    かつ 20秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j2_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|


  @04_01_01_22
 シナリオ: [正常系]失敗したfinally内のジョブを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export JN0004_F_FAIL='true'"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|

    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004_f"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_23
 シナリオ: [正常系]正常終了したfinally内のジョブを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004_f"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_24
 シナリオ: [正常系]失敗したfinally内のジョブを起点にして再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export JN0004_F_FAIL='true'"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|

    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004_f"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_01_25
 シナリオ: [正常系]正常終了したfinally内のジョブを起点にして再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004_f"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|


  @04_01_01_26
  シナリオ: [正常系]エラー終了したジョブネット内のジョブを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J41_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ

    もし "j41"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_01_27
  シナリオ: [正常系]正常終了したジョブネット内の正常終了したジョブを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ

    もし "j41"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_01_28
  シナリオ: [正常系]エラー終了したジョブネット内の正常終了したジョブをしたジョブのみ再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J42_FAIL=true && export J43_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス  |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了   |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了    |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|

    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ

    もし "j41"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_01_29
  シナリオ: [正常系]エラー終了した後続のジョブネット内の初期化済のジョブを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ

    もし "j41"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_01_30
  シナリオ: [正常系]エラー終了した後続のジョブネットをジョブを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "j2の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_01_31
  シナリオ: [正常系]エラー終了した後続のジョブネットをジョブを指定して再実行_再実行したジョブが追い抜かれる
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|


    もし "j2の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "事前実行コマンド"に"export J2_SLEEP=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_01_32
  シナリオ: [正常系]エラー終了したジョブネット内のジョブを起点にして再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J41_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "j41"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end_pid"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_01_33
  シナリオ: [正常系]エラー終了したジョブネット内の正常終了したジョブを指定したジョブを起点に再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J42_FAIL=true && export J43_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了    |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "j42"の"開始日時","終了日時","PID"を"j42_start_end_pid"と呼ぶ
    かつ "j43"の"開始日時","終了日時","PID"を"j43_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "j41"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41_start_end_pid"が更新されていること
    かつ "j42_start_end_pid"が更新されていること
    かつ "j43_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_01_34
  シナリオ: [正常系]正常終了したジョブネット内の正常終了したジョブを指定したジョブを起点に再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了    |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了|j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了|j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "j42"の"開始日時","終了日時","PID"を"j42_start_end_pid"と呼ぶ
    かつ "j43"の"開始日時","終了日時","PID"を"j43_start_end_pid"と呼ぶ
    かつ "j44"の"開始日時","終了日時","PID"を"j44_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "j41"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j41_start_end_pid"が更新されていること
    かつ "j42_start_end_pid"が更新されていること
    かつ "j43_start_end_pid"が更新されていること
    かつ "j44_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_01_35
  シナリオ: [正常系]エラー終了した後続のジョブネット内の初期化済のジョブを起点にして再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "j41"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |エラー終了|監視 再実行|

  @04_01_01_36
  シナリオ: [正常系]エラー終了した後続のジョブネットをジョブを起点して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0005_fjn"の"開始日時","終了日時"を"jn0005_fjn_start_end"と呼ぶ
    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_f2"の"開始日時","終了日時","PID"を"jn0005_f2_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時","PID"を"jn0005_fjn_finally_start_end_pid"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ
    かつ "jn0005_f"の"開始日時","終了日時","PID"を"jn0005_f_start_end_pid"と呼ぶ

    もし "j2の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "finally_start_end"が更新されていること
    かつ "jn0005_fjn_start_end"が更新されていること
    かつ "jn0005_f1_start_end_pid"が更新されていること
    かつ "jn0005_f2_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること
    かつ "jn0005_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了|監視 再実行|

  @04_01_01_37
  シナリオ: [正常系]エラー終了した後続のジョブネットをジョブを起点にして再実行_再実行したジョブが追い抜かれる
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "j2の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "事前実行コマンド"に"export J2_SLEEP=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0005_fjn"の"開始日時","終了日時"を"jn0005_fjn_start_end"と呼ぶ
    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_f2"の"開始日時","終了日時","PID"を"jn0005_f2_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時","PID"を"jn0005_fjn_finally_start_end_pid"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ
    かつ "jn0005_f"の"開始日時","終了日時","PID"を"jn0005_f_start_end_pid"と呼ぶ

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "finally_start_end"が更新されていること
    かつ "jn0005_fjn_start_end"が更新されていること
    かつ "jn0005_f1_start_end_pid"が更新されていること
    かつ "jn0005_f2_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること
    かつ "jn0005_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了|監視 再実行|


  @04_01_01_38
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のジョブのみを再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J44_FAIL=true && export JN4_F_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "jn4_f"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |エラー終了|監視 再実行|

  @04_01_01_39
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のジョブを起点に再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J44_FAIL=true && export JN4_F_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "jn4_f"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了|監視 再実行|


  @04_01_01_40
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のジョブを起点に再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J44_FAIL=true && export JN4_F_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "jn4/finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |エラー終了|監視 再実行|


  @04_01_01_41
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のジョブのみを再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ

    もし "jn0005_f1"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中    |jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |jn0005_f2 |表示 強制停止|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_f1_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |エラー終了|監視 再実行|

  @04_01_01_42
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のfinallyのジョブのみを再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true && export JN0005_FIF_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ

    もし "jn0005_fif"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中    |jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fif_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_01_43
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のジョブを起点として再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ

    もし "jn0005_f1"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中    |jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |jn0005_f2 |表示 強制停止|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fif_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_01_44
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のfinally内のジョブを起点として再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true && export JN0005_FIF_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ

    もし "jn0005_fif"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中    |jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fif_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_01_45
  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをジョブを指定して再実行_指定したジョブのみ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |エラー終了|j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "j111"の"開始日時","終了日時","PID"を"j111_start_end_pid"と呼ぶ

    もし "j111"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "j111_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

  @04_01_01_46
  シナリオ: [正常系]正常終了したジョブネットの中のジョブネット内にある正常終了したジョブを指定して再実行_指定したジョブのみ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "j111"の"開始日時","終了日時","PID"を"j111_start_end_pid"と呼ぶ

    もし "j111"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "j111_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|


  @04_01_01_47
  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをジョブを指定して再実行_指定したジョブを起点
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |エラー終了|j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "j111"の"開始日時","終了日時","PID"を"j111_start_end_pid"と呼ぶ
    かつ "jn11_finally"の"開始日時","終了日時"を"jn11_finally_start_end"と呼ぶ
    かつ "jn11_f"の"開始日時","終了日時","PID"を"jn11_f_start_end_pid"と呼ぶ

    もし "j111"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "j111_start_end_pid"が更新されていること
    かつ "jn11_finally_start_end"が更新されていること
    かつ "jn11_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

  @04_01_01_48
  シナリオ: [正常系]正常終了したジョブネットの中のジョブネット内にある正常終了したジョブを指定して再実行_指定したジョブを起点
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "j111"の"開始日時","終了日時","PID"を"j111_start_end_pid"と呼ぶ
    かつ "j112"の"開始日時","終了日時","PID"を"j112_start_end_pid"と呼ぶ
    かつ "jn11_finally"の"開始日時","終了日時"を"jn11_finally_start_end"と呼ぶ
    かつ "jn11_f"の"開始日時","終了日時","PID"を"jn11_f_start_end_pid"と呼ぶ

    もし "j111"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "j111_start_end_pid"が更新されていること
    かつ "j112_start_end_pid"が更新されていること
    かつ "jn11_finally_start_end"が更新されていること
    かつ "jn11_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

#以下ジョブネットを再実行

  @04_01_02_01
 シナリオ: [正常系]失敗したfinallyを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export JN0004_F_FAIL='true'"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|

    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004/finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_02_02
 シナリオ: [正常系]正常終了したfinallyを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004/finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_02_03
 シナリオ: [正常系]失敗したfinallyを起点にして再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export JN0004_F_FAIL='true'"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|

    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004/finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_02_04
 シナリオ: [正常系]正常終了したfinallyを起点にして再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了|          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了|          |表示 再実行|

    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004/finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|


  @04_01_02_05
  シナリオ: [正常系]エラー終了したジョブネット内のジョブをジョブネットを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J41_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4"の"開始日時","終了日時"を"jn4_start_end"と呼ぶ
    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_start_end"が更新されていること
    かつ "j41_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_02_06
  シナリオ: [正常系]正常終了したジョブネットを指定して再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4"の"開始日時","終了日時"を"jn4_start_end"と呼ぶ
    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "j42"の"開始日時","終了日時","PID"を"j42_start_end_pid"と呼ぶ
    かつ "j43"の"開始日時","終了日時","PID"を"j43_start_end_pid"と呼ぶ
    かつ "j44"の"開始日時","終了日時","PID"を"j44_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_start_end"が更新されていること
    かつ "j41_start_end_pid"が更新されていること
    かつ "j42_start_end_pid"が更新されていること
    かつ "j43_start_end_pid"が更新されていること
    かつ "j44_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_02_07
  シナリオ: [正常系]エラー終了したジョブネット内のジョブをジョブネットを指定して再実行_forkしたジョブが実行中
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J41_FAIL=true && export J2_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "jn4"の"開始日時","終了日時"を"jn4_start_end"と呼ぶ
    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_start_end"が更新されていること
    かつ "j41_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_02_08
  シナリオ: [正常系]エラー終了したジョブネット内のジョブをジョブネットを起点にして再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J41_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4"の"開始日時","終了日時"を"jn4_start_end"と呼ぶ
    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0005_fjn"の"開始日時","終了日時"を"jn0005_fjn_start_end"と呼ぶ
    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_f2"の"開始日時","終了日時","PID"を"jn0005_f2_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ
    かつ "jn0005_f"の"開始日時","終了日時","PID"を"jn0005_f_start_end_pid"と呼ぶ

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_start_end"が更新されていること
    かつ "j41_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0005_fjn_start_end"が更新されていること
    かつ "jn0005_f1_start_end_pid"が更新されていること
    かつ "jn0005_f2_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること
    かつ "jn0005_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_02_09
  シナリオ: [正常系]正常終了したジョブネットを起点にして再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4"の"開始日時","終了日時"を"jn4_start_end"と呼ぶ
    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "j42"の"開始日時","終了日時","PID"を"j42_start_end_pid"と呼ぶ
    かつ "j43"の"開始日時","終了日時","PID"を"j43_start_end_pid"と呼ぶ
    かつ "j44"の"開始日時","終了日時","PID"を"j44_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ
    かつ "j4"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0005_fjn"の"開始日時","終了日時"を"jn0005_fjn_start_end"と呼ぶ
    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_f2"の"開始日時","終了日時","PID"を"jn0005_f2_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ
    かつ "jn0005_f"の"開始日時","終了日時","PID"を"jn0005_f_start_end_pid"と呼ぶ

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_start_end"が更新されていること
    かつ "j41_start_end_pid"が更新されていること
    かつ "j42_start_end_pid"が更新されていること
    かつ "j43_start_end_pid"が更新されていること
    かつ "j44_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること
    かつ "j4_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0005_fjn_start_end"が更新されていること
    かつ "jn0005_f1_start_end_pid"が更新されていること
    かつ "jn0005_f2_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること
    かつ "jn0005_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_02_10
  シナリオ: [正常系]エラー終了したジョブネット内のジョブをジョブネットを起点にして再実行_forkしたジョブが実行中
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J41_FAIL=true  && export J2_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行  |
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    かつ "jn4"の"開始日時","終了日時"を"jn4_start_end"と呼ぶ
    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "jn4"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42, j43  |表示 強制停止|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_start_end"が更新されていること
    かつ "j41_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_02_11
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinallyを再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J44_FAIL=true && export JN4_F_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ

    もし "jn4/finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_02_12
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のジョブネットのみを再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fjn"の"開始日時","終了日時"を"jn0005_fjn_start_end"と呼ぶ
    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ

    もし "jn0005_fjn"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中    |jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |jn0005_f2 |表示 強制停止|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fjn_start_end"が更新されていること
    かつ "jn0005_f1_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |エラー終了|監視 再実行|

  @04_01_02_13
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinallyのみを再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0005_fjn"の"開始日時","終了日時"を"jn0005_fjn_start_end"と呼ぶ
    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ

    もし "finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中    |jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |jn0005_f2 |表示 強制停止|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス  |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了    |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了    |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了    |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|

    かつ "finally_start_end"が更新されていること
    かつ "jn0005_fjn_start_end"が更新されていること
    かつ "jn0005_f1_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_02_14
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のfinallyを再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ

    もし "jn0005_fjn/finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_02_15
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のジョブネットを起点として再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fjn"の"開始日時","終了日時"を"jn0005_fjn_start_end"と呼ぶ
    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ

    もし "jn0005_fjn"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを基点としてを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中    |jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |jn0005_f2 |表示 強制停止|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "jn0005_fjn_start_end"が更新されていること
    かつ "jn0005_f1_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_02_16
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinallyを起点として再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0005_fjn"の"開始日時","終了日時"を"jn0005_fjn_start_end"と呼ぶ
    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ

    もし "finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中    |jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |jn0005_f2 |表示 強制停止|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス  |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了    |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了    |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了    |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了    |          |表示 再実行|

    かつ "finally_start_end"が更新されていること
    かつ "jn0005_fjn_start_end"が更新されていること
    かつ "jn0005_f1_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_02_17
  シナリオ: [正常系]ジョブネット内のfinallyが失敗し、失敗したfinally内のfinallyを起点として再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_FAIL=true && export JN0005_F1_FAIL=true && export JN0005_FIF_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ

    もし "jn0005_fjn/finally"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中    |jn0005_f  |表示 強制停止|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @04_01_02_18
  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをジョブを指定して再実行_ジョブネット内のジョブネットのみ再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |エラー終了|j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn11"の"開始日時","終了日時"を"jn11_start_end"と呼ぶ
    かつ "j111"の"開始日時","終了日時","PID"を"j111_start_end_pid"と呼ぶ
    かつ "jn11_finally"の"開始日時","終了日時"を"jn11_finally_start_end"と呼ぶ
    かつ "jn11_f"の"開始日時","終了日時","PID"を"jn11_f_start_end_pid"と呼ぶ

    もし "jn11"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn11_start_end"が更新されていること
    かつ "j111_start_end_pid"が更新されていること
    かつ "jn11_finally_start_end"が更新されていること
    かつ "jn11_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

  @04_01_02_19
  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをジョブを指定して再実行_最上位のジョブネットを再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |エラー終了|j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn1"の"開始日時","終了日時"を"jn1_start_end"と呼ぶ
    かつ "jn11"の"開始日時","終了日時"を"jn11_start_end"と呼ぶ
    かつ "j111"の"開始日時","終了日時","PID"を"j111_start_end_pid"と呼ぶ
    かつ "jn11_finally"の"開始日時","終了日時"を"jn11_finally_start_end"と呼ぶ
    かつ "jn11_f"の"開始日時","終了日時","PID"を"jn11_f_start_end_pid"と呼ぶ
    かつ "jn1_finally"の"開始日時","終了日時"を"jn1_finally_start_end"と呼ぶ
    かつ "jn_1f"の"開始日時","終了日時","PID"を"jn_1f_start_end_pid"と呼ぶ

    もし "jn1"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブのみを再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn1_start_end_pid"が更新されていること
    かつ "jn11_start_end"が更新されていること
    かつ "j111_start_end_pid"が更新されていること
    かつ "jn11_finally_start_end"が更新されていること
    かつ "jn11_f_start_end_pid"が更新されていること
    かつ "jn1_finally_start_end"が更新されていること
    かつ "jn_1f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|


  @04_01_02_20
  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをジョブを指定して再実行_ジョブネット内のジョブネットのみ再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |エラー終了|j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn11"の"開始日時","終了日時"を"jn11_start_end"と呼ぶ
    かつ "j111"の"開始日時","終了日時","PID"を"j111_start_end_pid"と呼ぶ
    かつ "jn11_finally"の"開始日時","終了日時"を"jn11_finally_start_end"と呼ぶ
    かつ "jn11_f"の"開始日時","終了日時","PID"を"jn11_f_start_end_pid"と呼ぶ
    かつ "jn1_finally"の"開始日時","終了日時"を"jn1_finally_start_end"と呼ぶ
    かつ "jn_1f"の"開始日時","終了日時","PID"を"jn_1f_start_end_pid"と呼ぶ

    もし "jn11"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブと起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn11_start_end"が更新されていること
    かつ "j111_start_end_pid"が更新されていること
    かつ "jn11_finally_start_end"が更新されていること
    かつ "jn11_f_start_end_pid"が更新されていること
    かつ "jn1_finally_start_end"が更新されていること
    かつ "jn_1f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

  @04_01_02_21
  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをジョブを指定して再実行_ジョブネット内のジョブネットを起点として再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn22"の"開始日時","終了日時"を"jn22_start_end"と呼ぶ
    かつ "j221"の"開始日時","終了日時","PID"を"j221_start_end_pid"と呼ぶ
    かつ "j222"の"開始日時","終了日時","PID"を"j222_start_end_pid"と呼ぶ
    かつ "jn22_finally"の"開始日時","終了日時"を"jn22_finally_start_end"と呼ぶ
    かつ "jn22_f"の"開始日時","終了日時","PID"を"jn22_f_start_end_pid"と呼ぶ
    かつ "jn2_finally"の"開始日時","終了日時"を"jn2_finally_start_end"と呼ぶ
    かつ "jn_2f"の"開始日時","終了日時","PID"を"jn_2f_start_end_pid"と呼ぶ

    もし "jn22"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |実行中    |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn22_start_end_pid"が更新されていること
    かつ "j221_start_end_pid"が更新されていること
    かつ "j222_start_end_pid"が更新されていること
    かつ "jn22_finally_start_end_pid"が更新されていること
    かつ "jn22_f_start_end_pid"が更新されていること
    かつ "jn2_finally_start_end_pid"が更新されていること
    かつ "jn_2f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|


  @04_01_02_22
  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをジョブを指定して再実行_最上位のジョブネットを再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |エラー終了|j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn1"の"開始日時","終了日時"を"jn1_start_end"と呼ぶ
    かつ "jn11"の"開始日時","終了日時"を"jn11_start_end"と呼ぶ
    かつ "j111"の"開始日時","終了日時","PID"を"j111_start_end_pid"と呼ぶ
    かつ "jn11_finally"の"開始日時","終了日時"を"jn11_finally_start_end"と呼ぶ
    かつ "jn11_f"の"開始日時","終了日時","PID"を"jn11_f_start_end_pid"と呼ぶ
    かつ "jn1_finally"の"開始日時","終了日時"を"jn1_finally_start_end"と呼ぶ
    かつ "jn_1f"の"開始日時","終了日時","PID"を"jn_1f_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn_f"の"開始日時","終了日時","PID"を"jn_f_start_end_pid"と呼ぶ

    もし "jn1"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "再実行方法"の"選択したジョブを起点として再実行する"を選択する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn1_start_end_pid"が更新されていること
    かつ "jn11_start_end"が更新されていること
    かつ "j111_start_end_pid"が更新されていること
    かつ "jn11_finally_start_end"が更新されていること
    かつ "jn11_f_start_end_pid"が更新されていること
    かつ "jn1_finally_start_end"が更新されていること
    かつ "jn_1f_start_end_pid"が更新されていること
    かつ "finally_start_end_pid"が更新されていること
    かつ "jn_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

##以下ルートジョブネットを再実行


  @04_01_03_01
  シナリオ: [正常系]fork前、ルートジョブネットの最初_ルートジョブネット指定
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |エラー終了|監視 再実行|

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j1_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_03_02
  シナリオ: [正常系]fork前、ルートジョブネットの最初_正常終了したルートジョブネット指定
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了|監視 再実行|

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ
    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ
    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ
    かつ "j4"の"開始日時","終了日時","PID"を"j4_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j1_start_end_pid"が更新されていること
    かつ "j2_start_end_pid"が更新されていること
    かつ "j3_start_end_pid"が更新されていること
    かつ "j4_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_03_03
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_両方とも異常終了_片方のジョブを指定して再実行_ルートジョブネットを再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true && export J3_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |エラー終了|監視 再実行|

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ
    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ
    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j1_start_end_pid"が更新されていること
    かつ "j2_start_end_pid"が更新されていること
    かつ "j3_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_03_04
  シナリオ: [正常系]fork前、ルートジョブネットの最初_forkしたジョブ_片方が異常終了、もう片方が正常終了_ルートジョブネットを再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |エラー終了|監視 再実行|

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ
    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ
    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j1_start_end_pid"が更新されていること
    かつ "j2_start_end_pid"が更新されていること
    かつ "j3_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @04_01_03_05
  シナリオ: [正常系]フォークしたジョブの片方のジョブがエラー終了しており、もう片方のジョブが実行中でルートジョブネットを再実行する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_FAIL=true && export J3_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス        |操作         |
    |  |jn0004        |jn0004|        |        |実行中(エラーあり)|強制停止 監視|

    もし 50秒間待機する
    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |エラー終了|監視 再実行|

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ
    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ
    かつ "j3"の"開始日時","終了日時","PID"を"j3_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0004_f"の"開始日時","終了日時","PID"を"jn0004_f_start_end_pid"と呼ぶ

    もし "jn0004"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j1_start_end_pid"が更新されていること
    かつ "j2_start_end_pid"が更新されていること
    かつ "j3_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0004_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

#-- finally --



#ルートジョブネットを再実行

  @04_01_03_06
  シナリオ: [正常系]エラー終了したジョブネット内のジョブが失敗している状態でルートジョブネットを再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0005        |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J41_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |エラー終了|監視 再実行|

    かつ "j1"の"開始日時","終了日時","PID"を"j1_start_end_pid"と呼ぶ
    かつ "j2"の"開始日時","終了日時","PID"を"j2_start_end_pid"と呼ぶ
    かつ "jn4"の"開始日時","終了日時"を"jn4_start_end"と呼ぶ
    かつ "j41"の"開始日時","終了日時","PID"を"j41_start_end_pid"と呼ぶ
    かつ "jn4_finally"の"開始日時","終了日時"を"jn4_finally_start_end"と呼ぶ
    かつ "jn4_f"の"開始日時","終了日時","PID"を"jn4_f_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn0005_fjn"の"開始日時","終了日時"を"jn0005_fjn_start_end"と呼ぶ
    かつ "jn0005_f1"の"開始日時","終了日時","PID"を"jn0005_f1_start_end_pid"と呼ぶ
    かつ "jn0005_f2"の"開始日時","終了日時","PID"を"jn0005_f2_start_end_pid"と呼ぶ
    かつ "jn0005_fjn_finally"の"開始日時","終了日時"を"jn0005_fjn_finally_start_end"と呼ぶ
    かつ "jn0005_fif"の"開始日時","終了日時","PID"を"jn0005_fif_start_end_pid"と呼ぶ
    かつ "jn0005_f"の"開始日時","終了日時","PID"を"jn0005_f_start_end_pid"と呼ぶ

    もし "jn0005"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42, j43  |表示 再実行  |
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j44       |表示 再実行  |
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済  |jn0005_f  |表示 再実行  |
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn0005_f2 |表示 再実行  |
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j42, j43  |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |正常終了  |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|

    かつ "j1_start_end_pid"が更新されていること
    かつ "j2_start_end_pid"が更新されていること
    かつ "jn4_start_end"が更新されていること
    かつ "j41_start_end_pid"が更新されていること
    かつ "jn4_finally_start_end"が更新されていること
    かつ "jn4_f_start_end_pid"が更新されていること
    かつ "finally_start_end"が更新されていること
    かつ "jn0005_fjn_start_end"が更新されていること
    かつ "jn0005_f1_start_end_pid"が更新されていること
    かつ "jn0005_f2_start_end_pid"が更新されていること
    かつ "jn0005_fjn_finally_start_end"が更新されていること
    かつ "jn0005_fif_start_end_pid"が更新されていること
    かつ "jn0005_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @04_01_03_7
  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをジョブを指定して再実行_最上位のジョブネットを再実行
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了|jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |エラー終了|j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |エラー終了|監視 再実行|

    かつ "jn1"の"開始日時","終了日時"を"jn1_start_end"と呼ぶ
    かつ "jn11"の"開始日時","終了日時"を"jn11_start_end"と呼ぶ
    かつ "j111"の"開始日時","終了日時","PID"を"j111_start_end_pid"と呼ぶ
    かつ "jn11_finally"の"開始日時","終了日時"を"jn11_finally_start_end"と呼ぶ
    かつ "jn11_f"の"開始日時","終了日時","PID"を"jn11_f_start_end_pid"と呼ぶ
    かつ "jn1_finally"の"開始日時","終了日時"を"jn1_finally_start_end"と呼ぶ
    かつ "jn_1f"の"開始日時","終了日時","PID"を"jn_1f_start_end_pid"と呼ぶ
    かつ "finally"の"開始日時","終了日時"を"finally_start_end"と呼ぶ
    かつ "jn_f"の"開始日時","終了日時","PID"を"jn_f_start_end_pid"と呼ぶ

    もし "jn0006"の"再実行"リンクをクリックする
    ならば "ジョブネット再実行設定画面"を表示していること

    もし "ジョブネット再実行設定画面"を表示する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中    |j12       |表示 強制停止|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn22      |表示 再実行  |
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j222      |表示 再実行  |
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  | 

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |正常終了  |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行|  
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行| 

    かつ "jn1_start_end_pid"が更新されていること
    かつ "jn11_start_end"が更新されていること
    かつ "j111_start_end_pid"が更新されていること
    かつ "jn11_finally_start_end"が更新されていること
    かつ "jn11_f_start_end_pid"が更新されていること
    かつ "jn1_finally_start_end"が更新されていること
    かつ "jn_1f_start_end_pid"が更新されていること
    かつ "finally_start_end_pid"が更新されていること
    かつ "jn_f_start_end_pid"が更新されていること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|