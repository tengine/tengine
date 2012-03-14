language:ja
機能: アプリケーション運用者がジョブを強制停止する
  

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

# retry1

#指定したジョブのみ

#ルートジョブネット指定

  @4013
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @4068
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @4014
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @4015
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @4016
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

#-- finally --


  @4019
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @4071
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @4020
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

  @4072
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |正常終了  |監視 再実行|

#== retry2 ==


#指定したジョブのみ


  @4023
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @4024
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @4025
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


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


  @4031
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @4032
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @4033
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


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|



#ルートジョブネットを再実行

  @4037
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

#finally


  @4040
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|



# --- finally_in_finally



  @4043
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |エラー終了|監視 再実行|

  @4044
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

#-finally_in_finally



  @4046
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

#finally_in_finally_起点として



  @4048
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
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

  @4049
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|

#-finally_in_finally


  @4051
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |正常終了  |監視 再実行|


#==　retry3 ==
#--指定したジョブのみ--


  @4053
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

  @4054
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|



  @4056
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

  @4077
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|


  @4057
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

#ルートジョブネットを指定して再実行

  @4058
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

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0006        |jn0006|        |        |正常終了  |監視 再実行|

