#language:ja
機能: アプリケーション運用者がTengineを本番環境へインストールする
  バッチを実行するために
  アプリケーション運用者
  はTengineジョブをインストールしたい

  背景:
    # 背景のステップはmanualタグを付けれないのでコメントアウトしています
    # インストール確認時に使用する tengine_job_agent.yml.erb の例は ./config/tengine_job_agent.yml.erb.example に置いています
    # 実際にテストする環境にあわせて記述を変更してください

    # 前提 日本語でアクセスする
    # かつ ジョブプロセスウォッチドッグをインストールする対象のサーバが起動している
    # かつ "Tengineコアプロセス"が停止している
    # かつ "DBプロセス"が起動している
    # かつ "キュープロセス"が起動している
    # かつ "Tengineコンソールプロセス"が起動している
    # かつ Tengine周辺のサーバの時刻が同期されている

  # ユースケースの代替コースAに対応するシナリオです。
  @manual
  シナリオ: [正常系]アプリケーション運用者はエージェントを対象のサーバにインストールする_gemファイルをインストールを行うマシンにsshを行うマシン上に取得している場合
    # ステップにも記載していますが、ローカルの環境にgokuユーザでジョブ実行するシナリオになっています
    # 必要に応じて、ステップに記載している環境は変更してください

    前提 tengine_job_agent.gem,tengine_job_agent.yml.erb がファイルがジョブプロセスウォッチドッグをインストール対象にインストールを行うクライアント上にある
    かつ "Tengineコアプロセス"がコマンド"tengined -f ./features/config/tengine.yml -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb"で起動している

    もし tengine_job_agent.gemをインストールするサーバが生きているか確認するために"ping 対象サーバ"コマンドを行う
    ならば 対象のサーバが生きていることを確認すること

    # tengine_job_agent.gem および依存するgemのインストール
    もし "scp tengine_job_agent-*.*.*.gem ユーザ名@対象サーバ:~/"コマンドを行う
    かつ "scp tengine_event-*.*.*.gem ユーザ名@対象サーバ:~/"コマンドを行う
    かつ "scp tengine_support-*.*.*.gem ユーザ名@対象サーバ:~/"コマンドを行う
    ならば 転送が成功したことを確認する

    # $HOME/tengine_job_agent.yml.erb, /etc/tengine_job_agent.yml.erb
    もし "tengine_job_agent.yml.erb"ファイルにMQの接続先の設定を行う
    かつ "scp tengine_job_agent.yml.erb ユーザ名@対象サーバ:~/"コマンドを行う
    ならば 転送が成功したことを確認する

    # スクリプトのコピー
    もし "scp usecase/job/dsl/tengine_job_test.sh ユーザ名@対象サーバ:~/"コマンドを行う
    ならば 転送が成功したことを確認する

    もし 対象サーバへsshでログインする
    かつ "mkdir log" コマンドを実行する
    かつ "gem install tengine_job_agent.gem" コマンドを実行する
    ならば gemのインストールが成功したことを確認する

    # 仮想サーバ、認証情報の登録
    もし 以下のコマンドで仮想サーバの登録をする
      # IPを 127.0.0.1 にしています。環境に応じて変更してください
      rails runner 'Tengine::Resource::VirtualServer.delete_all;Tengine::Resource::VirtualServer.create(name: "test_server1", addresses: {"private_ip_address" => "127.0.0.1"}, properties: {})' -e production
    もし 以下のコマンドを認証情報の登録をする
      # id: goku, password: dragonball にしています。環境に応じて変更してください
      rails runner 'Tengine::Resource::Credential.delete_all;Tengine::Resource::Credential.create(name: "test_credential1", description: "test_credential1", auth_type_cd: "01", auth_values: {"username"=>"goku", "password"=>"dragonball"})' -e production

    # ジョブの実行をする
    もし rails console を以下のコマンドで実行する
      rails c production
    かつ rails console 上で以下のコマンドを実行する
      template = Tengine::Job::RootJobnetTemplate.first(conditions: {name: "jobnet1001" })
      @execution = nil
      EM.run{ @execution = template.execute(:sender => Tengine::Event) }
      @root_jobnet = @execution.root_jobnet
    ならば rails console 上で以下のコマンドが"完了"になること
      @root_jobnet.reload.phase_name

#########################################
#
# 以下のテストは 1.0.0.rc2時点では実行しない
# 理由:ジョブのテスト接続機能は未実装のため
#
#########################################
  @manual
  シナリオ: [正常系]アプリケーション運用者はエージェントを対象のサーバにインストールする_gemファイルをインストールを行うマシンにsshを行うマシン上に取得している場合_公開鍵認証
     前提 gemファイルがジョブプロセスウォッチドッグをインストール対象にインストールを行うクライアント上にある

    もし "仮想サーバ一覧画面"を表示する
    ならば "仮想サーバ一覧画面"が表示されていること

    もし "仮想サーバ"の"編集"ボタンをクリックする
    ならば "仮想サーバ編集画面"が表示されていること

    もし "仮想サーバ名"に"test_server1"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ一覧画面"が表示されていること
    
    もし tengine_job_agent.gemをインストールするサーバが生きているか確認するために"ping 対象サーバ"コマンドを行う
    ならば 対象のサーバが生きていることを確認すること

    もし "scp tengine_job_agent.gem 対象サーバ:~/"コマンドを行う
    ならば 転送が成功したことを確認する
    #echo $? == 0

    # 設定ファイルは ~/tengine_job_agent.yml.erb もしくは /etc/tengine_job_agent.yml.erb に置く必要がある
    もし "scp tengine_job_agent.yml.erb 対象サーバ:~/"コマンドを行う
    ならば 転送が成功したことを確認する
    #echo $? == 0

    もし 対象サーバへsshでログインし、gem install tengine_job_agent.gem -l
    ならば gemのインストールが成功したことを確認する

    もし "認証情報一覧画面"を表示する
    ならば 認証情報一覧画面を表示していること

    もし "新規登録"リンクをクリックする
    ならば "認証情報登録画面"が表示されていること

    もし "名称"に"test_credential1"と入力する
    かつ "記述"に"test_credential1"と入力する
    かつ "認証種別"から"SSH公開鍵認証"を選択する
    かつ "ユーザ名"に"#{ユーザ名}"と入力する
    かつ "秘密鍵"に"#{秘密鍵}"と入力する
    かつ "パスフレーズ"に"#{パスフレーズ}"と入力する
    かつ "登録"ボタンをクリックする
    ならば "登録確認画面"が表示されていること
    かつ "名称"に"test_credential1"と表示されていること
    かつ "記述"に"test_credential1"と表示されていること
    かつ "認証種別"に"SSH公開鍵認証"と表示されていること
    かつ "ユーザ名"に"#{ユーザ名}"と表示されていること
    かつ "秘密鍵"に"#{秘密鍵}"と表示されていること
    かつ "パスフレーズ"に"#{パスフレーズ}"と表示されていること

    もし "OK"ボタンをクリックする
    ならば "認証情報一覧画面"が表示されていること
    かつ "credentials"に以下の行が表示されていること
    |名称|記述|認証種別|
    |test_credential1|test_credential1|SSH公開鍵認証|

    もし "接続テスト"を行うために"tengined -k jobtest -f ./features/config/tengine.yml"というコマンドを実行する
    ならば "接続テスト"の標準出力に"Connection jobtest success."と出力されていること


  #####################################
  # Tengineコアの接続テストに失敗
  #####################################
  @manual
  シナリオ: [異常系]アプリケーション運用者はエージェントを対象のサーバにインストールする_Mongodbが起動していない
    前提 gemファイルがジョブプロセスウォッチドッグをインストール対象にインストールを行うクライアント上にあること
    かつ "DBプロセス"が停止していること

    もし "仮想サーバ一覧画面"を表示する
    ならば "仮想サーバ一覧画面"が表示されていること

    もし "仮想サーバ"の"編集"ボタンをクリックする
    ならば "仮想サーバ編集画面"が表示されていること

    もし "仮想サーバ名"に"test_server1"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ一覧画面"が表示されていること
    
    もし tengine_job_agent.gemをインストールするサーバが生きているか確認するために"ping 対象サーバ"コマンドを行う
    ならば 対象のサーバが生きていることを確認すること

    もし "scp tengine_job_agent.gem 対象サーバ:"コマンドを行う
    ならば 転送が成功したことを確認する
    #echo $? == 0

    もし "scp tengine_job_agent.gem ユーザ名@対象サーバ:~/"コマンドを行う
    ならば 転送が成功したことを確認する
    #echo $? == 0

    もし 対象サーバへsshでログインし、gem install tengine_job_agent.gem -l
    ならば gemのインストールが成功したことを確認する

    もし "認証情報一覧画面"を表示する
    ならば 認証情報一覧画面を表示していること

    もし "新規登録"リンクをクリックする
    ならば "認証情報登録画面"が表示されていること

    もし "名称"に"test_credential1"と入力する
    かつ "記述"に"test_credential1"と入力する
    かつ "認証種別"から"SSH公開鍵認証"を選択する
    かつ "ユーザ名"に"#{ユーザ名}"と入力する
    かつ "秘密鍵"に"#{秘密鍵}"と入力する
    かつ "パスフレーズ"に"#{パスフレーズ}"と入力する
    かつ "登録"ボタンをクリックする
    ならば "登録確認画面"が表示されていること
    かつ "名称"に"test_credential1"と表示されていること
    かつ "記述"に"test_credential1"と表示されていること
    かつ "認証種別"に"SSH公開鍵認証"と表示されていること
    かつ "ユーザ名"に"#{ユーザ名}"と表示されていること
    かつ "秘密鍵"に"#{秘密鍵}"と表示されていること
    かつ "パスフレーズ"に"#{パスフレーズ}"と表示されていること

    もし "OK"ボタンをクリックする
    ならば "認証情報一覧画面"が表示されていること
    かつ "credentials"に以下の行が表示されていること
    |名称|記述|認証種別|
    |test_credential1|test_credential1|SSH公開鍵認証|

    もし "接続テスト"を行うために"tengined -k jobtest -f ./features/config/tengine.yml"というコマンドを実行する
    ならば "接続テスト"の標準出力に"Mongo::ConnectionFailure"と出力されていること 

    もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば "DBプロセス"が起動していること

    もし "接続テスト"を行うために"tengined -k jobtest -f ./features/config/tengine.yml"というコマンドを実行する
    ならば "接続テスト"の標準出力に"Connection jobtest success."と出力されていること


  @manual
  シナリオ: [異常系]アプリケーション運用者はエージェントを対象のサーバにインストールする_MQが起動していない
     前提 gemファイルがジョブプロセスウォッチドッグをインストール対象にインストールを行うクライアント上にあること
　　　かつ "キュープロセス"が停止していること

    もし "仮想サーバ一覧画面"を表示する
    ならば "仮想サーバ一覧画面"が表示されていること

    もし "仮想サーバ"の"編集"ボタンをクリックする
    ならば "仮想サーバ編集画面"が表示されていること

    もし "仮想サーバ名"に"test_server1"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ一覧画面"が表示されていること
    
    もし tengine_job_agent.gemをインストールするサーバが生きているか確認するために"ping 対象サーバ"コマンドを行う
    ならば 対象のサーバが生きていることを確認すること

    もし "scp tengine_job_agent.gem 対象サーバ:"コマンドを行う
    ならば 転送が成功したことを確認する
    #echo $? == 0

    もし 対象サーバへsshでログインし、gem install tengine_job_agent.gem -l
    ならば gemのインストールが成功したことを確認する

    もし "認証情報一覧画面"を表示する
    ならば 認証情報一覧画面を表示していること

    もし "新規登録"リンクをクリックする
    ならば "認証情報登録画面"が表示されていること

    もし "名称"に"test_credential1"と入力する
    かつ "記述"に"test_credential1"と入力する
    かつ "認証種別"から"SSH公開鍵認証"を選択する
    かつ "ユーザ名"に"#{ユーザ名}"と入力する
    かつ "秘密鍵"に"#{秘密鍵}"と入力する
    かつ "パスフレーズ"に"#{パスフレーズ}"と入力する
    かつ "登録"ボタンをクリックする
    ならば "登録確認画面"が表示されていること
    かつ "名称"に"test_credential1"と表示されていること
    かつ "記述"に"test_credential1"と表示されていること
    かつ "認証種別"に"SSH公開鍵認証"と表示されていること
    かつ "ユーザ名"に"#{ユーザ名}"と表示されていること
    かつ "秘密鍵"に"#{秘密鍵}"と表示されていること
    かつ "パスフレーズ"に"#{パスフレーズ}"と表示されていること

    もし "OK"ボタンをクリックする
    ならば "認証情報一覧画面"が表示されていること
    かつ "credentials"に以下の行が表示されていること
    |名称|記述|認証種別|
    |test_credential1|test_credential1|SSH公開鍵認証|

    もし "接続テスト"を行うために"tengined -k jobtest -f ./features/config/tengine.yml"というコマンドを実行する
    ならば "接続テスト"の標準出力に"[AMQP::TCPConnectionFailed]"と出力されていること 

    もし "キュープロセス"の起動を行うために"rabbitmq-server -detached"というコマンドを実行する
    ならば "キュープロセス"が起動していること

    もし "接続テスト"を行うために"tengined -k jobtest -f ./features/config/tengine.yml"というコマンドを実行する
    ならば "接続テスト"の標準出力に"Connection jobtest success."と出力されていること

  @manual
  シナリオ: [異常系]Tengineジョブのジョブ接続テストに失敗し、Tengineサポート窓口へ問い合わせる_Tengineコアのコードにバグ



  @manual
  シナリオ: [異常系]Tengineコアの接続テストに失敗し、Tengineサポート窓口へ問い合わせる_接続テストのコードにバグ


  @pending
  シナリオ: [正常系]アプリケーション運用者はエージェントを対象のサーバにインストールする_gemファイルをインストールを行うマシンにsshを行うマシン上に取得している場合_ec2アクセスキー
#    どのように行うのかわからないため、中尾さんに確認する
    
