#language:ja
機能: アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる
  [Tengineの導入を検討]するために
  [アプリケーション開発者]
  は [Tengineを評価] したい
  {アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる}のユースケースのうち、No.5,6,7を確認するためのテストである

  背景:
    前提 "DBパッケージ"のインストールおよびセットアップが完了している
    かつ "キューパッケージ"のインストールおよびセットアップが完了している
    かつ "Tengineコアパッケージ"のインストールおよびセットアップが完了している
    かつ "Tengineコンソールパッケージ"のインストールおよびセットアップが完了している
    かつ "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコアプロセス"が停止している
    かつ "Tengineコンソールプロセス"が停止している
    かつ ファイル"./usecases/core/dsls/uc01_execute_processing_for_event.rb"が存在すること
    かつ ファイル"./usecases/core/dsls/uc02_fire_another_event.rb"が存在すること
    かつ ファイル"./usecases/core/dsls/uc03_2handlers_for_1event.rb"が存在すること
    かつ ファイル"./usecases/core/dsls/uc04_unless_the_event_occurs.rb"が存在すること

# 検証で使用するイベントハンドラ定義ファイルでは、以下のようにイベントのKEYを加えた文言を出力する
# # -*- coding: utf-8 -*-
# require 'tengine/core'
#
# driver :driver01 do
#
#   # イベントに対応する処理の実行する
#   on:event01 do
#     puts "#{event.key}:handler01"
#   end
#
# end


#
# イベントに対応する処理の実行するシナリオ
# ./usecases/core/dsls/uc01_execute_processing_for_event.rb
#
  @selenium
  シナリオ:  [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントに対応する処理の実行する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること
    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    かつ "Tengineコアプロセス"の標準出力に"#{イベントキー}:handler01"と出力されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ:  [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントに対応するイベントハンドラがない
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|
		
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻                  |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    かつ "Tengineコアプロセス"の標準出力に"#{イベントキー}:handler01"と出力されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ:  [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントに対応する処理の実行する_イベント発火画面でイベント種別名を指定せずに発火
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # イベント発火画面で未入力状態で発火を試みる
    かつ "登録する"ボタンをクリックする
    ならば "種別名を入力してください"と表示されていること

    # きちんと入力してイベント発火を試みる
    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


#
# イベントが発生したら新たなイベントを発火するシナリオ
# ./usecases/core/dsls/uc02_fire_another_event.rb
#
  @selenium
  シナリオ: [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントが発生したら新たなイベントを発火する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc02_fire_another_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver02|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event02_1"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event02_1を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event02_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    |event02_2|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
	  ならば "アプリケーションログファイル"に以下の順で記述されていること
    |#{イベントキー}:handler02_1|
    |             :handler02_2|

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


#
# イベントに対して処理Aと処理Bを実行するシナリオ
# ./usecases/core/dsls/uc03_2handlers_for_1event.rb
#
  @selenium
  シナリオ: [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントに対して処理Aと処理Bを実行する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc03_2handlers_for_1event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver03|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event03"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event03を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event03|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
	  ならば "アプリケーションログファイル"に以下の順で記述されていること		
    |#{イベントキー}:handler03_1|
    |             :handler03_2|

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


#
# 特定のイベント以外のイベントに対して処理を実行するシナリオ
# ./usecases/core/dsls/uc04_unless_the_event_occurs.rb
#
  @selenium
  シナリオ: [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_特定のイベント以外のイベントに対して処理を実行する_処理が実行される場合
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc04_unless_the_event_occurs.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver04|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event04"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event04を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event02|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler04"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_特定のイベント以外のイベントに対して処理を実行する_処理が実行されない場合
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc04_unless_the_event_occurs.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver04|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event04"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event04を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event04|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler04"と記述されていないこと

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


#
# 異常系シナリオ
#

#
# イベントドライバ一覧画面での異常系
# イベントドライバ一覧画面の操作途中でプロセスが落ちた場合の検証を行うため、ユースケースには存在しないがイベントドライバを有効から無効、無効から有効に変更する操作を行っているシナリオがあります
# イベントドライバ一覧画面はキューの起動は影響を受けない
#
  @selenium
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面が表示されない_Tengineコンソールが起動していない
    #
    # Tengineコンソールが起動していないためイベントドライバ一覧画面の表示に失敗する
    #
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していないこと
    かつ "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面が表示されない_DBが起動していない
    #
    # DBのプロセスが起動していないため、イベントドライバ一覧画面が表示できない
    #
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # 異常を発生させるためDBを停止する
    もし "DBプロセス"の停止を行うために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js"というコマンドを実行する
    ならば "DBプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # DBが落ちているので、500エラーになる
    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していないこと
    かつ "データベースの接続に失敗しました"と表示されていること
    # Mongo::ConnectionFailure が発生

    # TengineコアプロセスはDB停止後にDBにアクセスしていないので停止しない

    # DBの起動
    もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば "DBプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面でイベントドライバを有効から無効に変更できない_Tengineコンソールが途中で停止した
    #
    # イベントドライバ一覧画面を表示後にTengineコンソールが落ちたため、イベントドライバを有効から無効に変更できない
    #
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |状態|
    |driver01|有効|

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "無効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していないこと
    かつ "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |状態|
    |driver01|有効|

    もし "無効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |状態|
    |driver01|無効|

    もし "有効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |状態|
    |driver01|有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

  @selenium
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面でイベントドライバを有効から無効に変更できない_DBが途中で停止した
    #
    # イベントドライバ一覧画面を表示後にDBが落ちたため、イベントドライバを有効から無効に変更できない
    #
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |状態|
    |driver01|有効|

    # 異常を発生させるためDBを停止する
    もし "DBプロセス"の停止を行うために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js"というコマンドを実行する
    ならば "DBプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # DBが落ちているので、500エラーになる
    もし "無効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していないこと
    かつ "データベースの接続に失敗しました"と表示されていること
    # "Mongo::ConnectionFailure" が発生

    # TengineコアプロセスはDB停止後にDBにアクセスしていないので停止しない

    # DBの起動
    もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば "DBプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |状態|
    |driver01|有効|

    もし "無効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |状態|
    |driver01|無効|

    もし "有効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |状態|
    |driver01|有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


#
# イベント発火画面での異常系
#
  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント発火画面が表示されない_Tengineコンソールが起動してない
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していないこと
    かつ "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_キューが起動していない
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためキュープロセスを停止する
    もし "キュープロセス"の停止を行うために"rabbitmqctl stop"というコマンドを実行する
    ならば "キュープロセス"が停止していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
		
    ならば "キューへの接続に失敗しました"と表示されていること

    # 復旧させるためにキューを起動する
    もし "キュープロセス"の起動を行うために"rabbitmq-server -detached"というコマンドを実行する
    ならば "キュープロセス"が起動していること

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントキューが存在しない
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためイベントキューを削除する
    もし イベントキューを削除する
    ならば イベントキューが存在しないこと

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "イベントキューが存在しません"と表示されていること

    # 復旧させるためにコアプロセスを停止し、起動する
    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントエクスチェンジがバインディングされていない
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためイベントキューをアンバインドする
    もし イベントキューをアンバインドする
    ならば イベントキューをバインドしていないこと

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "イベントキューが存在しません"と表示されていること

    # 復旧させるためにコアプロセスを停止し、起動する
    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントエクスチェンジが存在しない
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためイベントエクスチェンジを削除する
    もし イベントエクスチェンジを削除する
    ならば イベントエクスチェンジが存在しないこと

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "イベントエクスチェンジが存在しません"と表示されていること

    # 復旧させるためにコアプロセスを停止し、起動する
    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|


    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_Tengineコンソールが起動してない
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|


    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていないこと

    # 復旧させるためにTengineコンソールのプロセスを再度起動して処理を再度行う
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_DBが起動していない
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためDBを停止する
    もし "DBプロセス"の停止を行うために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js"というコマンドを実行する
    ならば "DBプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていないこと

    # DB接続に失敗してTengineコアプロセスが停止している
    もし "プロセスログファイル""log/stdout.log"を参照する
    ならば "プロセスログファイル"に"Mongo::ConnectionFailure"と記述されていること
    かつ "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
    もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば "DBプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @wip
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_Tengineコアのコードにバグがあった場合
    前提 Tengineコアのコードにバグがある_(保留)

    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "Tengineユーザグループ、またはTengineサポート窓口に問い合わせを行ってください。"と表示されていること

    #(保留)
    もし "プロセスログファイル""log/stdout.log"を参照する
    ならば "プロセスログファイル"に"異常終了しました"と記述されていること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_DBが停止したことが原因でTengineコアが停止した
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためDB停止する
    もし "DBプロセス"の停止を行うために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js"というコマンドを実行する
    ならば "DBプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていないこと

    # 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
    もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば "DBプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_Tengineコアが停止した
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためTengineコアを停止する
    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていないこと

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

  @selenium
  シナリオ:  [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント処理中にキューが落ちた
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていないこと

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @wip
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントハンドリングでイベントを発火する前にキューが落ちた
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc99_stop_rabbitmq_and_fire_another_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver99|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event99_1"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event99_1を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event99_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    ならば "キュープロセス"が停止していること
    かつ "Tengineコアプロセス"の標準出力に"mq.connection.on_tcp_connection_loss: now reconnecting"と出力されていること

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler99_1"と記述されていること
    かつ "アプリケーションログファイル"に"send event failure: cant's connect to queue server."と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc03_2handlers_for_1event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver03|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event03"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event03を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event03|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler03_1"と記述されていること
    かつ "アプリケーションログファイル"に"#{イベントキー}:handler03_2"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


#
# イベント通知画面での異常系
# 画面イメージ:
# https://docs.google.com/a/nautilus-technologies.com/spreadsheet/ccc?key=0AiCFoDki8k_ndEZmOXZJSFZxZURKZTd5ejBEWW1YQ2c&hl=ja#gid=0
# イベント通知画面は通知されたイベントを確認する画面であり、metaタグを使用して定期的にリフレッシュを行う
#
  @selenium
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面が表示されない_Tengineコンソールが起動していない
    #
    # イベント発火の発火後にTengineコンソールが落ちたため、イベント通知画面が表示されない
    #
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していないこと
    かつ "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面が表示されない_DBが起動していない
    #
    # DBのプロセスが起動していないためイベント通知画面の表示に失敗する
    #
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    # 異常を発生させるためDBを停止する
    もし "DBプロセス"の停止を行うために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js"というコマンドを実行する
    ならば "DBプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # DBが落ちているので、500エラーになる
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していないこと
    かつ "データベースの接続に失敗しました"と表示されていること
    # Mongo::ConnectionFailure が発生

    # TengineコアプロセスはDB停止後にDBにアクセスしていないので停止しない

    # DBの起動
    もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば "DBプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面でイベントを通知確認済みに変更できない_Tengineコンソールが途中で停止した
    #
    # イベント通知画面を表示後にTengineコンソールが落ちたため、イベントを通知確認済みに変更できない
    #
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "編集"ボタンをクリックする
    ならば "イベント編集画面"を表示していること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "通知確認済み"をチェックする
    かつ "更新"ボタンをクリックする
    ならば "イベント参照画面"を表示していないこと
    かつ "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "編集"ボタンをクリックする
    ならば "イベント編集画面"を表示していること

    もし "通知確認済み"をチェックする
    かつ "更新"ボタンをクリックする
    ならば "イベント参照画面"を表示していること

    かつ "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true      |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面でイベントを通知確認済みに変更できない_DBが途中で停止した
    #
    # イベント通知画面を表示後にDBが落ちたため、イベントを通知確認済みに変更できない
    #
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "種別名"に"event01"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "編集"ボタンをクリックする
    ならば "イベント編集画面"を表示していること

    # 異常を発生させるためDBを停止する
    もし "DBプロセス"の停止を行うために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js"というコマンドを実行する
    ならば "DBプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # DBが落ちているので、500エラーになる
    もし "通知確認済み"をチェックする
    かつ "更新"ボタンをクリックする
    ならば "イベント参照画面"を表示していないこと
    かつ "データベースの接続に失敗しました"と表示されていること
    # Mongo::ConnectionFailure が発生

    # TengineコアプロセスはDB停止後にDBにアクセスしていないので停止しない

    # DBの起動
    もし "DBプロセス"の起動を行うために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば "DBプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "編集"ボタンをクリックする
    ならば "イベント編集画面"を表示していること

    もし "通知確認済み"をチェックする
    かつ "更新"ボタンをクリックする
    ならば "イベント参照画面"を表示していること

    かつ "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event01|tengine_console|2011-09-01 12:00:00 +0900|2     |true      |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler01"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること


  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントハンドリングでイベントを発火する前にキューが落ちた_リトライ設定回数内にキューが起動する
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc97_stop_rabbitmq_and_fire.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver97|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event97_1"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event97_1を発火しました"と表示されていること

 
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event97_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    かつ "キュープロセス"が停止していること
    かつ "Tengineコアプロセス"の標準出力に"mq.connection.on_tcp_connection_loss: now reconnecting"と出力されていること

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler97_1"と記述されていること

    もし "キュープロセス"の起動を行うために"rabbitmq-server -detached"というコマンドを実行する
    ならば "キュープロセス"が起動していること
    かつ "Tengineコアプロセス"の標準出力に"mq.connection.after_recovery: recovered successfully."と出力されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event97_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    |event97_2|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    かつ "アプリケーションログファイル"に"#{イベントキー}:handler97_2"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントハンドリングでイベントを発火する前にキューが落ちた_リトライ設定回数内にキューが起動しない
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc97_stop_rabbitmq_and_fire.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver97|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event97_1"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event97_1を発火しました"と表示されていること

 
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event97_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    かつ "キュープロセス"が停止していること
    かつ "Tengineコアプロセス"の標準出力に"mq.connection.on_tcp_connection_loss: now reconnecting"と出力されていること

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler97_1"と記述されていること
 
    もし リトライ間隔だけ待機する
    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"send event failure: can't connect to queue server."と記述されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event97_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントハンドリングでイベントを発火する前にキューが落ちた_リトライ設定回数内にキューが起動する_コールバックを利用
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc98_stop_rabbitmq_and_fire_use_callback.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver98|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event98_1"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event98_1を発火しました"と表示されていること

 
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event97_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    かつ "キュープロセス"が停止していること
    かつ "Tengineコアプロセス"の標準出力に"mq.connection.on_tcp_connection_loss: now reconnecting"と出力されていること

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler97_1"と記述されていること
 
    もし "キュープロセス"の起動を行うために"rabbitmq-server -detached"というコマンドを実行する
    ならば "キュープロセス"が起動していること
    かつ "Tengineコアプロセス"の標準出力に"mq.connection.after_recovery: recovered successfully."と出力されていること

    もし リトライ間隔だけ待機する
    かつ "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event97_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    |event97_2|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "アプリケーションログファイル""log/application.log"を参照する
    かつ "アプリケーションログファイル"に"#{イベントキー}:send_event_failure"と記述されていること
    #仕様が確定していないので、確定後記載しなおす。
    かつ "アプリケーションログファイル"に"#{イベントキー}:handler97_2"と記述されていること

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

  @selenium
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントハンドリングでイベントを発火する前にキューが落ちた_リトライ設定回数内にキューが起動しない_コールバック利用
    もし "Tengineコンソールプロセス"の起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル"tmp/pids/server.pid"からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコアプロセス"の起動を行うために"tengined -k start -f ./features/config/tengine.yml -T ./usecases/core/dsls/uc98_stop_rabbitmq_and_fire_use_callback.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver98|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event98_1"と入力する
    かつ RailsConsoleで"Tengine::Event.uuid_gen.generate"と実行し生成したイベントキーを確認する
    かつ "イベントキー"に"#{イベントキー}"を入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event98_1を発火しました"と表示されていること

 
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event97_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|
    かつ "キュープロセス"が停止していること
    かつ "Tengineコアプロセス"の標準出力に"mq.connection.on_tcp_connection_loss: now reconnecting"と出力されていること

    もし "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"#{イベントキー}:handler97_1"と記述されていること
 
    もし リトライ間隔だけ待機する
    かつ "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"try:1,falure event:failur_event"と記述されていること
    かつ "アプリケーションログファイル"に"try:2,falure event:failur_event"と記述されていないこと
    かつ "アプリケーションログファイル"に"try:3,falure event:failur_event"と記述されていないこと
    かつ "アプリケーションログファイル"に"send event failure: can't connect to queue server."と記述されていないこと

    もし リトライ間隔だけ待機する
    かつ "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"try:2,falure event:failur_event"と記述されていること
    かつ "アプリケーションログファイル"に"try:3,falure event:failur_event"と記述されていないこと
    かつ "アプリケーションログファイル"に"send event failure: can't connect to queue server."と記述されていないこと


    もし リトライ間隔だけ待機する
    かつ "アプリケーションログファイル""log/application.log"を参照する
    ならば "アプリケーションログファイル"に"try:3,falure event:failur_event"と記述されていること
    かつ "アプリケーションログファイル"に"send event failure: can't connect to queue server."と記述されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |発生源名        |発生時刻            |通知レベル|通知確認済み|送信者名        |
    |event98_1|tengine_console|2011-09-01 12:00:00 +0900|2     |true     |tengine_console|

    もし "Tengineコアプロセス"を Ctrl+c で停止する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "Tengineコンソールプロセス"を Ctrl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること