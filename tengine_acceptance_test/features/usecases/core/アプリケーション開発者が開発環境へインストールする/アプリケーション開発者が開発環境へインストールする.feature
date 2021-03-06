#language:ja
機能: アプリケーション開発者が開発環境へインストールする
  Tengineの評価や, イベントハンドラ定義を作成するために
  アプリケーション開発者
  は、Tengineコア, Tengineコンソール, DB, キューをインストールする。
	インストールについては優先度を落としているため、ファイルの作成のみ行いシナリオは定義されていません。
  Tengineコアの「接続テスト」、「起動」、「停止」の異常系については、
	アプリケーション開発者が開発環境でTengineコア、Tengineコンソールを起動し、接続テストを行い、停止する.feature
	で検証します。

  シナリオ: アプリケーション開発者が開発環境へインストールする_基本コース

#     もし 開発環境にDBのインストールを行う
#     かつ 開発環境でDBのプロセスを起動する
#     ならば 開発環境のDBのプロセスが起動している
#     もし 開発環境にキューのインストールを行う
#     かつ 開発環境のキューのプロセスの起動を行う
#     ならば 開発環境のキューのプロセスが起動していること

#     もし 開発環境にTengineコアのインストールを行う
#     かつ 開発環境のTengineコアのセットアップを行う
#      もし "接続テスト"を行うために"tengined -k test -f tengine.yml"というコマンドを実行する
#      ならば "接続テスト"のコンソールに"Success!"と出力されていること
#      もし "Tengineコア"を起動するために"tengined -k start -f tengine.yml"というコマンドを実行する
#      ならば "Tengineコア"のプロセスが起動していること

#      もし 開発環境にTengineコンソールのインストールを行う
#      かつ 開発環境のTengineコンソールのプロセスを起動する
#      もし "Tengineコンソール"を起動するために""というコマンドを実行する
#      ならば "Tengineコンソール"のプロセスが起動していること
#      もし "イベントドライバ管理画面"を表示する
#      ならば "イベントドライバ管理画面"を表示していること
#
#      もし "Tengineコア"を Ctl+c で停止する
#      ならば "Tengineコア"のプロセスが停止していること
#      もし "Tengineコンソール"を Ctl+c で停止する
#      ならば "Tengineコンソール"のプロセスが停止していること
#      もし 開発環境のキューのプロセスをコマンドで停止する
#      ならば 開発環境のキューのプロセスが停止していること
#      もし 開発環境のDBのプロセスをコマンドで停止する
#      ならば 開発環境のDBのプロセスが停止していること
