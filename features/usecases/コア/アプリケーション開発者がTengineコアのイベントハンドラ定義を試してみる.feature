#language:ja
機能: アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる
  [Tengineの導入を検討]するために
  [アプリケーション開発者]
  は [Tengineを評価] したい
  {アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる}のユースケースのうち、No.5,6,7を確認するためのテストである

  背景:
    前提 DBパッケージのインストールおよびセットアップが完了している
    かつ キューパッケージのインストールおよびセットアップが完了している
    かつ Tengineコアパッケージのインストールおよびセットアップが完了している
    かつ Tengineコンソールパッケージのインストールおよびセットアップが完了している
    かつ DBプロセスがコマンド"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"で起動している
    かつ キュープロセスが起動している
    かつ Tengineコアのプロセスが停止している
    かつ Tengineコンソールのプロセスが停止している
    かつ "./feature/event_handler_def/uc01_execute_processing_for_event.rb"というファイルが存在する

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event00|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていないこと

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
    ならば "event_fire_status"に"種別名を入力してください"と表示されていること

    # きちんと入力してイベント発火を試みる
    もし "種別名"に"event01"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "発生時刻"に"2011/09/01 12:00:00"と入力する
    かつ "通知レベル"から"info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "発火"ボタンをクリックする
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"event02_1を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event02_1|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |
    |xxxxxxxxxxxx|event02_2|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler02_1"と表示されていること
    かつ "event_process.log"に"handler02_2"と表示されていること

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
    ならば "event_fire_status"に"event03を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event03|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler03_1"と表示されていること
    かつ "event_process.log"に"handler03_2"と表示されていること

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
    ならば "event_fire_status"に"event04を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event02|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler04"と表示されていること

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
    ならば "event_fire_status"に"event04を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event04|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler04"と表示されていないこと

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
    # Tengineコンソールが起動していないためイベントドライバ一覧画面が表示されない
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

    # Tengineコンソールが落ちているので、404エラーになる
    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していないこと
    かつ "404"と表示されていること
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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面が表示されない_DBが起動していない
    #
    # DBのプロセスが起動していない場合、Tengineコンソールのプロセスが停止する
    # 同時に、Tengineコアも停止している
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
    かつ "Mongo::ConnectionFailure"と表示されていること

    もし "Tengineコアプロセスログ"を表示する
    ならば "Tengineコアプロセスログ"に"Mongo::ConnectionFailure"と表示していること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # DBの起動
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    # Tengineコアプロセス起動
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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面でイベントドライバを有効から無効に変更できない_Tengineコンソールが起動していない
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

    # Tengineコンソールが落ちているので、404エラーになる
    もし "無効ボタン"をクリックする
    ならば "イベントドライバ一覧画面"を表示されていないこと
    かつ "404"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベントドライバ一覧画面でイベントドライバを有効から無効に変更できない_DBが起動していない
    #
    # イベントドライバ一覧画面を表示後にTengineコンソールが落ちたため、イベントドライバを有効から無効に変更できない
    # DBのプロセスが起動していない場合、Tengineコンソールのプロセスが停止する
    # 同時に、Tengineコアも停止している
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
    かつ "Mongo::ConnectionFailure"と表示されていること

    # Tengineコアプロセスも落ちている
    もし "Tengineコアプロセスログ"を表示する
    ならば "Tengineコアプロセスログ"に"Mongo::ConnectionFailure"と表示していること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # DBの起動
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    # Tengineコアプロセス起動
    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


#
# イベント発火画面での異常系
# イベント発火画面の異常系をこちらにまとめる(正常系と異常系が混ざっていて見難いため)
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

    # Tengineコンソールが落ちているので、404エラーになる
    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していないこと
    かつ "404"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"キューへの接続に失敗しました"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"イベントキューが存在しません"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"イベントエクスチェンジが存在しません"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること
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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されていないこと
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていないこと

    もし "Tengineコアプロセスログ"を表示する
    ならば "Tengineコアプロセスログ"に"Mongo::ConnectionFailure"と表示していること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること
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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されていないこと
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていないこと

    # 復旧させるためにDBの起動、Tengineの起動して処理を再度行う
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されていないこと
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていないこと

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event00|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていないこと

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
    ならば "event_fire_status"に"event02_1を発火しました"と表示されていること

    # 自動でテストを行う為には、イベントハンドラ定義を修正して、fireする直前にキューを落とすよう修正する必要があると思われます
    もし イベントを受信してから、event02_1で起動するイベントハンドラのputsを実行するまでにイベントキューを落とす
    ならば キューが停止する
    ならば "Tengineコアプロセス"の標準出力に"キューとの接続が切断されました"と表示されること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event02_1|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler02_1"と表示されていること

    もし キューを起動する
    ならば キューがしていることを確認できること
    かつ "Tengineコアプロセス"の標準出力に"キューと接続しました"と表示されること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event02_1|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |
    |xxxxxxxxxxxx|event02_2|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    かつ "event_process.log"に"handler02_2"と表示されていること

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
    ならば "event_fire_status"に"event03を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event03|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler03_1"と表示されていること
    かつ "event_process.log"に"handler03_2"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


#
# イベント通知画面での異常系
# 画面イメージ:
# https://docs.google.com/a/nautilus-technologies.com/spreadsheet/ccc?key=0AiCFoDki8k_ndEZmOXZJSFZxZURKZTd5ejBEWW1YQ2c&hl=ja#gid=0
# 発火されたイベントを確認する画面でjsで定期的にリロードを行う
# イベントには以下の通知レベルがあり、errorとfatalに関しては、通知確認済みでないイベントはjsでアラートを出す
# {0:"gr_heartbeat", 1:"debug", 2:"info", 3:"warn", 4:"error", 5:"fatal"}
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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    # 異常を発生させるためTengineコンソールのプロセスを停止する
    もし "Tengineコンソール"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していないこと
    かつ "404"と表示されていること
    かつ "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # Tengineコンソールを復旧する
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面が表示されない_DBが起動していない
    #
    # DBのプロセスが起動していない場合、Tengineコンソールのプロセスが停止する
    # 同時に、Tengineコアも停止している
    #
    もし "Tengineコンソールプロセス"を起動するために"rails s -e production"というコマンドを実行する
    ならば "Tengineコンソールプロセス"のPIDファイル(tmp/pids/server.pid)からPIDを確認できること
    かつ "Tengineコンソールプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    # DBが落ちているので、500エラーになる
    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していないこと
    かつ "Mongo::ConnectionFailure"と表示されていること

    もし "Tengineコアプロセスログ"を表示する
    ならば "Tengineコアプロセスログ"に"Mongo::ConnectionFailure"と表示していること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # DBの起動
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    # Tengineコアプロセス起動
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
    ならば "event_fire_status"に"event01を発火しました"と表示されていること

    # 異常を発生させるためDBを停止する
    もし DBを停止するために"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js""というコマンドを実行する
    ならば DBが停止していることを"ps -eo pid PID"で確認できること

    # DBが落ちているので、500エラーになる
    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していないこと
    かつ "Mongo::ConnectionFailure"と表示されていること

    もし "Tengineコアプロセスログ"を表示する
    ならば "Tengineコアプロセスログ"に"Mongo::ConnectionFailure"と表示していること
    かつ "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    # DBの起動
    もし DBを起動するために"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet"というコマンドを実行する
    ならば DBが起動していることを"ps -eo pid PID"で確認できること

    # Tengineコアプロセス起動
    もし "Tengineコアプロセス"を起動するために"tengined -k start -f tengine.yml -T ./feature/event_handler_def/uc01_execute_processing_for_event.rb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認できること
    かつ "Tengineコアプロセス"が起動していることを"ps -eo pid PID"で確認できること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"に以下の行が表示されること
    |xxxxxxxxxxxx|event01|xxxxxxxxxxxx|tengine_console|2011/09/01 12:00:00|info     |FALSE     |tengine_console|       |

    もし Tengineコアプロセスのイベント処理ログ:"event_process.log"を表示する
    ならば "event_process.log"に"handler01"と表示されていること

    もし "Tengineコアプロセス"を Ctl+c で停止する
    ならば "Tengineコアプロセス"が停止していることを"ps -eo pid PID"で確認できること

    もし "Tengineコンソールプロセス"を Ctl+c で停止する
    ならば "Tengineコンソールプロセス"が停止していることを"ps -eo pid PID"で確認できること


  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面でイベントを通知確認済みに変更できない_Tengineコンソールが起動していない
  シナリオ: [異常系]アプリケーション開発者がTengineコアのイベントハンドラ定義を作成・実行する_イベント通知画面でイベントを通知確認済みに変更できない_DBが起動していない
