#language:ja
機能: Tengineコアを起動したまま起動時にロードしたドライバを変更すると、変更が反映される
  アプリケーションを効率良く開発するために
  アプリケーション開発者
  はTengineコアをドライバを変更する度に再起動する事なくドライバの変更を反映したい。

  背景:
    前提 日本語でアクセスする
    かつ tenginedハートビートの発火間隔が5と設定されている
    かつ "Tengineコアプロセス"が停止している
    かつ "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している

  @manual
  シナリオ: 起動時にロードしたドライバの中のハンドラー内の処理を変更して、反映されることを確認す
    前提 日本語でアクセスする
    かつ "~/change_loaded_handler.log"が存在しないこと

    もし テストを行う為に、"\cp -rf tengine_console/usecases/core/dsls/uc100_change_loaded_handler_origin.rb tengine_console/usecases/core/dsls/uc100_change_loaded_handler.rb"コマンドを実行する
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/core/dsl/uc100_change_loaded_handler.rb --tengined-cache-drivers "というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力からPIDを確認する
    かつ "Tengineコアプロセス"が起動していることをPIDを用いて"ps -eo pid PID"というコマンドで確認できること

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること
    もし "種別名"に"event100"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event100を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |通知レベル|通知確認済み|
    |event100|info     |true     |
    かつ "~/change_loaded_handler.log"に以下の内容が出力されていること
    origine

    もし テストを行う為に、"\cp -rf tengine_console/usecases/core/dsls/uc100_change_loaded_handler_replace.rb tengine_console/usecases/core/dsls/uc100_change_loaded_handler.rb"コマンドを実行する

    もし "イベントドライバ一覧画面"を表示する
    ならば "イベントドライバ一覧画面"を表示していること
    かつ 以下の行が表示されること
    |名称    |
    |driver01|

    もし "イベント発火画面"を表示する
    ならば "イベント発火画面"を表示していること
    もし "種別名"に"event100"と入力する
    かつ "発生源名"に"tengine_console"と入力する
    かつ "info"を選択する
    かつ "送信者名"に"tengine_console"と入力する
    かつ "登録する"ボタンをクリックする
    ならば "event100を発火しました"と表示されていること

    もし "イベント通知画面"を表示する
    ならば "イベント通知画面"を表示していること
    ならば 以下の行が表示されること
    |種別名  |通知レベル|通知確認済み|
    |event100|info     |true     |
    かつ "~/change_loaded_handler.log"に以下の内容が出力されていること
    origine
    replace
  

    




