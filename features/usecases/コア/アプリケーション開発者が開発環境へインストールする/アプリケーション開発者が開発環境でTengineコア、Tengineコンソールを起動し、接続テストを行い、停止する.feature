#language:ja
機能: アプリケーション開発者が開発環境でTengineコア、Tengineコンソールを起動し、接続テストを行い、停止する
  このfeatureは、ユースケース{アプリケーション開発者が開発環境へインストールする}から
  次の内容を切り出したものになります。
   * Tengineコアの接続テストを行う
   * Tengineコア, Tengineコンソールを起動を行う
   * イベント通知画面で接続テストで発火したイベントを確認する
   * Tengineコア, Tengineコンソールを停止を行う
  このfeatureでは次の処理で発生する異常系を考慮します。
   * 接続テストの実行
     * 接続テスト用のイベントハンドラ定義のload (アプリケーション開発者が作成したイベントハンドラ定義をloadする場合は、別途考慮が必要です。)
     * 接続テスト用のイベント発火 (画面から発火する場合は、別途考慮が必要です。)
     * 接続テスト用のイベント処理
   * Tengineコアの起動
   * Tengineコアの停止
  異常系の洗い出しを行った際に作成したファイルは次になります。
   * https://docs.google.com/a/nautilus-technologies.com/spreadsheet/ccc?key=0AiCFoDki8k_ndDZxbWxMdWlfcnlUVU1DWHN2ZXhjYmc&hl=ja#gid=0

  背景:
      前提 "DBパッケージ"のインストールおよびセットアップが完了している
      かつ "キューパッケージ"のインストールおよびセットアップが完了している
      かつ "Tengineコアパッケージ"のインストールおよびセットアップが完了している
      かつ "Tengineコンソールパッケージ"のインストールおよびセットアップが完了している
      かつ "DBプロセス"が起動している
      かつ "キュープロセス"が起動している
      かつ "Tengineコアプロセス"が停止している
      かつ "Tengineコンソールプロセス"が停止している

  シナリオ: [正常系]アプリケーション開発者が開発環境で接続テストを行いTengineコア、Tengineコンソールを起動する

      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
      ならば "Tengineコンソールプロセス"のPIDファイル"./tmp/pids/server.pid"からPIDを確認できること
      かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "イベント通知画面"を表示する
      ならば "イベント通知画面"を表示していること
      ならば 以下の行が表示されること
      | 種別名             |
      | bar             |
      | foo             |

      もし "Tengineコアプロセス"を Ctrl+c で停止する
      ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコンソールプロセス"を Ctrl+c で停止する
      ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  #####################################
  # Tengineコアの接続テストに失敗
  #####################################

  シナリオ: 1.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBプロセスが起動していない
      前提 "DBプロセス"が停止している

      もし "接続テスト"を行うために"bin/tengined -k test -f ./tmp/end_to_end_test/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to database."と出力されていること 

      もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
      ならば "DBプロセス"が起動していること

      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  シナリオ: 2.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_キュープロセスが起動していない
      前提 "キュープロセス"が停止している

      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to queue server."と出力されていること 

      もし "キュープロセス"の起動を行うために"rabbitmq-server -detached"というコマンドを実行する
      ならば "キュープロセス"が起動していること

      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  シナリオ: 3.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_イベント発火を行ったがイベントの受信ができない
      # subscribeするキューと、publishするexchengeがバインディングされていない状況をでテストを行う。
      # 上の状況を設定ファイルで作り出す。具体的にはpublishするexchangeをテスト用に用意し、そちらにメッセージを送信する。
 
      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/timeout_tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"timeout error."と出力されていること 

      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  シナリオ: 4.[異常系]Tengineコアの接続テストに失敗し、Tengineサポート窓口へ問い合わせる_Tengineコアのコードにバグ
      # アプリケーション開発者が解決できない問題を発生させるために、Tengineコアのクラスにバグを埋め込む。
      # イベントハンドラ定義の中で、クラスを上書きするような定義をすることでこれを実現する。
      # TODO イベントハンドラ定義を作成する必要がある

      前提 Tengineコアのクラスに不具合を埋め込むイベントハンドラ定義ファイル"./features/support/dsls/include_bug_core.rb"が存在すること
      もし "接続テスト"を行うために"bin/tengined -k test -f tengine.yml -T ./features/support/dsls/include_bug_core.rb"というコマンドを実行する
      ならば "接続テスト"の標準出力に"inquire of Tengine User Group or Tengine Support Service."と出力されていること 
#      もし サーバ構成レポート収集ツールでサーバ構成の内容を収集する
#      ならば サーバ構成レポートが作成されていること
      もし "Tengineサポート窓口"へ問い合わせる
      # シナリオ終了


  シナリオ: 5.[異常系]Tengineコアの接続テストに失敗し、Tengineサポート窓口へ問い合わせる_接続テストのコードにバグ
      # アプリケーション開発者が解決できない問題を発生させるために、接続テストのクラスにバグを埋め込む。
      # イベントハンドラ定義の中で、クラスを上書きするような定義をすることでこれを実現する。
      # TODO イベントハンドラ定義を作成する必要がある

      前提 Tengineコアのクラスに不具合を埋め込むイベントハンドラ定義ファイル"./features/support/dsls/include_bug_connection_test.rb"が存在すること
      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/tengine.yml -T ./features/support/dsls/include_bug_connection_test.rb"というコマンドを実行する
      ならば "接続テスト"の標準出力に"inquire of Tengine User Group or Tengine Support Service."と出力されていること 
#      もし サーバ構成レポート収集ツールでサーバ構成の内容を収集する
#      ならば サーバ構成レポートが作成されていること
      もし "Tengineサポート窓口"へ問い合わせる
      # シナリオ終了

  シナリオ: 6.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_設定ファイルが不正
      前提 yamlファイルとして不正なTengineコアの設定ファイルinvalid_tengine.ymlが存在する

      もし "接続テスト"を行うために"bin/tengined -k test -f ./tmp/end_to_end_test/config/invalid_tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Exception occurred when loading configuration file: ./tmp/end_to_end_test/config/invalid_tengine.yml."と出力されていること

      もし Tengineコアの設定ファイル"./tmp/end_to_end_test/config/invalid_tengine.yml"を修正する

      もし "接続テスト"を行うために"bin/tengined -k test -f ./tmp/end_to_end_test/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  シナリオ: 7.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_起動オプションに存在しないオプション

      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/tengine.yml -Q"というコマンドを実行する
      ならば "接続テスト"の標準出力に"tengined: invalid option: -Q"と出力されていること

      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  シナリオ: 8.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_存在しないTengineコアの設定ファイル指定
      前提 Tengineコアの設定ファイル"./tmp/end_to_end_test/config/not_found_tengine.yml"が存在しないこと
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./tmp/end_to_end_test/config/not_found_tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Exception occurred when loading configuration file: ./tmp/end_to_end_test/config/not_found_tengine.yml."と出力されていること

      もし Tengineコアの設定ファイル"./tmp/end_to_end_test/config/not_found_tengine.yml"を作成する
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./tmp/end_to_end_test/config/not_found_tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  シナリオ: 9.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-host
			
      もし "接続テスト"を行うために"bin/tengined -k test --db-host xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to database."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  シナリオ: 10.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-port
			
      もし "接続テスト"を行うために"bin/tengined -k test --db-port 9999"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to database."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

			
  シナリオ: 11.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-username
			
      もし "接続テスト"を行うために"bin/tengined -k test --db-username xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to database."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

			
  シナリオ: 12.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-password
			
      もし "接続テスト"を行うために"bin/tengined -k test --db-password xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to database."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config _end_test/config/not_found_tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  シナリオ: 13.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-database
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml --db-database xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to database."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  シナリオ: 14.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-host
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml --event-queue-conn-host xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to queue server."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  シナリオ: 15.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-port
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml --event-queue-conn-port 9999"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to queue server."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  シナリオ: 16.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-vhost
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml --event-queue-conn-vhost xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to queue server."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  シナリオ: 17.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-user
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml --event-queue-conn-user xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to queue server."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  シナリオ: 18.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-pass
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml --event-queue-conn-pass xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to queue server."と出力されていること
			
      もし "接続テスト"を行うために"bin/tengined -k test --config ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


			
  #####################################
  # Tengineコアのプロセス起動に失敗
  #####################################


  シナリオ: 1.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBプロセスが起動していない
      前提 "DBプロセス"が停止している

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to database."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
      ならば "DBプロセス"が起動していること
		
      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 2.[異常系]Tengineコアのプロセス起動に失敗し、Tengineサポート窓口へ問い合わせる_Tengineコアのコードにバグ
      # アプリケーション開発者が解決できない問題を発生させるために、Tengineコアのクラスにバグを埋め込む。
      # イベントハンドラ定義の中で、クラスを上書きするような定義をすることでこれを実現する。
      # TODO イベントハンドラ定義を作成する必要がある

      前提 Tengineコアのクラスに不具合を埋め込むイベントハンドラ定義ファイル"./features/event_handler_def/include_bug_core.rb"が存在すること
      もし "Tengineコアプロセス"を行うために"bin/tengined -k start -f ./features/support/config/tengine.yml -T ./features/support/dsls/include_bug_core.rb"というコマンドを実行する
      ならば "Tengineコアプロセウ"の標準出力に"inquire of Tengine User Group or Tengine Support Service."と出力されていること 
#      もし サーバ構成レポート収集ツールでサーバ構成の内容を収集する
#      ならば サーバ構成レポートが作成されていること
      もし "Tengineサポート窓口"へ問い合わせる
      # シナリオ終了


  シナリオ: 3.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_設定ファイルが不正
      前提 yamlファイルとして不正なTengineコアの設定ファイルinvalid_tengine.ymlが存在する
			
      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start -f ./tmp/end_to_end_test/config/invalid_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"Exception occurred when loading configuration file: ./tmp/end_to_end_test/config/invalid_tengine.yml."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし Tengineコアの設定ファイル"./tmp/end_to_end_test/config/invalid_tengine.yml"を修正する

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start -f ./tmp/end_to_end_test/config/invalid_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 4.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_起動オプションに存在しないオプション

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start -f ./features/support/config/tengine.yml -Q"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"tengined: invalid option: -Q"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  シナリオ: 5.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_存在しないTengineコアの設定ファイル指定

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --config ./tmp/end_to_end_test/config/not_found_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"Exception occurred when loading configuration file: ./tmp/end_to_end_test/config/not_found_tengine.yml."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし Tengineコアの設定ファイル"./tmp/end_to_end_test/config/not_found_tengine.yml"を作成する

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --config ./tmp/end_to_end_test/config/not_found_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 6.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-host

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --db-host xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to database."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 7.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-port

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --db-port 9999"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to database."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 8.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-username

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --db-username xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to database."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 9.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-password

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --db-password xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to database."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 10.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-database

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --db-database xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to database."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 11.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-host

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --event-queue-conn-host xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to queue server."と出力されていること
			# Warning 扱いのためTengineコアプロセスは起動する
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

			
  シナリオ: 12.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-port

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --event-queue-conn-port 9999"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to queue server."と出力されていること
			# Warning 扱いのためTengineコアプロセスは起動する
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

			
  シナリオ: 13.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-vhost

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --event-queue-conn-vhost xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to queue server."と出力されていること
			# Warning 扱いのためTengineコアプロセスは起動する
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

			
  シナリオ: 14.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-user

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --event-queue-conn-user xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to queue server."と出力されていること
			# Warning 扱いのためTengineコアプロセスは起動する
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

			
  シナリオ: 15.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-pass

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --event-queue-conn-pass xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to queue server."と出力されていること
			# Warning 扱いのためTengineコアプロセスは起動する
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 16.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_loadで--tengined-load-pathを指定していない

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k load"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"--tengined-load-path is required if --action load specified."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k load --tengined-load-path ./features/support/dsls/simple.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 17.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_startで--tengined-load-pathを指定していない

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"--tengined-load-path is required if --action start specified."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --tengined-load-path ./features/support/dsls/simple.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

			
  シナリオ: 18.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_enabelで--tengined-load-pathを指定していない

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k enable"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"--tengined-load-path is required if --action enable specified."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k enable --tengined-load-path ./features/support/dsls/simple.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

			
  シナリオ: 19.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_stopで--tengined-load-pathを指定していない

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k stop"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"--tengined-load-path is required if --action stop specified."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k stop --tengined-load-path ./features/support/dsls/simple.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

			
  シナリオ: 20.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_force-stopで--tengined-load-pathを指定していない

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k force-stop"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"--tengined-load-path is required if --action force-stop specified."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k force-stop --tengined-load-path ./features/support/dsls/simple.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 21.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_ログファイルを指定したが書き込み権限がない
      前提 "/tmp/ap_not_writable.log"ファイルに書き込み権限がない
      かつ "/tmp/ap.log"ファイルに書き込み権限がある

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --application-log-output /tmp/ap_not_writable.log"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"permission denied. can't create o write file path: /tmp/ap.log"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --application-log-output /tmp/ap.log"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 22.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_ログローテーションを指定したが認識できない
      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --application-log-rotation yearly"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"invalid value of application-log-rotation : yearly"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --application-log-rotation monthly"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 23.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_ログローテーションサイズを指定したが認識できない
      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --application-log-rotation-size hoge"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"invalid value of application-log-rotation-size : hoge"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --application-log-rotation-size 10"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  シナリオ: 24.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_ログレベルを指定したが認識できない
      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --application-log-level hoge"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"invalid value of application-log-level : hoge"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"bin/tengined -k start --application-log-level error"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  ######################################
  # Tengineコアの停止に失敗
  #####################################
  シナリオ: [異常系]Tengineコアのプロセスの停止に失敗し、強制停止を行う
      前提 処理が終了しないイベントハンドラ定義ファイル"./features/usecases/コア/dsls/hang_up.rb"が存在すること

      もし "接続テスト"を行うために"bin/tengined -k test -f ./features/support/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      もし "Tengineコアプロセスの起動"を行うために"bin/tengined -k start -f ./features/support/config/tengine.yml -T ./features/usecases/コア/dsls/hung_up.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


      もし "Tengineコンソールプロセスの起動"を行うために"rails s -e production"というコマンドを実行する
      ならば "Tengineコンソールプロセス"のPIDファイル"./tmp/pids/server.pid"からPIDを確認できること
      ならば "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "イベント通知画面"を表示する
      もし "イベント通知画面"を表示する
      ならば "イベント通知画面"を表示していること
      ならば 以下の行が表示されること
      |種別名  |
      |connection_test|

      もし "種別名"に"hung_up"と入力する
      かつ "発生源名"に"tengine_console"と入力する
      かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
      かつ "通知レベル"から"info"を選択する
      かつ "送信者名"に"tengine_console"と入力する
      かつ "発火"ボタンをクリックする
      ならば "hung_upを発火しました"と表示されていること
			
      かつ "Tengineコアプロセス"を Ctrl+c で停止する
      ならば "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
			
      もし "Tengineコアプロセス"を強制停止する
      ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコンソールプロセス"を Ctrl+c で停止する
      ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
