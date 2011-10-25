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
      かつ "Tengineコアプロセス"の"pidファイル"が存在しない
      かつ "Tengineコアプロセス"の"statusファイル"が存在しない
      かつ "Tengineコアプロセス"の"activationファイル"が存在しない
      かつ "Tengineコンソールプロセス"が停止している

  @selenium
  @u05-f01-s01
  シナリオ: [正常系]アプリケーション開発者が開発環境で接続テストを行いTengineコア、Tengineコンソールを起動する
      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
      ならば "Tengineコンソールプロセス"のPIDファイル"./tmp/pids/server.pid"からPIDを確認できること
      かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "イベント通知画面"を表示する     
      ならば "イベント通知画面"を表示していること
      かつ 以下の行が表示されること
      | 種別名 |
      | bar   |
      | foo   |

      もし "Tengineコアプロセス"を Ctrl+c で停止する
      ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコンソールプロセス"を Ctrl+c で停止する
      ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


  #####################################
  # Tengineコアの接続テストに失敗
  #####################################
  @selenium
  @u05-f01-s02
  シナリオ: 1.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBプロセスが起動していない
      前提 "DBプロセス"が停止している
      ならば "DBプロセス"が停止していること

      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Mongo::ConnectionFailure"と出力されていること 

      もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
      ならば "DBプロセス"が起動していること

      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s03
  シナリオ: 2.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_キュープロセスが起動していない
      前提 "キュープロセス"が停止している
      ならば "キュープロセス"が停止していること

      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"[AMQP::TCPConnectionFailed]"と出力されていること 

      もし "キュープロセス"の起動を行うために"rabbitmq-server -detached"というコマンドを実行する
      ならば "キュープロセス"が起動していること

      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


  @manual
  @u05-f01-s04
  シナリオ: 3.[異常系]Tengineコアの接続テストに失敗し、Tengineサポート窓口へ問い合わせる_Tengineコアのコードにバグ
      # 接続テストの場合、tenginedコマンドで-Tオプションが使用できないので、イベントハンドラ定義を使用してバグを埋め込むことができない
      # そのため、現時点では自動化はできない

      # アプリケーション開発者が解決できない問題を発生させるために、Tengineコアのクラスにバグを埋め込む。
      # イベントハンドラ定義の中で、クラスを上書きするような定義をすることでこれを実現する。

      前提 Tengineコアのクラスに不具合を埋め込むイベントハンドラ定義ファイル"./usecases/core/dsls/uc95_include_bug_core.rb"が存在すること
      もし "接続テスト"を行うために"tengined -k test -f tengine.yml -T ./usecases/core/dsls/uc95_include_bug_core.rb"というコマンドを実行する
      ならば "接続テスト"の標準出力に"inquire of Tengine User Group or Tengine Support Service."と出力されていること 
#      もし サーバ構成レポート収集ツールでサーバ構成の内容を収集する
#      ならば サーバ構成レポートが作成されていること
      もし "Tengineサポート窓口"へ問い合わせる
      # シナリオ終了


  @manual
  @u05-f01-s05
  シナリオ: 4.[異常系]Tengineコアの接続テストに失敗し、Tengineサポート窓口へ問い合わせる_接続テストのコードにバグ
      # 接続テストの場合、tenginedコマンドで-Tオプションが使用できないので、イベントハンドラ定義を使用してバグを埋め込むことができない
      # そのため、現時点では自動化はできない

      # アプリケーション開発者が解決できない問題を発生させるために、接続テストのクラスにバグを埋め込む。
      # イベントハンドラ定義の中で、クラスを上書きするような定義をすることでこれを実現する。
      # TODO イベントハンドラ定義を作成する必要がある

      前提 Tengineコアのクラスに不具合を埋め込むイベントハンドラ定義ファイル"./features/support/dsls/include_bug_connection_test.rb"が存在すること
      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml -T ./features/support/dsls/include_bug_connection_test.rb"というコマンドを実行する
      ならば "接続テスト"の標準出力に"inquire of Tengine User Group or Tengine Support Service."と出力されていること 
#      もし サーバ構成レポート収集ツールでサーバ構成の内容を収集する
#      ならば サーバ構成レポートが作成されていること
      もし "Tengineサポート窓口"へ問い合わせる
      # シナリオ終了

  @selenium
  @u05-f01-s06
  シナリオ: 5.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_設定ファイルが不正
      前提 yamlファイルとして不正なTengineコアの設定ファイル"./features/config/invalid_tengine.yml"が存在すること

      もし "接続テスト"を行うために"tengined -k test -f ./features/config/invalid_tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Exception occurred when loading configuration file: ./features/config/invalid_tengine.yml."と出力されていること

      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s07
  シナリオ: 6.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_起動オプションに存在しないオプション

      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml -Q "というコマンドを実行する
      ならば "接続テスト"の標準出力に"invalid option: -Q"と出力されていること

      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s08
  シナリオ: 7.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_存在しないTengineコアの設定ファイル指定
      前提 Tengineコアの設定ファイル"./features/config/not_found_tengine.yml"が存在しないこと

      # 存在しないファイルを指定するのでエラーが発生する
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/not_found_tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Exception occurred when loading configuration file: ./features/config/not_found_tengine.yml."と出力されていること

      # 正しいファイル名を指定する
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s09
  シナリオ: 8.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-host
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --db-host=xxx"というコマンドを実行する
      # message => Failed to connect to a master node at xxx:21039 (Mongo::ConnectionFailure)
      ならば "接続テスト"の標準出力に"Mongo::ConnectionFailure"と出力されていること
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --db-host=localhost"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s10
  シナリオ: 9.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-port
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --db-port=9999"というコマンドを実行する
      # message => Expected response 1 but got 825241888 (Mongo::ConnectionFailure)
      ならば "接続テスト"の標準出力に"Mongo::ConnectionFailure"と出力されていること
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --db-port=21039"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s11
  シナリオ: 10.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-username
      前提 DBにユーザ"e2e"が存在し、パスワードは"password"である
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --db-username=xxx --db-password=password"というコマンドを実行する
      # message => Failed to authenticate user 'xxx' on db 'tengine_production' (Mongo::AuthenticationError)
      ならば "接続テスト"の標準出力に"Mongo::AuthenticationError"と出力されていること
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --db-username=e2e --db-password=password"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s12
  シナリオ: 11.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-password
      前提 DBにユーザ"e2e"が存在し、パスワードは"password"である
      
      もし "接続テスト"を行うために"tengined -k test  --config ./features/config/tengine.yml --db-username=e2e  --db-password=xxx"というコマンドを実行する
      # message => Failed to authenticate user 'e2e' on db 'tengine_production' (Mongo::AuthenticationError)
      ならば "接続テスト"の標準出力に"Mongo::AuthenticationError"と出力されていること
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --db-username=e2e --db-password=password"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s13
  シナリオ: 12.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-database
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --db-database=xxx"というコマンドを実行する

      # 新しくDBを作成するので成功する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s14
  シナリオ: 13.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-host
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-host=xxx"というコマンドを実行する
      # message => unable to resolve server address (EventMachine::ConnectionError)
      ならば "接続テスト"の標準出力に"EventMachine::ConnectionError"と出力されていること
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-host=localhost"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s15
  シナリオ: 14.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-port
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-port=9999"というコマンドを実行する
      # message => Connection test failure: [Timeout::Error] execution expired
      ならば "接続テスト"の標準出力に"Timeout::Error"と出力されていること
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-port=5672"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s16
  シナリオ: 15.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-vhost
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-vhost=xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Timeout::Error"と出力されていること
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-vhost=/"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s17
  シナリオ: 16.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-user
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-user=xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Timeout::Error"と出力されていること
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-user=guest"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s18
  シナリオ: 17.[異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-pass
      
      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-pass=xxx"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Timeout::Error"と出力されていること


      もし "接続テスト"を行うために"tengined -k test --config ./features/config/tengine.yml --event-queue-conn-pass=guest"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      # 以下基本コースに戻る


      
  #####################################
  # Tengineコアのプロセス起動に失敗
  #####################################

  @selenium
  @u05-f01-s19
  シナリオ: 1.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBプロセスが起動していない
      前提 "DBプロセス"が停止している
      ならば "DBプロセス"が停止していること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"の標準出力に"Mongo::ConnectionFailure"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
      ならば "DBプロセス"が起動していること
    
      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s20
  シナリオ: 2.[異常系]Tengineコアのプロセス起動に失敗し、Tengineサポート窓口へ問い合わせる_Tengineコアのコードにバグ
      # アプリケーション開発者が解決できない問題を発生させるために、Tengineコアのクラスにバグを埋め込む。
      # イベントハンドラ定義の中で、クラスを上書きするような定義をすることでこれを実現する。

      前提 Tengineコアのクラスに不具合を埋め込むイベントハンドラ定義ファイル"./usecases/core/dsls/uc95_include_bug_core.rb"が存在すること
      もし "Tengineコアプロセス"を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc95_include_bug_core.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力に"inquire of Tengine User Group or Tengine Support Service."と出力されていること 
#      もし サーバ構成レポート収集ツールでサーバ構成の内容を収集する
#      ならば サーバ構成レポートが作成されていること
      もし "Tengineサポート窓口"へ問い合わせる
      # シナリオ終了

  @selenium
  @u05-f01-s21
  シナリオ: 3.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_設定ファイルが不正
      前提 yamlファイルとして不正なTengineコアの設定ファイル"./features/config/invalid_tengine.yml"が存在すること
      
      # 不正なファイルを指定して実行
      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/invalid_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力に"Exception occurred when loading configuration file: ./features/config/invalid_tengine.yml."と出力されていること
      かつ "Tengineコアプロセス"が停止していること

      # 正しいファイルを指定して実行
      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s22
  シナリオ: 4.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_起動オプションに存在しないオプション

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -Q "というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力に"invalid option: -Q"と出力されていること
      かつ "Tengineコアプロセス"が停止していること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s23
  シナリオ: 5.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_存在しないTengineコアの設定ファイル指定

      # 指定ファイルが存在しないので起動しない
      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/not_found_tengine.yml"というコマンドを実行する
      # ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"Exception occurred when loading configuration file: ./features/config/not_found_tengine.yml."と出力されていること
      # かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 正しいファイルを指定して実行
      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s24
  シナリオ: 6.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-host

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --db-host=xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      # message => Failed to connect to a master node at xxx:21039 (Mongo::ConnectionFailure)
      かつ "Tengineコアプロセス"の標準出力に"Mongo::ConnectionFailure"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --db-host=localhost"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s25
  シナリオ: 7.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-port

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --db-port=9999"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      # message => Expected response 1 but got 825241888 (Mongo::ConnectionFailure)
      かつ "Tengineコアプロセス"の標準出力に"Mongo::ConnectionFailure"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --db-port=21039"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s26
  シナリオ: 8.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-username
      前提 DBにユーザ"e2e"が存在し、パスワードは"password"である

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --db-username=xxx --db-password=password"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      # message => Failed to authenticate user 'e2e' on db 'tengine_production' (Mongo::AuthenticationError)
      ならば "Tengineコアプロセス"の標準出力に"Mongo::AuthenticationError"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --db-username=e2e --db-password=password"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s27
  シナリオ: 9.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-password
      前提 DBにユーザ"e2e"が存在し、パスワードは"password"である
      
      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --db-username=e2e --db-password=xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      # message => Failed to authenticate user 'e2e' on db 'tengine_production' (Mongo::AuthenticationError)
      かつ "Tengineコアプロセス"の標準出力に"Mongo::AuthenticationError"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml  --db-username=e2e --db-password=password"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s28
  シナリオ: 10.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBのhostが見つからない:--db-database

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --db-database=xxx"というコマンドを実行する

      # 新しくDBを作成するので成功する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s29
  シナリオ: 11.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-host

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --event-queue-conn-host=xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      # message => unable to resolve server address (EventMachine::ConnectionError)
      ならば "Tengineコアプロセス"の標準出力に"EventMachine::ConnectionError"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

       もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --event-queue-conn-host=localhost"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s30
  シナリオ: 12.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-port

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --event-queue-conn-port=9999"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること

      # message => event #<Tengine::Event:0x007f8461a38a08> has be tried to send 30 times. (Tengine::Event::Sender::RetryError)
      ならば 約"40"秒以内に"Tengineコアプロセス"の標準出力に"Tengine::Event::Sender::RetryError"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --event-queue-conn-port=5672"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  @selenium
  @u05-f01-s31
  シナリオ: 13.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-vhost

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --event-queue-conn-vhost=xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること

      # message => event #<Tengine::Event:0x007f8461a38a08> has be tried to send 30 times. (Tengine::Event::Sender::RetryError)
      ならば 約"40"秒以内に"Tengineコアプロセス"の標準出力に"Tengine::Event::Sender::RetryError"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --event-queue-conn-vhost=/"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
      
      # 以下基本コースに戻る

  @selenium
  @u05-f01-s32
  シナリオ: 14.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-user

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --event-queue-conn-user=xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること

      # message => event #<Tengine::Event:0x007fefe23097b8> has be tried to send 30 times. (Tengine::Event::Sender::RetryError)
      ならば 約"40"秒以内に"Tengineコアプロセス"の標準出力に"Tengine::Event::Sender::RetryError"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
      
      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --event-queue-conn-user=guest"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s33
  シナリオ: 15.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_queueのhostが見つからない:--event-queue-conn-pass

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --event-queue-conn-pass=xxx"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること

      # message => event #<Tengine::Event:0x007fefe23097b8> has be tried to send 30 times. (Tengine::Event::Sender::RetryError)
      ならば 約"40"秒以内に"Tengineコアプロセス"の標準出力に"Tengine::Event::Sender::RetryError"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
      
      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml --event-queue-conn-pass=guest"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
      
      # 以下基本コースに戻る

  @selenium
  @u05-f01-s34
  シナリオ: 16.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_loadで--tengined-load-pathを指定していない

      もし "Tengineコアプロセス"の起動を行うために"tengined -k load"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"--tengined-load-path is required if --action load specified."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k load --tengined-load-path ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s35
  シナリオ: 17.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_startで--tengined-load-pathを指定していない

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"--tengined-load-path is required if --action start specified."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --tengined-load-path ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s36
  シナリオ: 18.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_enableで--tengined-load-pathを指定していない

      もし "Tengineコアプロセス"の起動を行うために"tengined -k enable"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"の標準出力に"--tengined-load-path is required if --action enable specified."と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k enable --tengined-load-path ../tengine_core/examples/uc01_execute_processing_for_event.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s37
  シナリオ: 19.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_ログファイルを指定したが書き込み権限がない
      前提 "./tmp/ap_not_writable.log"ファイルに書き込み権限がない
      かつ "./tmp/ap.log"ファイルに書き込み権限がある

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --application-log-output=./tmp/ap_not_writable.log"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      # message => Permission denied - ./tmp/ap_not_writable.log (Errno::EACCES)
      ならば "Tengineコアプロセス"の標準出力に"Permission denied"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --application-log-output=./tmp/ap.log"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  # 非デーモン起動ではメッセージが標準出力に出力されるため、ローテーションのオプションは無効となるためコメントアウトします。別のfeatureでテストする必要はあります。
#  @selenium
#  @u05-f01-s38
#  シナリオ: 20.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_ログローテーションを指定したが認識できない
#     # スペスを間違えてローテーションを設定
#      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --application-log-rotation=manthly"というコマンドを実行する
#      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
#      ならば "Tengineコアプロセス"の標準出力に"invalid value of application-log-rotation : yearly"と出力されていること
#      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

#      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --application-log-rotation=monthly"というコマンドを実行する
#      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
#      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  # 非デーモン起動ではメッセージが標準出力に出力されるため、ローテーションのオプションは無効となるためコメントアウトします。別のfeatureでテストする必要はあります。
#  @selenium
#  @u05-f01-s39
#  シナリオ: 21.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_ログローテーションサイズを指定したが認識できない
#      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --application-log-rotation=2 --application-log-rotation-size=hoge"というコマンドを実行する
#      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
#      ならば "Tengineコアプロセス"の標準出力に"invalid value of application-log-rotation-size : hoge"と出力されていること
#      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

#      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --application-log-rotation=monthly --application-log-rotation-size=100"というコマンドを実行する
#      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
#     かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る

  @selenium
  @u05-f01-s40
  シナリオ: 22.[異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_ログレベルを指定したが認識できない
      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --application-log-level hoge"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること

      # message => uninitialized constant Logger::HOGE (NameError)
      ならば "Tengineコアプロセス"の標準出力に"NameError"と出力されていること
      かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start --config ./features/config/tengine.yml --application-log-level error"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      # 以下基本コースに戻る


  ######################################
  # Tengineコアの停止に失敗
  #####################################
  @selenium
  @u05-f01-s41
  シナリオ: [異常系]Tengineコアのプロセスの停止に失敗し、強制停止を行う
      前提 処理が終了しないイベントハンドラ定義ファイル"./usecases/core/dsls/uc93_hang_up.rb"が存在すること

      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること

      もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc93_hang_up.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
      ならば "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること


      もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
      ならば "Tengineコンソールプロセス"のPIDファイル"./tmp/pids/server.pid"からPIDを確認できること
      ならば "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "イベント発火画面"を表示する
      ならば "イベント発火画面"を表示していること
      もし "種別名"に"event_hang_up"と入力する
      かつ "登録する"ボタンをクリックする
      ならば "event_hang_upを発火しました"と表示されていること
      
      かつ "Tengineコアプロセス"を Ctrl+c で停止する
      ならば "Tengineコアプロセス"が起動していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
      
      もし "Tengineコアプロセス"を強制停止する
      ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること

      もし "Tengineコンソールプロセス"を Ctrl+c で停止する
      ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
