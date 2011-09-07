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
    かつ ファイル"./feature/event_handler_def/uc01_execute_processing_for_event.rb"が存在すること
    かつ ファイル"./feature/event_handler_def/uc02_fire_another_event.rb"が存在すること
    かつ ファイル"./feature/event_handler_def/uc03_2handlers_for_1event.rb"が存在すること
    かつ ファイル"./feature/event_handler_def/uc04_unless_the_event_occurs.rb"が存在すること

# 検証で使用するイベントハンドラ定義ファイルでは、以下のようにイベントのKEYを加えた文言を出力する
# # -*- coding: utf-8 -*-
# require 'tengine/core'
# 
# Tengine.driver :driver01 do
# 
#   # イベントに対応する処理の実行する
#   on:event01 do
#     puts "#{event.key}:handler01"
#   end
# 
# end


#
# イベントに対応する処理の実行するシナリオ
# ./feature/event_handler_def/uc01_execute_processing_for_event.rb
#
  シナリオ:  [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントに対応する処理の実行する
    もし "Tengineコンソールプロセス"を起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動を行うために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ:  [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントに対応するイベントハンドラがない
    もし "Tengineコンソールプロセス"を起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動を行うために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event00"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event00|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていないこと

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ:  [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントに対応する処理の実行する_イベント発火画面でイベント種別名を指定せずに発火
    もし "Tengineコンソールプロセス"を起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動を行うために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # イベント発火画面で未入力状態で発火を試みる
    もし "発火"ボタンをクリックする
    ならば "種別名を入力してください"と表示されていること

    # きちんと入力してイベント発火を試みる
    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


#
# イベントが発生したら新たなイベントを発火するシナリオ
# ./feature/event_handler_def/uc02_fire_another_event.rb
#
  シナリオ: [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントが発生したら新たなイベントを発火する
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc02_fire_another_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver02  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event02_1"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event02_1を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event02_1|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |
    |EVENT_ID|event02_2|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler02_1"と表示されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler02_2"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


#
# イベントに対して処理Aと処理Bを実行するシナリオ
# ./feature/event_handler_def/uc03_2handlers_for_1event.rb
#
  シナリオ: [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントに対して処理Aと処理Bを実行する
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc03_2handlers_for_1event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver03  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event03"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event03を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event03|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler03_1"と表示されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler03_2"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


#
# 特定のイベント以外のイベントに対して処理を実行するシナリオ
# ./feature/event_handler_def/uc04_unless_the_event_occurs.rb
#
  シナリオ: [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_特定のイベント以外のイベントに対して処理を実行する_処理が実行される場合
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc04_unless_the_event_occurs.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event02"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event04を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event02|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler04"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [正常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_特定のイベント以外のイベントに対して処理を実行する_処理が実行されない場合
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc04_unless_the_event_occurs.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event04"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event04を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event04|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler04"と表示されていないこと

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


#
# 異常系シナリオ
#

#
# イベントドライバ一覧画面での異常系
# イベントドライバ一覧画面の操作途中でプロセスが落ちた場合の検証を行うため、ユースケースには存在しないがイベントドライバを有効から無効、無効から有効に変更する操作を行っているシナリオがあります
# イベントドライバ一覧画面はキューの起動は影響を受けない
#
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面が表示されない_Tengineコンソールが起動していない
    #
    # Tengineコンソールが起動していないためイベントドライバ一覧画面の表示に失敗する
    #
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していないこと
    かつ "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面が表示されない_DBが起動していない
    #
    # DBのプロセスが起動していないため、イベントドライバ一覧画面が表示できない
    #
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    # 異常を発生させるためDBを停止する
    もし DBを停止するために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js""というコマンドを実行する
    ならば DBが停止していることを"ps -eo pid PID"で確認できること

    # DBが落ちているので、500エラーになる
    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していないこと
    かつ "データベースの接続に失敗しました"と表示されていること
    # Mongo::ConnectionFailure が発生

    # TengineコアプロセスはDB停止後にDBにアクセスしていないので停止しない

    # DBの起動
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面でイベントドライバを有効から無効に変更できない_Tengineコンソールが途中で停止した
    #
    # イベントドライバ一覧画面を表示後にTengineコンソールが落ちたため、イベントドライバを有効から無効に変更できない
    #
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "無効ボタン"をクリックする
    ならば "イベントドライバ一覧画面"を表示されていないこと
    かつ "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "無効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |無効|

    もし "有効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること
 
    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面でイベントドライバを有効から無効に変更できない_DBが途中で停止した
    #
    # イベントドライバ一覧画面を表示後にDBが落ちたため、イベントドライバを有効から無効に変更できない
    #
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    # 異常を発生させるためDBを停止する
    もし DBを停止するために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js""というコマンドを実行する
    ならば DBが停止していることを"ps -eo pid PID"で確認できること

    # DBが落ちているので、500エラーになる
    もし "無効ボタン"をクリックする
    ならば "イベントドライバ一覧画面"を表示されていないこと
    かつ "データベースの接続に失敗しました"と表示されていること
    # "Mongo::ConnectionFailure" が発生

    # TengineコアプロセスはDB停止後にDBにアクセスしていないので停止しない

    # DBの起動
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "無効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |無効|

    もし "有効"ボタンをクリックする
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


#
# イベント発火画面での異常系
#
  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント発火画面が表示されない_Tengineコンソールが起動してない
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していないこと
    かつ "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_キューが起動していない
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためキュープロセスを停止する
    もし キューを停止する
    ならば キューが停止していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "キューへの接続に失敗しました"と表示されていること

    # 復旧させるためにキューを起動する
    もし キューを起動する
    ならば キューが起動していること

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントキューが存在しない
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためイベントキューを削除する
    もし イベントキューを削除する
    ならば イベントキューを削除していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "イベントキューが存在しません"と表示されていること

    # 復旧させるためにコアプロセスを停止し、起動する
    もし "Tengineコア"を Ctl+c で停止する
    ならば "Tengineコア"のプロセスが停止していること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントエクスチェンジがバインディングされていない
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためイベントキューをアンバインドする
    もし イベントキューをアンバインドする
    ならば イベントキューをアンバインドしていること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "イベントキューが存在しません"と表示されていること

    # 復旧させるためにコアプロセスを停止し、起動する
    もし "Tengineコア"を Ctl+c で停止する
    ならば "Tengineコア"のプロセスが停止していること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_発火の際にイベントエクスチェンジが存在しない
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためイベントエクスチェンジを削除する
    もし イベントエクスチェンジを削除する
    ならば イベントエクスチェンジを削除していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "イベントエクスチェンジが存在しません"と表示されていること

    # 復旧させるためにコアプロセスを停止し、起動する
    もし "Tengineコア"を Ctl+c で停止する
    ならば "Tengineコア"のプロセスが停止していること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_event01が発火されたと表示されない_Tengineコンソールが起動してない
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること
    ならば "railsのログ"に"プロセスが停止したログ"が含まれていること

    # 復旧させるためにTengineコンソールのプロセスを再度起動して処理を再度行う
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_DBが起動していない
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためDBを停止する
    もし DBを停止するために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js""というコマンドを実行する
    ならば DBが停止していることを"ps -eo pid PID"で確認できること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されていないこと
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていないこと

    # DB接続に失敗してTengineコアプロセスが停止している
    もし "Tengineコアプロセスのプロセスログファイル"を表示する
    ならば "Tengineコアプロセスのプロセスログファイル"に"Mongo::ConnectionFailure"と表示していること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_Tengineコアのコードにバグがあった場合
    前提 Tengineコアのコードにバグがある_(保留)

    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    かつ "Tengineユーザグループ、またはTengineサポート窓口に問い合わせを行ってください。"と表示されていること

    #(保留)
    もし "Tengineコアプロセスログ"を表示する
    ならば "Tengineコアプロセス"の標準出力に"異常終了しました"と表示していること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_DBが停止したことが原因でTengineコアが停止した
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためDB停止する
    もし DBを停止するために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js""というコマンドを実行する
    ならば DBが停止していることを"ps -eo pid PID"で確認できること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されていないこと
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていないこと

    # 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_Tengineコアのコンソールに"handler01"と表示されない_Tengineコアが停止した
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    # 異常を発生させるためTengineコアを停止する
    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されていないこと
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていないこと

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

  シナリオ:  [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント処理中にキューが落ちた
    もし "Tengineコンソールプロセス"を起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動を行うために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event00"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event00|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていないこと

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントハンドリングでイベントを発火する前にキューが落ちた
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc02_fire_another_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver02  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event02_1"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event02_1を発火しました"と表示されていること

    # 自動でテストを行う為には、イベントハンドラ定義を修正して、fireする直前にキューを落とすよう修正する必要があると思われます
    もし イベントを受信してから、event02_1で起動するイベントハンドラのputsを実行するまでにイベントキューを落とす
    ならば キューが停止する
    ならば "Tengineコアプロセス"の標準出力に"キューとの接続が切断されました"と表示されること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event02_1|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler02_1"と表示されていること

    もし キューを起動する
    ならば キューがしていることを確認できること
    かつ "Tengineコアプロセス"の標準出力に"キューと接続しました"と表示されること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event02_1|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |
    |EVENT_ID|event02_2|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler02_2"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系] アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc03_2handlers_for_1event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event03"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event03を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event03|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler03_1"と表示されていること
    かつ "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler03_2"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


#
# イベント通知画面での異常系
# 画面イメージ:
# https://docs.google.com/a/nautilus-technologies.com/spreadsheet/ccc?key=0AiCFoDki8k_ndEZmOXZJSFZxZURKZTd5ejBEWW1YQ2c&hl=ja#gid=0
# イベント通知画面は通知されたイベントを確認する画面であり、metaタグを使用して定期的にリフレッシュを行う
# 
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面が表示されない_Tengineコンソールが起動していない
    #
    # イベント発火の発火後にTengineコンソールが落ちたため、イベント通知画面が表示されない
    #
    もし "Tengineコンソールプロセス"を起動を行うために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動を行うために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していないこと
    かつ "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面が表示されない_DBが起動していない
    #
    # DBのプロセスが起動していないためイベント通知画面の表示に失敗する
    #
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    # 異常を発生させるためDBを停止する
    もし DBを停止するために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js""というコマンドを実行する
    ならば DBが停止していることを"ps -eo pid PID"で確認できること

    # DBが落ちているので、500エラーになる
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していないこと
    かつ "データベースの接続に失敗しました"と表示されていること
    # Mongo::ConnectionFailure が発生
 
    # TengineコアプロセスはDB停止後にDBにアクセスしていないので停止しない

    # DBの起動
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面でイベントを通知確認済みに変更できない_Tengineコンソールが途中で停止した
    #
    # イベント通知画面を表示後にTengineコンソールが落ちたため、イベントを通知確認済みに変更できない
    #
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "編集"ボタンをクリックする
    ならば "イベント編集画面"が表示されていること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールが落ちているので、タイムアウトエラーになる
    もし "通知確認済み"をチェックする
    かつ "更新"ボタンをクリックする
    ならば "イベント参照画面"が表示されていないこと
    かつ "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "編集"ボタンをクリックする
    ならば "イベント編集画面"が表示されていること

    もし "通知確認済み"をチェックする
    かつ "更新"ボタンをクリックする
    ならば "イベント参照画面"が表示されていること

    かつ "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |true      |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面でイベントを通知確認済みに変更できない_DBが途中で停止した
    #
    # イベント通知画面を表示後にDBが落ちたため、イベントを通知確認済みに変更できない
    #
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行の表示がされていること
    |  driver01  |有効|

    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "編集"ボタンをクリックする
    ならば "イベント編集画面"が表示されていること

    # 異常を発生させるためDBを停止する
    もし DBを停止するために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js""というコマンドを実行する
    ならば DBが停止していることを"ps -eo pid PID"で確認できること

    # DBが落ちているので、500エラーになる
    もし "通知確認済み"をチェックする
    かつ "更新"ボタンをクリックする
    ならば "イベント参照画面"が表示されていないこと
    かつ "データベースの接続に失敗しました"と表示されていること
    # Mongo::ConnectionFailure が発生

    # TengineコアプロセスはDB停止後にDBにアクセスしていないので停止しない

    # DBの起動
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールプロセスは停止していないので起動は行わない

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |false     |tengine_console|       |

    もし "編集"ボタンをクリックする
    ならば "イベント編集画面"が表示されていること

    もし "通知確認済み"をチェックする
    かつ "更新"ボタンをクリックする
    ならば "イベント参照画面"が表示されていること

    かつ "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |EVENT_ID|event01|KEY|tengine_console|2011/09/01 12:00:00|info     |true      |tengine_console|       |

    もし "Tengineコアプロセスのイベント処理ログファイル"を表示する
    ならば "Tengineコアプロセスのイベント処理ログファイル"に"KEY:handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること
