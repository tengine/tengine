#language:ja
機能: アプリケーション運用者が複数のサーバで動かしているジョブを強制停止する
  

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

  シナリオ: [正常系]複数サーバ動いているジョブを強制停止_ジョブ指定
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T usecases/job/dsl/3001_force_stop_multi_server_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn3001|jn3001|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn3001"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |実行中|j2, j3|ステータス変更 強制停止 |
    |  |j2     |j2 |            |test_server2|test_credential2| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server3|test_credential3| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn3001_f|jn3001_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|


    もし "j1"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止中|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server2|test_credential2| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server3|test_credential3| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn3001_f|jn3001_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |強制停止済|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server2|test_credential2| | |初期化済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server3|test_credential3| | |初期化済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |jn3001_f|jn3001_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn3001|jn3001| | |強制停止済|再実行 監視|


  シナリオ: [正常系]複数サーバ動いているジョブを強制停止_ルートジョブネット指定
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T usecases/job/dsl/3001_force_stop_multi_server_one_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn3001|jn3001|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn3001"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_SLEEP=60 && J3_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする

    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |実行中|j2, j3|ステータス変更 強制停止 |
    |  |j2     |j2 |            |test_server2|test_credential2| | |初期化済|j4|ステータス変更|
    |  |j3     |j3 |            |test_server3|test_credential3| | |初期化済|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn3001_f|jn3001_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server2|test_credential2| | |実行中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server3|test_credential3| | |実行中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn3001_f|jn3001_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn3001"の"強制停止"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更|
    |  |j2     |j2 |            |test_server2|test_credential2| | |強制停止中|j4|ステータス変更|
    |  |j3     |j3 |            |test_server3|test_credential3| | |強制停止中|j4|ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |jn3001_f|jn3001_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, j3|ステータス変更 再実行|
    |  |j2     |j2 |            |test_server2|test_credential2| | |強制停止済|j4|ステータス変更 再実行|
    |  |j3     |j3 |            |test_server3|test_credential3| | |強制停止済|j4|ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |jn3001_f|jn3001_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn3001|jn3001| | |強制停止済|再実行 監視|


#==retry2==

  シナリオ: [正常系]fork前、ルートジョブネットの最初
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T usecases/job/dsl/3002_force_stop_multi_server_two_layer.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn3002|jn3002|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn3002"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J41_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    かつ 20秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server2|test_credential2| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server3|test_credential2| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |実行中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server2|test_credential2| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server3|test_credential3| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server3|test_credential3| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server3|test_credential2| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server2|test_credential2| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn3002_fjn|jn3002_fjn|            |test_server1|test_credential1|| |初期化済|jn3002_f|ステータス変更|
    |  |    jn3002_f1|jn3002_f1|            |test_server1|test_credential1| | |初期化済|jn3002_f2|ステータス変更|
    |  |    jn3002_f2|jn3002_f2|            |test_server2|test_credential2| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn3002_fif|jn3002_fif|            |test_server3|test_credential3| | |初期化済| |ステータス変更|
    |  |  jn3002_f|jn3002_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "j41"の"強制停止"リンクをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server2|test_credential2| | |正常終了|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server3|test_credential2| | |強制停止中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |強制停止中|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server2|test_credential2| | |初期化済|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server3|test_credential3| | |初期化済|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server3|test_credential3| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server3|test_credential2| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server2|test_credential2| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn3002_fjn|jn3002_fjn|            |test_server1|test_credential1|| |初期化済|jn3002_f|ステータス変更|
    |  |    jn3002_f1|jn3002_f1|            |test_server1|test_credential1| | |初期化済|jn3002_f2|ステータス変更|
    |  |    jn3002_f2|jn3002_f2|            |test_server2|test_credential2| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn3002_fif|jn3002_fif|            |test_server3|test_credential3| | |初期化済| |ステータス変更|
    |  |  jn3002_f|jn3002_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

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
    |  |  finally   |finally |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |  jn4_f   |jn4_f |            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更 再実行|
    |  |finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |  jn3002_fjn|jn3002_fjn|            |test_server1|test_credential1|| |正常終了|jn3002_f|ステータス変更 再実行|
    |  |    jn3002_f1|jn3002_f1|            |test_server1|test_credential1| | |正常終了|jn3002_f2|ステータス変更 再実行|
    |  |    jn3002_f2|jn3002_f2|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |      jn3002_fif|jn3002_fif|            |test_server1|test_credential1| | |正常終了| |ステータス変更|
    |  |  jn3002_f|jn3002_f|            |test_server1|test_credential1| | |正常終了| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn3002|jn3002| | |強制停止済|再実行 監視|

  シナリオ: [正常系]fork前、ルートジョブネットの最初
    前提 "Tengineコアプロセス"がオプション" -f ./features/config/tengine.yml -T usecases/job/dsl/3002_force_stop_multi_server_two_layer.rb.rb -D"で起動している

    もし "テンプレートジョブネット一覧画面"を表示する
    ならば "テンプレートジョブネット一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明|操作|
    |jn3002|jn3002|閲覧 実行|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn3002"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J2_SLEEP=60 && export J42_SLEEP=60 && export J43_SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    かつ 20秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server2|test_credential2| | |実行中|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server3|test_credential2| | |実行中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server2|test_credential2| | |実行中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server3|test_credential3| | |実行中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server3|test_credential3| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server3|test_credential2| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server2|test_credential2| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn3002_fjn|jn3002_fjn|            |test_server1|test_credential1|| |初期化済|jn3002_f|ステータス変更|
    |  |    jn3002_f1|jn3002_f1|            |test_server1|test_credential1| | |初期化済|jn3002_f2|ステータス変更|
    |  |    jn3002_f2|jn3002_f2|            |test_server2|test_credential2| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn3002_fif|jn3002_fif|            |test_server3|test_credential3| | |初期化済| |ステータス変更|
    |  |  jn3002_f|jn3002_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし "テンプレートジョブネット一覧画面"を表示する
    かつ "jn3002"の"強制停止"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|開始日時|終了日時|ステータス|次のジョブ|操作|
    |  |j1     |j1 |            |test_server1|test_credential1|2011/11/25 14:43:22 | |正常終了|j2, jn4|ステータス変更 |
    |  |j2     |j2 |            |test_server2|test_credential2| | |強制停止中|j4|ステータス変更 強制停止|
    |  |jn4     |jn4 |            |test_server3|test_credential2| | |強制停止中|j4|ステータス変更|
    |  |  j41   |j41 |            |test_server1|test_credential1| | |正常終了|j42,j43|ステータス変更|
    |  |  j42   |j42 |            |test_server2|test_credential2| | |強制停止中|j44|ステータス変更|
    |  |  j43   |j43 |            |test_server3|test_credential3| | |強制停止中|j44|ステータス変更|
    |  |  j44   |j44 |            |test_server3|test_credential3| | |初期化済| |ステータス変更|
    |  |  finally   |finally |            |test_server3|test_credential2| | |初期化済|j4|ステータス変更|
    |  |  jn4_f   |jn4_f |            |test_server2|test_credential2| | |初期化済| |ステータス変更|
    |  |j4     |j4 |            |test_server1|test_credential1| | |初期化済|j4|ステータス変更|
    |  |finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn3002_fjn|jn3002_fjn|            |test_server1|test_credential1|| |初期化済|jn3002_f|ステータス変更|
    |  |    jn3002_f1|jn3002_f1|            |test_server1|test_credential1| | |初期化済|jn3002_f2|ステータス変更|
    |  |    jn3002_f2|jn3002_f2|            |test_server2|test_credential2| | |初期化済| |ステータス変更|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn3002_fif|jn3002_fif|            |test_server3|test_credential3| | |初期化済| |ステータス変更|
    |  |  jn3002_f|jn3002_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更|

    もし 20秒間待機する
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
    |  |  jn3002_fjn|jn3002_fjn|            |test_server1|test_credential1|| |初期化済|jn3002_f|ステータス変更 再実行|
    |  |    jn3002_f1|jn3002_f1|            |test_server1|test_credential1| | |初期化済|jn3002_f2|ステータス変更 再実行|
    |  |    jn3002_f2|jn3002_f2|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|
    |  |    finally|finally|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |      jn3002_fif|jn3002_fif|            |test_server1|test_credential1| | |初期化済| |ステータス変更|
    |  |  jn3002_f|jn3002_f|            |test_server1|test_credential1| | |初期化済| |ステータス変更 再実行|

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明||開始日時|終了日時|ステータス|操作|
    |  |jn3002|jn3002| | |強制停止済|再実行 監視