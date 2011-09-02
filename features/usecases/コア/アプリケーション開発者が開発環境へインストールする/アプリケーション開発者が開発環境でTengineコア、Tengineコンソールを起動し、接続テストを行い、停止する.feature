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
      前提 "DB"パッケージのインストールおよびセットアップが完了している
      かつ "キューパッケージ"のインストールおよびセットアップが完了している
      かつ "Tengineコア"パッケージのインストールおよびセットアップが完了している
      かつ "Tengineコンソール"パッケージのインストールおよびセットアップが完了している
      かつ "DB"プロセスが起動している
      かつ "キュー"プロセスが起動している
      かつ "Tengineコア"プロセスが停止している
      かつ "Tengineコンソール"プロセスが停止している

  シナリオ: [正常系]アプリケーション開発者が開発環境で接続テストを行いTengineコア、Tengineコンソールを起動する

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Success!"と出力されていること
			
      もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること
			
      もし "Tengineコンソールプロセス"を起動するために"rails -e production"というコマンドを実行する
      かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること			

      もし "イベント通知画面"を表示する
			かつ "種別名"に"connect_test"と入力する
			# TODO 接続テストを実施する前の時刻を入力する
			かつ "発生時刻(開始)"に"接続テストを実施する前の時刻"を入力する
			かつ "作成"ボタンをクリックする
      ならば "イベント通知画面"に以下の行が表示されること
      |ID          |種別名       |イベントキー |発生源名         |発生時刻            |通知レベル|通知確認済み|送信者名             |付加情報|
      |xxxxxxxxxxxx|connect_test|xxxxxxxxxxxx|server:tengine1|2011/09/01 12:00:00|info     |TRUE      |server:tengine1/8732|       |
			
      もし "Tengineコア"プロセスを Ctl+c で停止する
      ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

      もし "Tengineコンソールプロセス"を Ctl+c で停止する
      ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  #####################################
  # Tengineコアの接続テストに失敗
  #####################################

  シナリオ: [異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_設定ファイルのパスが不正
      前提 Tengineコアの設定ファイル"not_found_tengine.yml"が存在しないこと

      もし "接続テスト"を行うために"tengined -k test -f not_found_tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"configuration file is not found."と出力されていること #message
			
      もし Tengineコアの設定ファイル"not_found_tengine.yml"に作成する

      もし "接続テスト"を行うために"tengined -k test -f not_found_tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Success!"と出力されていること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_設定未指定

      もし "接続テスト"を行うために"tengined -k test"というコマンドを実行する
      ならば "接続テスト"のコンソールに"specify configuration file or the parameter."と出力されていること #message

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"のコンソールに"Success!"と出力されていること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_設定ファイルに誤り
      前提 Tengineコアの設定ファイル"invalid_tengine.yml"が存在すること # 不正な設定ファイル

      もし "接続テスト"を行うために"tengined -k test -f invalid_tengine.yml"というコマンドを実行する
      ならば "接続テスト"のコンソールに"invalid configuration."と出力されていること #message

      もし Tengineコアの設定ファイル"tengine.yml"に作成する

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Success!"と出力されていること

      # 以下基本コースに戻る

      
  シナリオ: [異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_DBプロセスが起動していない
      前提 "DB"プロセスが起動していない

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to database."と出力されていること #message

      もし "DB"プロセスが起動する

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Success!"と出力されていること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_キュープロセスが起動していない
      前提 "キュー"プロセスが起動していない

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"can't connect to queue server."と出力されていること #message

      もし "キュー"プロセスを起動する

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Success!"と出力されていること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_発火の際にイベントキューが存在しない
      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      # TODO 発火の直前で削除する必要がある
      かつ イベントキューを削除する
      ならば "接続テスト"の標準出力に"event queue is not found."と出力されていること #message

      もし イベントキューを登録する

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Success!"と出力されていること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_発火の際にバインディグが存在しない
      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      # TODO 発火の直前で削除する必要がある
      かつ バインディングを削除する
			
			# バインディングがない場合、publisher側で判断つかない。
      # このため、publishに成功してsubscribeできないという状態になる。
      ならば "接続テスト"の標準出力に"timeout error."と出力されていること #message

      もし イベントエクスチェンジとイベントキューをバインドする

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Success!"と出力されていること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアの接続テストに失敗し、問題を取り除いた後インストールを続行する_発火の際にエクスチェンジが存在しない

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      # TODO 発火の直前で削除する必要がある
      かつ イベントエクスチェンジを削除する
      ならば "接続テスト"の標準出力に"event exchange is not found."と出力されていること #message

      もし イベントエクスチェンジを登録する
      もし イベントエクスチェンジとイベントキューをバインドする

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Success!"と出力されていること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアの接続テストに失敗し、Tengineサポート窓口へ問い合わせる_Tengineコアのコードにバグ
    	# アプリケーション開発者が解決できない問題を発生させるために、Tengineコアのクラスにバグを埋め込む。
			# イベントハンドラ定義の中で、クラスを上書きするような定義をすることでこれを実現する。
      # TODO イベントハンドラ定義を作成する必要がある
			
	    前提 Tengineコアのクラスに不具合を埋め込むイベントハンドラ定義ファイル"./feature/event_handler_def/include_bug_core.rb"があること
      もし "接続テスト"を行うために"tengined -k test -f tengine.yml -T ./feature/event_handler_def/include_bug_core.rb"というコマンドを実行する
      ならば "接続テスト"の標準出力に"inquire of Tengine User Group or Tengine Support Service."と出力されていること #message
#      もし サーバ構成レポート収集ツールでサーバ構成の内容を収集する
#      ならば サーバ構成レポートが作成されていること
      もし Tengineサポート的口へ問い合わせる
      # シナリオ終了


  シナリオ: [異常系]Tengineコアの接続テストに失敗し、Tengineサポート窓口へ問い合わせる_接続テストのコードにバグ
    	# アプリケーション開発者が解決できない問題を発生させるために、接続テストのクラスにバグを埋め込む。
			# イベントハンドラ定義の中で、クラスを上書きするような定義をすることでこれを実現する。
      # TODO イベントハンドラ定義を作成する必要がある
			
	    前提 Tengineコアのクラスに不具合を埋め込むイベントハンドラ定義ファイル"./feature/event_handler_def/include_bug_connect_test.rb"があること
      もし "接続テスト"を行うために"tengined -k test -f tengine.yml -T ./feature/event_handler_def/include_bug_connect_test.rb"というコマンドを実行する
      ならば "接続テスト"の標準出力に"inquire of Tengine User Group or Tengine Support Service."と出力されていること #message
#      もし サーバ構成レポート収集ツールでサーバ構成の内容を収集する
#      ならば サーバ構成レポートが作成されていること
      もし Tengineサポート的口へ問い合わせる
      # シナリオ終了


  #####################################
  # Tengineコアのプロセス起動に失敗
  #####################################

  シナリオ: [[異常系]]Tengineコアのプロセスの起動に失敗し、問題を取り除いた後インストールを続行する_設定ファイルのパスが不正
      前提 Tengineコアの設定ファイル"not_found_tengine.yml"が存在しないこと

      もし "Tengineコアプロセス"を起動するために"tengined -k start -f not_found_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      ならば "Tengineコアプロセス"の標準出力に"configuration file is not found. "と出力されること #message
      かつ "Tengineコアプロセス"が起動していないことを"ps -eo pid PID"で確認できること

      もし Tengineコアの設定ファイル"not_found_tengine.yml"に作成する

      もし "Tengineコアプロセス"を起動するために"tengined -k start -f not_found_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアのプロセスの起動に失敗し、問題を取り除いた後インストールを続行する_設定未指定

      もし "Tengineコアプロセス"を起動するために"tengined -k start"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      ならば "Tengineコアプロセス"の標準出力に"specify configuration file or the parameter. "と出力されること #message
      かつ "Tengineコアプロセス"が起動していないことを"ps -eo pid PID"で確認できること

      もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアのプロセスの起動に失敗し、問題を取り除いた後インストールを続行する_設定ファイルに誤り
      前提 不正なTengineコアプロセスの設定ファイル"invalid_tengine.yml"が存在すること # yamlとしてフォーマットが不正なファイル

      もし "Tengineコアプロセス"を起動するために"tengined -k start -f invalid_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      ならば "Tengineコアプロセス"の標準出力に"invalid configuration."と出力されること #message
      かつ "Tengineコアプロセス"が起動していないことを"ps -eo pid PID"で確認できること

      もし 不正なTengineコアプロセスの設定ファイル"invalid_tengine.yml"を修正する
			
      もし "Tengineコアプロセス"を起動するために"tengined -k start -f invalid_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアのプロセス起動に失敗し、問題を取り除いた後インストールを続行する_DBプロセスが起動していない
      前提 "DB"プロセスが起動していない

      もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      ならば "Tengineコアプロセス"の標準出力に"can't connect to database."と出力されること #message
      かつ "Tengineコアプロセス"が起動していないことを"ps -eo pid PID"で確認できること

      もし "DB"プロセスを起動する

      もし "Tengineコアプロセス"を起動するために"tengined -k start -f invalid_tengine.yml"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

      # 以下基本コースに戻る


  シナリオ: [異常系]Tengineコアのプロセス起動に失敗し、Tengineサポート窓口へ問い合わせる_Tengineコアのコードにバグ			
    	# アプリケーション開発者が解決できない問題を発生させるために、Tengineコアのクラスにバグを埋め込む。
			# イベントハンドラ定義の中で、クラスを上書きするような定義をすることでこれを実現する。
      # TODO イベントハンドラ定義を作成する必要がある
			
      前提 Tengineコアのクラスに不具合を埋め込むイベントハンドラ定義ファイル"./feature/event_handler_def/include_bug_core.rb"があること
      もし "Tengineコアプロセス"を行うために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/include_bug_core.rb"というコマンドを実行する
      ならば "Tengineコアプロセウ"の標準出力に"inquire of Tengine User Group or Tengine Support Service."と出力されていること #message
 #      もし サーバ構成レポート収集ツールでサーバ構成の内容を収集する
#      ならば サーバ構成レポートが作成されていること
      もし Tengineサポート的口へ問い合わせる
      # シナリオ終了


  ######################################
  # Tengineコアの停止に失敗
  #####################################

  シナリオ: [異常系]Tengineコアのプロセスの停止に失敗し、強制停止を行う
      前提 処理が終了しないイベントハンドラ定義"./feature/event_handler_def/endless.rb"が登録されている

      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Success!"と出力されていること
			
      もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/endless.rb"というコマンドを実行する
      ならば "Tengineコアプロセス"の標準出力からPIDを確認することができること
      かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること
			
      もし "Tengineコンソールプロセス"を起動するために"rails -e production"というコマンドを実行する
      かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること			

      もし "イベント通知画面"を表示する
			かつ "種別名"に"connect_test"と入力する
			# TODO 接続テストを実施する前の時刻を入力する
			かつ "発生時刻(開始)"に"接続テストを実施する前の時刻"を入力する
			かつ "作成"ボタンをクリックする
      ならば "イベント通知画面"に以下の行が表示されること
      |ID          |種別名       |イベントキー |発生源名         |発生時刻            |通知レベル|通知確認済み|送信者名             |付加情報|
      |xxxxxxxxxxxx|connect_test|xxxxxxxxxxxx|server:tengine1|2011/09/01 12:00:00|info     |TRUE      |server:tengine1/8732|       |

			もし 処理が終了しないイベントハンドラとバインドされているイベントを発火する
      かつ "Tengineコア"プロセスを Ctl+c で停止する
      かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること
      かつ "Tengineコア"プロセスを強制停止する
      かつ "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること
			
      # 以下基本コースに戻る
