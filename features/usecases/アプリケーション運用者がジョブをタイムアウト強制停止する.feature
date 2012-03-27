#language:ja
機能: アプリケーション運用者がジョブをタイムアウト強制停止する


  ジョブの実行時間が正常な動作ではあり得ないほど長い場合
  アプリケーション運用者
  はジョブを自動的に強制停止したい

  背景:
    前提 日本語でアクセスする
    かつ tenginedハートビートの発火間隔が3と設定されている
    かつ "Tengineコアプロセス"が停止している
    かつ "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している
    かつ Tengine周辺のサーバの時刻が同期されている
    かつ "Tengineスケジュールキーパープロセス"が起動している

  @05_01_01_01
  シナリオ: [正常系]fork前、ルートジョブネットの最初
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
    かつ "強制停止設定"に1と入力する
    かつ "事前実行コマンド"に"export J1_SLEEP=120"と入力する

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

    もし 70秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了(タイムアウト強制停止済)|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0004        |jn0004|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

    もし "イベント一覧画面"を表示する
    ならば 以下の行のように同じイベントキーのstop.execution.job.tengineが1件だけ表示されていること
    |種別名                     |イベントキー|
    |stop.execution.job.tengine| #{unique_event_key}|


  @05_01_01_02
  シナリオ: [正常系]実行中のジョブが２つで２つともタイムアウト強制停止
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
    かつ "強制停止設定"に1と入力する
    かつ "事前実行コマンド"に"export J2_SLEEP=120 && export J3_SLEEP=120"と入力する

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 70秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0004        |jn0004|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

  @05_01_01_03
  シナリオ: [正常系]実行中のジョブが1つで片方が正常終了している状態でタイムアウト強制停止
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
    かつ "強制停止設定"に1と入力する
    かつ "事前実行コマンド"に"export J2_SLEEP=120"と入力する

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 70秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0004        |jn0004|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

  @05_01_01_04
  シナリオ: [正常系]実行中のジョブが1つで片方がエラー終了している状態でタイムアウト強制停止
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
    かつ "強制停止設定"に1と入力する
    かつ "事前実行コマンド"に"export J2_SLEEP=120 && export J3_FAIL='true'"と入力する

    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |実行中    |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |j4        |表示 強制停止|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了|j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 70秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了            |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0004        |jn0004|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

  @05_01_01_05
  シナリオ: [正常系]finally実行中にタイムアウト強制停止
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
    かつ "強制停止設定"に1と入力する
    かつ "事前実行コマンド"に"export JN0004_F_SLEEP=120"と入力する

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
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, j3    |表示 再実行  |
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |実行中    |          |表示 強制停止|

    もし 70秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |正常終了              |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0004        |jn0004|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|


#--retry2--
  @05_01_01_06
  シナリオ: [正常系]ルートジョブネット内のジョブネット内のジョブ
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
    かつ "事前実行コマンド"に"export J41_SLEEP=120"と入力する
    かつ "強制停止設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |準備中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42,j43   |表示 再実行  |
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
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了  |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中    |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中    |j42,j43   |表示 再実行  |
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

    もし 50秒間待機する
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス          |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了            |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了            |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |タイムアウト強制停止|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |タイムアウト強制停止|j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済            |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0005        |jn0005|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

  @05_01_01_07
  シナリオ: [正常系]ルートジョブネット内のジョブネット内で実行中のジョブが２つ
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
    かつ "事前実行コマンド"に"export J42_SLEEP=120 && export J43_SLEEP=120"と入力する
    かつ "強制停止設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |準備中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42,j43   |表示 再実行  |
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
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中                |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中                |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中                |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済              |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし 50秒間待機する
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済              |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0005        |jn0005|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

  @05_01_01_08
  シナリオ: [正常系]ルートジョブネット内のジョブネット内で実行中のジョブが1つ_フォークしたジョブのうち片方が正常終了もう片方が実行中
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
    かつ "事前実行コマンド"に"export J42_SLEEP=120"と入力する
    かつ "強制停止設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |準備中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42,j43   |表示 再実行  |
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
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了     |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中       |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中       |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済     |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|

    もし 50秒間待機する
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済              |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0005        |jn0005|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

  @05_01_01_09
  シナリオ: [正常系]ルートジョブネット内のジョブネット内で実行中のジョブが1つ_フォークしたジョブのうち片方がエラー終了もう片方が実行中
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
    かつ "事前実行コマンド"に"export J42_SLEEP=120 && export J43_FAIL='true'"と入力する
    かつ "強制停止設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |準備中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42,j43   |表示 再実行  |
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
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了     |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中       |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中       |j44   |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中|j44   |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済     |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|

    もし 50秒間待機する
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了            |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済              |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0005        |jn0005|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

  @05_01_01_10
  シナリオ: [正常系]ルートジョブネット内のジョブネット内のfinallyが実行中にタイムアウト強制停止
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
    かつ "事前実行コマンド"に"export J44_FAIL='true' && export JN4_F_SLEEP=120"と入力する
    かつ "強制停止設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |準備中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42,j43   |表示 再実行  |
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
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了     |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中       |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了    |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |実行中       |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中       |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済     |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|

    もし 50秒間待機する
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了            |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済              |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0005        |jn0005|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

  @05_01_01_11
  シナリオ: [正常系]ルートジョブネット内のジョブネット内のfinallyのfinallyが実行中にタイムアウト強制停止
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
    かつ "事前実行コマンド"に"export J44_FAIL='true' && export JN0005_F2_FAIL='true' &&  export JN0005_FIF_SLEEP=120"と入力する
    かつ "強制停止設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |準備中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42,j43   |表示 再実行  |
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
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了     |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了   |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了   |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了     |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |実行中       |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |実行中       |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了     |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了    |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |実行中       |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |実行中       |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済     |          |表示 再実行|

    もし 50秒間待機する
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了              |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了            |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了            |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |正常終了              |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |正常終了              |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了            |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0005        |jn0005|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

  @05_01_01_12
  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブを実行中にタイムアウト強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0006        |jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること
    かつ "強制停止設定"に"1"と入力する
    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_SLEEP=120"と入力する

    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |準備中    |jn2       |表示 強制停止|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |準備中    |j12       |表示         |
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |準備中    |j112      |表示 強制停止|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済  |finally   |表示 再実行  |
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済  |jn11_f    |表示 再実行  |
    |  |  j12       |j12    |                               |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
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

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |実行中      |jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |実行中      |j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |実行中      |j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済    |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済    |          |表示 再実行|

    もし 50秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名    |説明   |実行スクリプト                 |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |jn1         |jn1    |                               |test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了(タイムアウト強制停止済)|jn2       |表示 再実行|
    |  |  jn11      |jn11   |                               |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j12       |表示 再実行|
    |  |    j111    |j111   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j112      |表示 再実行|
    |  |    j112    |j112   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済              |finally   |表示 再実行|
    |  |      jn11_f|jn11_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |jn11_f    |表示 再実行|
    |  |  j12       |j12    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    jn_1f   |jn_1f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |jn2         |jn2    |                               |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  j21       |j21    |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |jn22      |表示 再実行|
    |  |  jn22      |jn22   |                               |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    j221    |j221   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |j222      |表示 再実行|
    |  |    j222    |j222   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    finally |finally|                               |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |      jn22_f|jn22_f |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  finally   |finally|                               |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |    jn_2f   |jn_2f  |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally     |finally|                               |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn_f      |jn_f   |$HOME/0006_retry_three_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0006        |jn0006|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|


#== startingからdying ==
#ここから下のDSLを実行する場合は、features/script/tengine_job_agebt_run_proxyをジョブ実行サーバのジョブ実行ユーザの優先度が最も高いパスに配置します
#ジョブ実行サーバのジョブ実行ユーザの~/bash_profileに~/binあたりをパスに追加して、ファイルを配置するのが無難です
#retry1
  @05_01_01_13
  シナリオ: [正常系]ジョブの状態が「開始中」で強制停止を行う
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
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=80 && export J1_SLEEP=120"と入力する
    かつ "強制停止設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |開始中    |j2, j3    |表示 強制停止|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済  |          |表示 再実行  |

    もし 70秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス            |次のジョブ|操作       |
    |  |j1        |j1       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |エラー終了(タイムアウト強制停止済)|j2, j3    |表示 再実行|
    |  |j2        |j2       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |j4        |表示 再実行|
    |  |j3        |j3       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |j4        |表示 再実行|
    |  |j4        |j4       |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |finally   |finally  |                             |test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|
    |  |  jn0004_f|jn_0004_f|$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|                   |        |初期化済              |          |表示 再実行|

    # Execution
    もし 実行ジョブ"jn0004"のExecutionを"execution"と呼ぶことにする
    # /jobnet1001 => jn0004
    かつ 実行ジョブ"jn0004"のルートジョブネット"/jn0004"を"root_jobnet"と呼ぶことにする
    # next!start@/jn0004 => e1
    かつ 実行ジョブ"jn0004"のエッジ"next!start@/jn0004"を"e1"と呼ぶことにする
    # /jn0004/j1 => j1
    もし 実行ジョブ"jn0004"のジョブ"/jn0004/j1"を"j1"と呼ぶことにする
    # next!/jn0004/j1 => e2
    かつ 実行ジョブ"jn0004"のエッジ"next!/jn0004/j1"を"e2"と呼ぶことにする

    # prev!/jn0004/j2 => e3
    かつ 実行ジョブ"jn0004"のエッジ"prev!/jn0004/j2"を"e3"と呼ぶことにする
    # /jn0004/j2 => j2
    もし 実行ジョブ"jn0004"のジョブ"/jn0004/j2"を"j2"と呼ぶことにする
    # next!/jn0004/j2 => e4
    かつ 実行ジョブ"jn0004"のエッジ"next!/jn0004/j2"を"e4"と呼ぶことにする

    # prev!/jn0004/j3 => e5
    かつ 実行ジョブ"jn0004"のエッジ"prev!/jn0004/j3"を"e5"と呼ぶことにする
    # /jn0004/j3 => j3
    もし 実行ジョブ"jn0004"のジョブ"/jn0004/j3"を"j3"と呼ぶことにする
    # next!/jn0004/j3 => e6
    かつ 実行ジョブ"jn0004"のエッジ"next!/jn0004/j3"を"e6"と呼ぶことにする

    # prev!/jn0004/j4 => e7
    かつ 実行ジョブ"jn0004"のエッジ"prev!/jn0004/j4"を"e7"と呼ぶことにする
    # /jn0004/j4 => j4
    もし 実行ジョブ"jn0004"のジョブ"/jn0004/j4"を"j4"と呼ぶことにする
    # next!/jn0004/j4 => e8
    かつ 実行ジョブ"jn0004"のエッジ"next!/jn0004/j4"を"e8"と呼ぶことにする

    # /jn0004/finally => finally
    もし 実行ジョブ"jn0004"のジョブ"/jn0004/finally"を"finally"と呼ぶことにする
    # prev!/jn0004/finally/jn0004_f => e9
    かつ 実行ジョブ"jn0004"のエッジ"prev!/jn0004/finally/jn0004_f"を"e9"と呼ぶことにする
    # /jn0004/finally/jn0004_f => jn0004
    もし 実行ジョブ"jn0004"のジョブ"/jn0004/finally/jn0004_f"を"jn0004_f"と呼ぶことにする
    # next!/jn0004/finally/jn0004_f => e10
    かつ 実行ジョブ"jn0004"のエッジ"next!/jn0004/finally/jn0004_f"を"e10"と呼ぶことにする


    # receive event "start.execution.job.tengine"
    ならば "Tengineコアプロセス"のアプリケーションログに"#{execution} initialized -> ready"とジョブのフェーズが変更した情報が出力されていること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{execution} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{execution} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} initialized -> ready"とジョブのフェーズが変更した情報が出力されており、"#{execution} ready -> starting"の後であること

    # receive event "start.jobnet.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{execution} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} ready -> starting"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e1} active -> transmitting"とジョブのフェーズが変更した情報が出力されており、"#{execution} starting -> running"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j1} initialized -> ready"とジョブのフェーズが変更した情報が出力されており、"#{e1} active -> transmitting"の後であること

    # receive event "start.job.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e1} transmitting -> transmitted"とジョブのフェーズが変更した情報が出力されており、"#{j1} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j1} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{e1} transmitting -> transmitted"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{j1} ready -> starting"の後であること
    # SSH接続してジョブを実行しようとする

    # receive event "stop.execution.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} running -> dying"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} starting -> running"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e2} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} starting -> running"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e2} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e3} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e3} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e3} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e4} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{e3} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e4} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e4} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e5} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e5} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e5} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e6} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{e5} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e6} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e6} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e7} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{e4} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e7} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e7} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e7} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{e6} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e7} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e7} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e8} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{e7} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e8} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e8} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e9} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e9} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e10} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e10} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> closing"の後であること

    #SSH接続先でジョブが実行されてpidが帰ってくる
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j1} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> closing"の後であること

    # receive event "stop.job.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j1} running -> dying"とジョブのフェーズが変更した情報が出力されており、"#{j1} starting -> running"の後であること

    # receive event "finished.process.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j1} dying -> error"とジョブのフェーズが変更した情報が出力されており、"#{j1} running -> dying"の後であること

    # receive event "error.jobnet.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} dying -> error"とジョブのフェーズが変更した情報が出力されており、"#{j1} dying -> error"の後であること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0004        |jn0004|        |        |強制停止済|監視 再実行|


#--retry2
  @05_01_01_14
  シナリオ: [正常系]ルートジョブネット内のジョブネット内のジョブ
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
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=30 && export J41_SLEEP=120"と入力する
    かつ "強制停止設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス|次のジョブ|操作         |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |準備中    |j2, jn4   |表示 強制停止|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |初期化済  |j4        |表示 再実行  |
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済  |j42,j43   |表示 再実行  |
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

    もし 35秒間待機する
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス          |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了   |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |開始中     |j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |実行中     |j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |開始中     |j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済   |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済   |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済   |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済   |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済   |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済   |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済   |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済   |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済   |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済   |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済   |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済   |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済   |          |表示 再実行|

    もし 25秒間待機する
    かつ 以下の行が表示されていること
    |ID|ジョブ名        |説明       |実行スクリプト               |接続サーバ名|認証情報名      |開始日時           |終了日時|ステータス          |次のジョブ|操作       |
    |  |j1              |j1         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|        |正常終了            |j2, jn4   |表示 再実行|
    |  |j2              |j2         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |jn4             |jn4        |                             |test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j4        |表示 再実行|
    |  |  j41           |j41        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |エラー終了(タイムアウト強制停止済)|j42,j43   |表示 再実行|
    |  |  j42           |j42        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |j44       |表示 再実行|
    |  |  j43           |j43        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |j44       |表示 再実行|
    |  |  j44           |j44        |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |  finally       |finally    |                             |test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |    jn4_f       |jn4_f      |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |j4              |j4         |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |finally         |finally    |                             |test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |  jn0005_fjn    |jn_0005_fjn|                             |test_server1|test_credential1|                   |        |初期化済            |jn0005_f  |表示 再実行|
    |  |    jn0005_f1   |jn_0005_f1 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |jn0005_f2 |表示 再実行|
    |  |    jn0005_f2   |jn_0005_f2 |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |    finally     |finally    |                             |test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |      jn0005_fif|jn_0005_fif|$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|
    |  |  jn0005_f      |jn_0005_f  |$HOME/0005_retry_two_layer.sh|test_server1|test_credential1|                   |        |初期化済            |          |表示 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jn0005        |jn0005|        |        |エラー終了(タイムアウト強制停止済)|監視 再実行|

    # Execution
    もし 実行ジョブ"jn0005"のExecutionを"execution"と呼ぶことにする
    # /jobnet1001 => jn0005
    かつ 実行ジョブ"jn0005"のルートジョブネット"/jn0005"を"root_jobnet"と呼ぶことにする
    # next!start@/jn0005 => e1
    かつ 実行ジョブ"jn0005"のエッジ"next!start@/jn0005"を"e1"と呼ぶことにする
    # /jn0005/j1 => j1
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/j1"を"j1"と呼ぶことにする
    # next!/jn0005/j1 => e2
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/j1"を"e2"と呼ぶことにする

    # prev!/jn0005/j2 => e3
    かつ 実行ジョブ"jn0005"のエッジ"prev!/jn0005/j2"を"e3"と呼ぶことにする
    # /jn0005/j2 => j2
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/j2"を"j2"と呼ぶことにする
    # next!/jn0005/j2 => e4
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/j2"を"e4"と呼ぶことにする

    # prev!/jn0005/jn4 => e5
    かつ 実行ジョブ"jn0005"のエッジ"prev!/jn0005/jn4"を"e5"と呼ぶことにする
    # /jn0005/jn4 => jn4
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/jn4"を"jn4"と呼ぶことにする
    # next!/jn0005/jn4 => e6
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/jn4"を"e6"と呼ぶことにする

    # next!start@/jn0005/jn4 => e7
    かつ 実行ジョブ"jn0005"のエッジ"next!start@/jn0005/jn4"を"e7"と呼ぶことにする
     # /jn0005/jn4/j41 => j41
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/jn41"を"jn41"と呼ぶことにする
    # next!/jn0005/jn4/j41 => e8
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/jn4/j41"を"e8"と呼ぶことにする

    # prev!/jn0005/jn4/j42 => e9
    かつ 実行ジョブ"jn0005"のエッジ"prev!/jn0005/jn4/j42"を"e9"と呼ぶことにする
    # /jn0005/jn4/j42 => j42
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/jn4/j42"を"j42"と呼ぶことにする
    # next!/jn0005/jn4/j42 => e10
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/jn4/j42"を"e10"と呼ぶことにする

    # prev!/jn0005/jn4/j43 => e11
    かつ 実行ジョブ"jn0005"のエッジ"prev!/jn0005/jn4/j43"を"e11"と呼ぶことにする
    # /jn0005/jn4/j43 => j43
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/jn4/j43"を"j43"と呼ぶことにする
    # next!/jn0005/jn4/j43 => e12
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/jn4/j43"を"e12"と呼ぶことにする

    # prev!/jn0005/jn4/j44 => e13
    かつ 実行ジョブ"jn0005"のエッジ"prev!/jn0005/jn4/j44"を"e13"と呼ぶことにする
    # /jn0005/jn4/j44 => j44
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/jn4/j44"を"j44"と呼ぶことにする
    # next!/jn0005/jn4/j44 => e14
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/jn4/j44"を"e14"と呼ぶことにする

    # /jn0005/jn4/finally => jn4/finally
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/jn4/finally"を"jn4/finally"と呼ぶことにする
    # "next!start@/jn0005/jn4/finally" => e15
    かつ 実行ジョブ"jn0005"のエッジ"next!start@/jn0005/jn4/finally"を"e15"と呼ぶことにする
    # /jn0005/jn4/finally/jn4_f => jn4_f
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/jn4/finally/jn4_f"を"jn4_f"と呼ぶことにする
    # next!/jn0005/jn4/finally/jn4_f => e16
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/jn4/finally/jn4_f"を"e16"と呼ぶことにする

    # prev!/jn0005/j4 => e17
    かつ 実行ジョブ"jn0005"のエッジ"prev!/jn0005/j4"を"e17"と呼ぶことにする
    # /jn0005/j4 => j4
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/j4"を"j4"と呼ぶことにする
    # next!/jn0005/j4 => e18
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/j4"を"e18"と呼ぶことにする

    # /jn0005/finally => finally
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/finally"を"finally"と呼ぶことにする
    # next!start@/jn0005/finally => e19
    かつ 実行ジョブ"jn0005"のエッジ"next!start@/jn0005/finally"を"e19"と呼ぶことにする
    # /jn0005/finally/jn0005_fjn => jn0005_fjn
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/finally/jn0005_fjn"を"jn0005_fjn"と呼ぶことにする
    # next!/jn0005/finally/jn0005_fjn => e20
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/finally/jn0005_fjn"を"e20"と呼ぶことにする

    # next!start@/jn0005/finally/jn0005_fjn => e21
    かつ 実行ジョブ"jn0005"のエッジ"next!start@/jn0005/finally/jn0005_fjn"を"e21"と呼ぶことにする
    # /jn0005/finally/jn0005_fjn/jn0005_f1 => jn0005_f1
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1"を"jn0005_f1"と呼ぶことにする
    # next!/jn0005/finally/jn0005_fjn/jn0005_f1 => e22
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/finally/jn0005_fjn/jn0005_f1"を"e22"と呼ぶことにする
    # /jn0005/finally/jn0005_fjn/jn0005_f2 => jn0005_f2
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2"を"jn0005_f2"と呼ぶことにする
    # next!/jn0005/finally/jn0005_fjn/jn0005_f2 => e23
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/finally/jn0005_fjn/jn0005_f2"を"e23"と呼ぶことにする


    # /jn0005/finally/jn0005_fjn/finally => jn0005_fjn/finally
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/finally/jn0005_fjn/finally"を"jn0005_fjn/finally"と呼ぶことにする
    # next!start@/jn0005/finally/jn0005_fjn => e24
    かつ 実行ジョブ"jn0005"のエッジ"next!start@/jn0005/finally/jn0005_fjn"を"e24"と呼ぶことにする
    # /jn0005/finally/jn0005_fjn/finally/jn0005_fif => jn0005_fif
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif"を"jn0005_fif"と呼ぶことにする
    # next!/jn0005/finally/jn0005_fjn/finally/jn0005_fif => e25
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/finally/jn0005_fjn/finally/jn0005_fif"を"e25"と呼ぶことにする

    # /jn0005/finally/jn0005_f => jn0005_f
    もし 実行ジョブ"jn0005"のジョブ"/jn0005/finally/jn0005_f"を"jn0005_f"と呼ぶことにする
    # next!/jn0005/finally/jn0005_f => e26
    かつ 実行ジョブ"jn0005"のエッジ"next!/jn0005/finally/jn0005_f"を"e26"と呼ぶことにする

    # receive event "start.execution.job.tengine"
    ならば "Tengineコアプロセス"のアプリケーションログに"#{execution} initialized -> ready"とジョブのフェーズが変更した情報が出力されていること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{execution} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{execution} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} initialized -> ready"とジョブのフェーズが変更した情報が出力されており、"#{execution} ready -> starting"の後であること

    # receive event "start.jobnet.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{execution} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} ready -> starting"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e1} active -> transmitting"とジョブのフェーズが変更した情報が出力されており、"#{execution} starting -> running"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j1} initialized -> ready"とジョブのフェーズが変更した情報が出力されており、"#{e1} active -> transmitting"の後であること

    # receive event "start.job.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e1} transmitting -> transmitted"とジョブのフェーズが変更した情報が出力されており、"#{j1} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j1} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{e1} transmitting -> transmitted"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{j1} ready -> starting"の後であること
    # SSH接続してジョブを実行しようとする

    # PIDが帰ってくる
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j1} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} starting -> running"の後であること

    # receive event "finished.process.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j1} running -> success"とジョブのフェーズが変更した情報が出力されており、"#{j1} starting -> running"の後であること

    # receive event "success.job.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e2} active -> transmitting"とジョブのフェーズが変更した情報が出力されており、"#{j1} running -> success"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e5} active -> transmitting"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> transmitting"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e2} transmitting -> transmitted"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> transmitting"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{jn4} initialized -> ready"とジョブのフェーズが変更した情報が出力されており、"#{e5} active -> transmitting"の後であること

    # receive event "start.jobnet.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{jn4} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{jn4} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e7} active -> transmitting"とジョブのフェーズが変更した情報が出力されており、"#{jn4} starting -> running"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j41} initialized -> ready"とジョブのフェーズが変更した情報が出力されており、"#{e7} active -> transmitting"の後であること

    # receive event "start.job.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j41} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{j41} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{jn4} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{j41} ready -> starting"の後であること

    # receive event "stop.execution.job.tengine"
    # receive event "stop.jobnet.job.tengine"
    # receive event "stop.job.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} running -> dying"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} starting -> running"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e6} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e6} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e8} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e8} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e8} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e9} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e9} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e9} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e10} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e10} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e10} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e11} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e11} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e11} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e12} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e12} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e12} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e13} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e13} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e13} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e14} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e14} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e14} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e15} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e15} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e15} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e16} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e16} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e16} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e17} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e17} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e17} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e18} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e18} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e18} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e19} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e19} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e19} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e20} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e20} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e20} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e21} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e21} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e21} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e22} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e22} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e22} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e23} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e23} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e23} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e24} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e24} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e24} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e25} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e25} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e25} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e26} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e26} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e26} active -> closing"の後であること

    かつ "Tengineコアプロセス"のアプリケーションログに"#{e27} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e27} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e27} active -> closing"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e28} active -> closing"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> dying"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e28} closing -> closed"とジョブのフェーズが変更した情報が出力されており、"#{e28} active -> closing"の後であること

    # receive event "finished.process.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{j41} dying -> error"とジョブのフェーズが変更した情報が出力されており、"#{j41} running -> dying"の後であること

    # receive event "error.jobnet.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} dying -> error"とジョブのフェーズが変更した情報が出力されており、"#{j41} dying -> error"の後であること

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス|操作       |
    |  |jn0005        |jn0005|        |        |強制停止済|監視 再実行|
