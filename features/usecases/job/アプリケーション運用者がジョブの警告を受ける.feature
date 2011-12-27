#language:ja
機能: アプリケーション運用者がジョブの警告を受ける
  
  アプリケーション運用者は
  予想以上にジョブの実行に時間を要している場合
  警告してほしい

  #
  # 基本的な流れ
  # 1. ジョブを実行する際に 適当なジョブに対してSLEEP_TIME=120(秒) を指定、警告設定に1(分)を指定してジョブを開始
  # 2. 60秒後、"イベント一覧"画面にて"alert.execution.job.tengine"のイベントの存在を確認
  # 3. 60秒後、"実行中のジョブ一覧"画面にて実行したジョブネットが終了していることを確認
  #

  背景:
    前提 日本語でアクセスする
    かつ tenginedハートビートの発火間隔が3と設定されている
    かつ "Tengineコアプロセス"が停止している
    かつ "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している
    かつ Tengine周辺のサーバの時刻が同期されている
    かつ "Tengineスケジュールキーパープロセス"が起動している

  @5501
  シナリオ: [正常系]fork前、ルートジョブネットの最初で警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon "で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと
    
    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0004      |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "警告設定"に1と入力する
    かつ "事前実行コマンド"に"export J1_SLEEP=120"と入力する

    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示している
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |実行中   |j2, j3   |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |実行中   |j2, j3   |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること
 
    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0004      |jn0004|       |       |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作      |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示 再実行|
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示 再実行|
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示 再実行|
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|

  @5502
  シナリオ: [正常系]並列に実行される２つのジョブが両方実行中の状態で警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと
    
    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0004      |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "警告設定"に1と入力する
    かつ "事前実行コマンド"に"export J2_SLEEP=120 && export J3_SLEEP=120"と入力する

    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名  |認証情報名       |開始日時             |終了日時|ステータス|次のジョブ|操作      |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |実行中   |j2, j3   |表示 再実行|
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示 再実行|
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示 再実行|
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済 |         |表示 再実行|
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済 |         |表示 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済 |         |表示 再実行|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名  |認証情報名       |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了 |j2, j3   |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |実行中   |j4       |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |実行中   |j4       |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名  |認証情報名       |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了 |j2, j3   |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |実行中   |j4       |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |実行中   |j4       |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること

    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0004      |jn0004|       |       |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作      |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示 再実行|
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示 再実行|
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示 再実行|
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|

  @5503
  シナリオ: [正常系]並列に実行される２つのジョブの片方が正常終了している状態で警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0004      |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "警告設定"に1と入力する
    かつ "事前実行コマンド"に"export J2_SLEEP=120"と入力する

    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |実行中   |j2, j3   |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |実行中    |j4      |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |実行中    |j4      |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること

    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0004      |jn0004|       |       |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作      |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示 再実行|
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示 再実行|
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示 再実行|
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|

  @5504
  シナリオ: [正常系]並列に実行される２つのジョブの片方がエラー終了している状態で警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと
    
    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0004      |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "警告設定"に1と入力する
    かつ "事前実行コマンド"に"export J2_SLEEP=120 && export J3_FAIL='true'"と入力する

    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |実行中   |j2, j3   |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |実行中    |j4      |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |エラー終了|j4      |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する

    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |実行中    |j4      |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |エラー終了|j4      |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること

    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0004      |jn0004|       |       |エラー終了|監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示 再実行   |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示 再実行   |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |エラー終了|j4      |表示 再実行   |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済  |        |表示 再実行   |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行   |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行   |

  @5505
  シナリオ: [正常系]finally実行中に警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0004      |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "警告設定"に1と入力する
    かつ "事前実行コマンド"に"export JN0004_F_SLEEP=120"と入力する

    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |実行中   |j2, j3   |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |初期化済 |j4       |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済 |         |表示         |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3|表示 強制停止   |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |正常終了  |j4    |表示           |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |正常終了  |j4    |表示           |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |正常終了  |      |表示           |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |実行中    |      |表示           |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |実行中    |      |表示           |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3|表示 強制停止   |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |正常終了  |j4    |表示           |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |正常終了  |j4    |表示           |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |正常終了  |      |表示           |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |実行中    |      |表示           |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |実行中    |      |表示           |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること

    # ジョブの終了まで待つ
    もし 70秒間待機する

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0004      |jn0004|       |       |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作      |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示 再実行|
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示 再実行|
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示 再実行|
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |正常終了  |        |表示 再実行|

#--retry2--
  @5506
  シナリオ: [正常系]2階層のジョブネット内のジョブで警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0005      |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J41_SLEEP=120"と入力する
    かつ "警告設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中    |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |初期化済  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |実行中    |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること

    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0005      |jn0005|       |       |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |

  @5507
  シナリオ: [正常系]2階層のジョブネット内で並列に実行される２つのジョブが両方実行中の状態で警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0005      |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J42_SLEEP=120 && export J43_SLEEP=120"と入力する
    かつ "警告設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中    |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |初期化済  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |実行中    |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |実行中    |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること

    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0005      |jn0005|       |       |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |

  @5508
  シナリオ: [正常系]2階層のジョブネット内で並列に実行される２つのジョブの片方が正常終了している状態で警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0005      |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J42_SLEEP=120"と入力する
    かつ "警告設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中    |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |初期化済  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中    |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |実行中　  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること

    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0005      |jn0005|       |       |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |

  @5509
  シナリオ: [正常系]2階層のジョブネット内で並列に実行される２つのジョブの片方がエラー終了している状態で警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0005      |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J42_SLEEP=120 && export J43_FAIL='true'"と入力する
    かつ "警告設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中    |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |初期化済  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する

    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |実行中    |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |エラー終了|j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること
 
    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0005      |jn0005|       |       |エラー終了|監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |エラー終了|j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |

  @5510
  シナリオ: [正常系]2階層のジョブネット内のfinallyが実行中に警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0005      |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J44_FAIL='true' && export JN4_F_SLEEP=120"と入力する
    かつ "警告設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中    |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |初期化済  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |エラー終了|         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |実行中    |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること

    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明|開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    かつ 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |エラー終了|j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |エラー終了|         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    
  @5511
  シナリオ: [正常系]2階層のジョブネット内のfinallyのfinallyが実行中に警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0005      |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J44_FAIL='true' && export JN0005_F2_FAIL='true' &&  export JN0005_FIF_SLEEP=120"と入力する
    かつ "警告設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作          |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中    |j2, jn4 |表示          |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |初期化済  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する

    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示 |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止|
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |エラー終了|j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |エラー終了|         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |エラー終了|         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |エラー終了|jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |エラー終了|         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |実行中    |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |実行中    |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること
 
    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0005      |jn0005|       |       |エラー終了|監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示 |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止|
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |エラー終了|j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |エラー終了|         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |エラー終了|         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |エラー終了|jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |エラー終了|         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

  @5512
  シナリオ: [正常系]3階層のジョブネット内にあるジョブを実行中に警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0006_retry_three_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0006|jn0006|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること
    かつ "警告設定"に"1"と入力する
    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_SLEEP=120"と入力する

    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名      |説明     |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1          |jn1     |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中   |jn2      |表示         |
    |  |  jn11       |jn11    |            |test_server1|test_credential1|                    |       |準備中   |j12      |表示 強制停止 |
    |  |    j111     |jn111   |            |test_server1|test_credential1|                    |       |準備中   |j112     |表示         |
    |  |    j112     |j112    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally  |finally |            |test_server1|test_credential1|                    |       |初期化済  |finally  |表示         |
    |  |      jn11_f |jn11_f  |            |test_server1|test_credential1|                    |       |初期化済  |jn11_f   |表示         |
    |  |  j12        |j12     |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally    |finally |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    jn_1f    |finally |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |jn2          |jn2     |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  j21        |j21     |            |test_server1|test_credential1|                    |       |初期化済  |jn22     |表示         |
    |  |  jn22       |jn22    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    j221     |j221    |            |test_server1|test_credential1|                    |       |初期化済  |j222     |表示         |
    |  |    j222     |j222    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally  |finally |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn22_f |jn22_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally    |finally |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    jn_2f    |finally |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |finally      |finally |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |  
    |  |  jn_f       |jn_f    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |  

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名      |説明     |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1          |jn1     |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |jn2     |表示         |
    |  |  jn11       |jn11    |            |test_server1|test_credential1|                    |       |正常終了  |j12     |表示 強制停止 |
    |  |    j111     |jn111   |            |test_server1|test_credential1|                    |       |実行中  　|j112    |表示         |
    |  |    j112     |j112    |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |    finally  |finally |            |test_server1|test_credential1|                    |       |初期化済  |finally |表示         |
    |  |      jn11_f |jn11_f  |            |test_server1|test_credential1|                    |       |初期化済  |jn11_f  |表示         |
    |  |  j12        |j12     |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |  finally    |finally |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |    jn_1f    |finally |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |jn2          |jn2     |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |  j21        |j21     |            |test_server1|test_credential1|                    |       |初期化済  |jn22    |表示         |
    |  |  jn22       |jn22    |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |    j221     |j221    |            |test_server1|test_credential1|                    |       |初期化済  |j222    |表示         |
    |  |    j222     |j222    |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |    finally  |finally |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |      jn22_f |jn22_f  |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |  finally    |finally |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |    jn_2f    |finally |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |
    |  |finally      |finally |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |  
    |  |  jn_f       |jn_f    |            |test_server1|test_credential1|                    |       |初期化済  |        |表示         |  

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること
 
    # ジョブの終了まで待つ
    もし 70秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0006      |jn0006|       |       |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名      |説明     |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |jn1          |jn1     |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |jn2     |表示         |
    |  |  jn11       |jn11    |            |test_server1|test_credential1|                    |       |正常終了  |j12     |表示 強制停止 |
    |  |    j111     |jn111   |            |test_server1|test_credential1|                    |       |正常終了  |j112    |表示         |
    |  |    j112     |j112    |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |    finally  |finally |            |test_server1|test_credential1|                    |       |正常終了  |finally |表示         |
    |  |      jn11_f |jn11_f  |            |test_server1|test_credential1|                    |       |正常終了  |jn11_f  |表示         |
    |  |  j12        |j12     |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |  finally    |finally |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |    jn_1f    |finally |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |jn2          |jn2     |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |  j21        |j21     |            |test_server1|test_credential1|                    |       |正常終了  |jn22    |表示         |
    |  |  jn22       |jn22    |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |    j221     |j221    |            |test_server1|test_credential1|                    |       |正常終了  |j222    |表示         |
    |  |    j222     |j222    |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |    finally  |finally |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |      jn22_f |jn22_f  |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |  finally    |finally |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |    jn_2f    |finally |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |finally      |finally |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |  
    |  |  jn_f       |jn_f    |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |  


#== startingからdying ==
#ここから下のDSLを実行する場合は、features/script/tengine_job_agebt_runをジョブ実行サーバのジョブ実行ユーザの優先度が最も高いパスに配置します
#ジョブ実行サーバのジョブ実行ユーザの~/bash_profileに~/binあたりをパスに追加して、ファイルを配置するのが無難です
#retry1
  @5513
  シナリオ: [正常系]ジョブの状態が「開始中」で警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0004_retry_one_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0004      |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=80 && export J1_SLEEP=60"と入力する
    かつ "警告設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス |次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |開始中    |j2, j3   |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する

    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス |次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |開始中    |j2, j3   |表示 強制停止 |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること
 
   # ジョブの終了まで待つ
    もし 80秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0004      |jn0004|       |       |正常終了  |監視 再実行|
 
    もし "監視"リンクをクリックする
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明       |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ|操作         |
    |  |j1     |j1        |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, j3  |表示         |
    |  |j2     |j2        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示         |
    |  |j3     |j3        |            |test_server1|test_credential1|                    |       |正常終了  |j4      |表示         |
    |  |j4     |j4        |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |finally|finally   |            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1|                    |       |正常終了  |        |表示         |
　
#--retry2
  @5514
  シナリオ: [正常系]ルートジョブネット内のジョブネット内のジョブの状態が「開始中」で警告
    前提 "Tengineコアプロセス"がオプション" -T ../tengine_job/examples/0005_retry_two_layer.rb --process-daemon"で起動している
    かつ "アプリケーションログファイル"から"Tengineコアプロセス"の"起動時刻"を確認する

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    かつ 1件も表示されていないこと

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明   |操作    |
    |jn0005      |jn0005|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=80 && export J41_SLEEP=60"と入力する
    かつ "警告設定"に"1"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中    |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |初期化済  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    # 警告イベントが発火されるまで待つ
    もし 70秒間待機する   

    ならば 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |準備中    |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |初期化済  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |初期化済  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |初期化済  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |初期化済  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |初期化済  |         |表示         |

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "種別名"に"alert.execution.job.tengine"と入力する
    かつ "発生時刻(開始)"に"Tengineコアプロセス"の"#{開始時刻}"を入力する
    かつ "検索"ボタンをクリックする
    ならば 1件表示されていること
 
    # ジョブの終了まで待つ
    もし 80秒間待機する   

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明   |開始日時|終了日時|ステータス|操作      |
    |  |jn0005      |jn0005|       |       |正常終了  |監視 再実行|

    もし "監視"リンクをクリックする
    かつ 以下の行が表示されていること
    |ID|ジョブ名         |説明        |実行スクリプト|接続サーバ名 |認証情報名        |開始日時             |終了日時|ステータス|次のジョブ |操作         |
    |  |j1              |j1         |            |test_server1|test_credential1|2011/11/25 14:43:22 |       |正常終了  |j2, jn4  |表示         |
    |  |j2              |j2         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示 強制停止 |
    |  |jn4             |jn4        |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  j41           |j41        |            |test_server1|test_credential1|                    |       |正常終了  |j42,j43  |表示         |
    |  |  j42           |j42        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j43           |j43        |            |test_server1|test_credential1|                    |       |正常終了  |j44      |表示         |
    |  |  j44           |j44        |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  finally       |finally    |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |  jn4_f         |jn4_f      |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |j4              |j4         |            |test_server1|test_credential1|                    |       |正常終了  |j4       |表示         |
    |  |finally         |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_fjn    |jn_0005_fjn|            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f |表示         |
    |  |    jn0005_f1   |jn_0005_f1 |            |test_server1|test_credential1|                    |       |正常終了  |jn0005_f2|表示         |
    |  |    jn0005_f2   |jn_0005_f2 |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |    finally     |finally    |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
    |  |  jn0005_f      |jn_0005_f  |            |test_server1|test_credential1|                    |       |正常終了  |         |表示         |
