#language:ja
機能: アプリケーション運用者がジョブを強制停止する
  

  ジョブがおかしくなった場合や、誤ったジョブを実行してしまった場合、
  アプリケーション運用者
  はジョブを強制停止したい

  背景:
    前提 日本語でアクセスする
    かつ tenginedハートビートの発火間隔が3と設定されている
    かつ "Tengineコアプロセス"が停止している
    かつ "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している
    かつ Tengine周辺のサーバの時刻が同期されている

  シナリオ: [正常系]fork前、ルートジョブネットの最初
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j1_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |実行中|j2, j3|ステータス変更 強制停止 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし "j1"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止中|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


  シナリオ: [正常系]実行中のジョブ一つで停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j1_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |実行中|j2, j3|ステータス変更 強制停止 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|

    もし "jn0004"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止中|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


  シナリオ: [正常系]実行中のジョブが２つで片方を強制停止_片方強制停止時にもう片方が動いている_もう片方が「正常終了」する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j2_SLEEP=60 && eport j3_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし "j2"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|

  シナリオ: [正常系]実行中のジョブが２つで片方を強制停止_片方強制停止時にもう片方が動いている_もう片方が「エラー終了」する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_SLEEP=60 && export J3_SLEEP=60 && J3_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし "j2"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |エラー終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |エラー終了|再実行 監視|


  シナリオ: [正常系]実行中のジョブが２つで片方を強制停止_片方強制停止時にもう片方が「正常終了」している
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし "j2"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|

  シナリオ: [正常系]実行中のジョブが２つで片方を強制停止_片方強制停止時にもう片方が「エラー終了」している
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_SLEEP=60 && export J3_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |エラー終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし "j2"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |エラー終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |エラー終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |エラー終了|再実行 監視|


  シナリオ: [正常系]実行中のジョブが２つで２つとも強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_SLEEP=60 && export J3_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |実行中|強制停止 監視|

    もし "jn0004"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


  シナリオ: [正常系]retry1のj4を実行中にj4を強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "j4"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | 正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


  シナリオ: [正常系]retry1のj4を実行中にルートジョブネットを強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J4_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |実行中|強制停止 監視|

    もし "jn0004"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | 正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


  シナリオ: [正常系]retry1のjn0004_fを実行中にjn0004_fを強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export JN0004_F_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |実行中| |ステータス変更|

    もし "jn0004_f"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | ||正常終了|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | 正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


  シナリオ: [正常系]retry1のjn0004_fを実行中にfinallyを強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export JN0004_F_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |実行中| |ステータス変更|

    もし "finally"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | ||正常終了|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | 正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|

  シナリオ: [正常系]retry1のjn0004_fを実行中にjn0004_fを強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export JN0004_F_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |実行中| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |実行中|強制停止 監視|

    もし "jn0004"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | ||正常終了|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | 正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


#--retry2--

  シナリオ: [正常系]fork前、ルートジョブネットの最初
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j2_SLEEP=60 && export j41_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |実行中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "j41"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止済|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止済|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|

  シナリオ: [正常系]ジョブネットの停止_単一指定_ジョブネット指定でジョブ稼働_稼働中のジョブが一つ_片方強制停止時にもう片方が動いている_もう片方が「正常終了」する_ジョブネット
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j2_SLEEP=60 && export j41_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |実行中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "jn4"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止済|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止済|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|


  シナリオ: [正常系]ジョブネットの停止_単一指定_ジョブネット指定でジョブ稼働_稼働中のジョブが一つ_片方強制停止時にもう片方が動いている_もう片方が「正常終了」する_ジョブ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j2_SLEEP=60 && export j41_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |実行中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "j2"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |実行中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |実行中|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|

  シナリオ: [正常系]ジョブネットの停止_単一指定_ジョブ指定でジョブネット稼働_稼働中のジョブが一つ_3経路動いているときに1経路目を強制停止、2経路目を「異常終了」,３経路目を「正常終了」
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j2_SLEEP=60 && export j42_SLEEP=60 && export j43_SLEEP=60 && export J42_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "j2"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中[エラーあり]|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |エラー終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |エラー終了|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |エラー終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |エラー終了|再実行 監視|

シナリオ: [正常系]実行中[異常]が実行中[強制停止したジョブあり]で上書きされないか確認する
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "事前実行コマンド"に"export j42_SLEEP=60 && export j43_SLEEP=60 && export J2_FAIL=true"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |エラー終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |実行中[エラーあり]|強制停止 監視|

    もし "jn0005"の"監視"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし "j43"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |エラー終了|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |強制停止中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |エラー終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中[強制停止したジョブあり]|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |強制停止済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |実行中[エラーあり]|強制停止 監視|

    もし "jn0005"の"監視"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |エラー終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |強制停止済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |エラー終了|再実行 監視|


  シナリオ: [正常系]ジョブネットの停止_単一指定_ジョブネット指定_稼働中のジョブが2つ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j2_SLEEP=60 && export j42_SLEEP=60 && export j43_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "jn4"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |強制停止中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |強制停止中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |強制停止済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |強制停止済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|


  シナリオ: [正常系]ジョブネットの停止_ルートジョブネット指定_稼働中のジョブが一つ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j2_SLEEP=60 && export j41_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |実行中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|

    もし "jn0005"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止済|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|


  シナリオ: [正常系]ジョブネットの停止_ルートジョブネット指定_ジョブネット指定_稼働中のジョブが2つ
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j42_SLEEP=60 && export j43_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |実行中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|

    もし "jn0005"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |強制停止中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |強制停止中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |強制停止済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |強制停止済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|


  シナリオ: [正常系]ルートジョブネット内のジョブネットのfinally実行中に強制停止_ジョブネット指定
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j4N4_F_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "jn4_f"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|

  シナリオ: [正常系]ルートジョブネット内のジョブネットのfinally実行中に強制停止_finally指定
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j4N4_F_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "jn4"の"finally"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|

  シナリオ: [正常系]ルートジョブネット内のジョブネットのfinally実行中に強制停止_ルートジョブネット
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export j4N4_F_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |実行中|再実行 監視|

    もし "jn0005"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |強制停止中|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|


  シナリオ: [正常系]finally内finally実行中に強制停止_ジョブ指定
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export jN0005_FIF_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "jn0005_fifの"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |強制停止中|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |強制停止済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|

  
  シナリオ: [正常系]finally内finally実行中に強制停止_finally指定
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export jN0005_FIF_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "jn0005_fjn"の"finally"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |強制停止中|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |強制停止済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|


  シナリオ: [正常系]finally内finally実行中に強制停止_ジョブネット指定
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export jN0005_FIF_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "jn0005_fjnの"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |強制停止中|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |強制停止済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|

  




  シナリオ: [正常系]finally内finally実行中に強制停止_ルートジョブネット
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export jN0005_FIF_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |実行中| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |実行中|強制停止 監視|

    もし "jn0005"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |強制停止中| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |正常終了|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|


#--retry3--


  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをジョブを指定して強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0006|jn0006|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |実行中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |実行中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |実行中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし "j111"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止済|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止済|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |正常終了|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |正常終了|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |正常終了||ステータス変更|  

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |強制停止済|再実行 監視|

  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブを1つ上のジョブネットを指定して強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0006|jn0006|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |実行中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |実行中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |実行中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし "j11"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止済|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止済|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |正常終了||ステータス変更|  

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |強制停止済|再実行 監視|

  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブを２つ上のジョブネットを指定して強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0006|jn0006|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |実行中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |実行中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |実行中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし "j1"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止済|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止済|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |正常終了||ステータス変更|  

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |強制停止済|再実行 監視|


  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをルートジョブネットを指定して強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0006|jn0006|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J111_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |実行中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |実行中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |実行中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |実行中|強制停止 監視|

    もし "jn0006"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止済|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止済|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |強制停止済|再実行 監視|


#--start~running--
#ここから下のDSLを実行する場合は、features/script/tengine_job_agebt_runをジョブ実行サーバのジョブ実行ユーザの優先度が最も高いパスに配置します
#ジョブ実行サーバのジョブ実行ユーザの~/bash_profileに~/binあたりをパスに追加して、ファイルを配置するのが無難です
#retry1

  シナリオ: [正常系]ジョブの状態が「開始中」で強制停止を行う
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |初期化済|j2, j3|ステータス変更 強制停止 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし "j1"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |初期化済|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "j1"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


  シナリオ: [正常系]状態が「開始中」でルートジョブネットを指定してジョブが実行されている
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|j2, j3|ステータス変更 強制停止 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |開始中|強制停止 監視|

    もし "jn0004"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|

  シナリオ: [正常系]ジョブの状態が「開始中」で強制停止を行う際に、別経路でジョブが実行されている
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "j2"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|

  シナリオ: [正常系]ジョブの状態が「開始中」で強制停止を行う際に、別経路でジョブが実行されている_ルートジョブネット
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |開始中|強制停止 監視|

    もし "jn0004"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


  シナリオ: [正常系]ジョブの状態が「開始中」で強制停止を行う_代替ジョブネット
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 強制停止 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |開始中| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |開始中| |ステータス変更|


    もし "jn0004_f"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |開始中| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |開始中| |ステータス変更|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |開始中| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |開始中| |ステータス変更 再実行|

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|


  シナリオ: [正常系]状態が「開始中」でルートジョブネットを指定してジョブが実行されている
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0004_retry_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0004|jn0004|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 強制停止 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |開始中| |ステータス変更|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |開始中|強制停止 監視|

    もし "jn0004"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |開始中| |ステータス変更|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |開始中| |ステータス変更|

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |開始中| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |開始中| |ステータス変更 再実行|

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|
    |  |jn0004_f|jn_0004_f|            |test_server1|test_credential1| | |強制停止済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0004|jn0004| | |強制停止済|再実行 監視|

#--retry2--


  シナリオ: [正常系]ジョブネットが「開始中に」ジョブネットを指定して強制停止を行う
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0005_retry_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0005|jn0005|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0005"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |開始中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "jn4"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |開始中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |開始中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |実行中|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止済|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |初期化済|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |初期化済|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし 30秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server1|test_credential1| | |正常終了|j4|ステータス変更 再実行|
    |  |jn4     |jn4 |            |test_server1|test_credential1| | |強制停止済|j4|ステータス変更 再実行|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止済|j42,j43|ステータス変更 再実行|
    |  |  j42   |j42 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j43   |j43 |            |test_server1|test_credential1| | |初期化済|j44|ステータス変更 再実行|
    |  |  j44   |j44 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn0005_fjn|jn_0005_fjn|            |test_server1|test_credential1|| |正常終了|jn0005_f|ステータス変更 再実行|
    |  |    jn0005_f1|jn_0005_f1|            |test_server1|test_credential1| | |正常終了|jn0005_f2|ステータス変更 再実行|
    |  |    jn0005_f2|jn_0005_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn0005_fif|jn_0005_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn0005_f|jn_0005_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0005|jn0005| | |強制停止済|再実行 監視|

#--retry3--


  シナリオ: [正常系]ジョブネットが開始中にジョブネットの中のジョブネット内にあるジョブをジョブを指定して強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0006|jn0006|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし "j111"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 強制停止|
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更| 

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|jn2|ステータス変更 強制停止|
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止済|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止済j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |正常終了|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |正常終了|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |正常終了||ステータス変更|  

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |強制停止済|再実行 監視|

  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブを1つ上のジョブネットを指定して強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0006|jn0006|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし "jn11"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 強制停止|
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更| 

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|jn2|ステータス変更 強制停止|
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止済|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止済j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |正常終了||ステータス変更|  

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |強制停止済|再実行 監視|


  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブを２つ上のジョブネットを指定して強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0006|jn0006|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし "jn1"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 強制停止|
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更| 

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|jn2|ステータス変更 強制停止|
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止済|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止済j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |正常終了||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |正常終了||ステータス変更|  

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |強制停止済|再実行 監視|



  シナリオ: [正常系]ジョブネットの中のジョブネット内にあるジョブをルートジョブネットを指定して強制停止
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T ../tengine_job/examples/0006_retry_three_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn0006|jn0006|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn0006"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export BEFORE_EXECUTE_SLEEP_TIME=40"と入力する
    かつ "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  


    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |強制停止済|再実行 監視|

    もし "jn0006"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 |
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし 10秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |開始中|jn2|ステータス変更 強制停止|
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |開始中|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |開始中|j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更| 

    もし 40秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |jn1          |jn1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|jn2|ステータス変更 強制停止|
    |  |  jn11       |jn11 |            |test_server1|test_credential1| | |強制停止済|j12|ステータス変更 強制停止|
    |  |    j111     |jn111 |            |test_server1|test_credential1| | |強制停止済j112|ステータス変更|
    |  |    j112     |j112|            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済|finally|ステータス変更|
    |  |      jn11_f |jn11_f |            |test_server1|test_credential1| | |初期化済|jn11_f|ステータス変更|
    |  |  j12        |j12 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    jn_1f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn2          |jn2 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  j21        |j21 |            |test_server1|test_credential1| | |初期化済|jn22|ステータス変更|
    |  |  jn22       |jn22 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    j221     |j221 |            |test_server1|test_credential1| | |初期化済|j222|ステータス変更|
    |  |    j222     |j222 |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |    finally  |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |      jn22_f |jn22_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|
    |  |  finally    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |    jn_2f    |finally |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally      |finally |            |test_server1|test_credential1| | |初期化済||ステータス変更|  
    |  |  jn_f         |jn_f |            |test_server1|test_credential1| | |初期化済||ステータス変更|  

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn0006|jn0006| | |強制停止済|再実行 監視|

