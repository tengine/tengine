#language:ja
機能: アプリケーション運用者が問題のあるイベントドライバを無効化する
  問題のあるイベントドライバを無効化するために
  アプリケーション運用者
  は問題が発生した際に通知を受けたい

  背景:
    前提 日本語でアクセスする
    かつ exception_raiser_dsl.rbがイベントハンドラ定義ストアstore1に登録されている
    かつ 以下のTengineコアプロセスが起動している
      |サーバ名|プロセス名|イベントハンドラ定義ストア|
      |tengine1|core_11111|store1|

  シナリオ: 例外を投げるイベントを実行した場合に"イベント通知画面"に更新される
    前提 以下のイベントsが登録されている
      |発生時刻            |通知レベル|通知確認済み|発生源                         |種別名                            |キー|送信者名|
      |2011/08/19 21:00:00|error      |true        |tengine1.core_11111.driver1.foo|tengine.handler.uncaught_exception|    |tengine1.core_11111.driver1.foo|
    もし 現在時刻が2011/08/19 21:00:00である
    かつ 以下のイベントが発火される
      |発生時刻            |通知レベル|通知確認済み|発生源                         |種別名                            |キー|送信者名|
      |2011/08/19 21:59:59|info       |false       |test                           |foo                               |    |test                           |
    かつ driver1のイベントハンドラfooがtengine1/core_11111で実行される
    # イベント通知画面は自動でリロードされます。
    かつ "イベント通知画面"を表示している
    ならば 以下のイベントsの一覧が表示されること
      |発生時刻            |通知レベル|通知確認済み|発生源                         |種別名                            |キー|送信者名|
      |2011/08/19 22:00:00|error      |false       |tengine1.core_11111.driver1.foo|tengine.handler.uncaught_exception|    |tengine1.core_11111.driver1.foo|
      |2011/08/19 21:59:59|info       |true        |test                           |foo                               |    |test                           |
      |2011/08/19 21:00:00|error      |true        |tengine1.core_11111.driver1.foo|tengine.handler.uncaught_exception|    |tengine1.core_11111.driver1.foo|
    # 画面をリロードしたときに「通知確認済み」がfalseのイベントがある場合は、アラームの音声を流し続け、警告のダイアログで確認を促します。
    # ステップ定義の定義の方法は以下のページを参照
    # http://stackoverflow.com/questions/2458632/how-to-test-a-confirm-dialog-with-cucumber
    かつ "errorのイベントを受信しました。アラームを止めますか？"という確認ダイアログが表示される
    もし 確認ダイアログの"OK"をクリックする
    #   page.driver.browser.switch_to.alert.accepted
    #   page.driver.browser.switch_to.alert.dismiss
    ならば 以下のイベントsの一覧が表示されること
      |発生時刻            |通知レベル|通知確認済み|発生源                         |種別名                            |キー|送信者名|
      |2011/08/19 22:00:00|error      |true        |tengine1.core_11111.driver1.foo|tengine.handler.uncaught_exception|    |tengine1.core_11111.driver1.foo|
      |2011/08/19 21:59:59|info       |true        |test                           |foo                               |    |test                           |
      |2011/08/19 21:00:00|error      |true        |tengine1.core_11111.driver1.foo|tengine.handler.uncaught_exception|    |tengine1.core_11111.driver1.foo|

  シナリオ: 通知を受けたイベントの発生源あるいは送信者からイベントドライバを検索して無効化する
    前提 以下のイベントドライバsが登録されている
      |名称     |バージョン|有効 |
      |driver1  |3         |true |
      |driver1  |2         |false|
      |driver1  |1         |false|
    もし "イベントドライバ一覧画面"を表示している
    かつ "名称"に"driver1"と入力する
    かつ "有効のみ"をチェックする
    かつ "検索する"ボタンをクリックする
    ならば 以下のドライバsの一覧が表示されること
      |名称     |バージョン|有効 |
      |driver1  |3         |true |
    もし "イベントドライバ一覧画面"で1番目のドライバを無効化する
    ならば 以下のドライバsの一覧が表示されること
      |名称     |バージョン|有効 |
    もし "名称"に"driver1"と入力する
    かつ "無効のみ"をチェックする
    かつ "検索する"ボタンをクリックする
    ならば 以下のドライバsの一覧が表示されること
      |名称     |バージョン|有効 |
      |driver1  |3         |false|
      |driver1  |2         |false|
      |driver1  |1         |false|

  シナリオ: 対象となるイベントドライバを検索してみたら既に無効化されていて見つからない
    前提 以下のイベントドライバsが登録されている
      |名称     |バージョン|有効 |
      |driver1  |3         |true |
      |driver1  |2         |false|
      |driver1  |1         |false|
    もし "イベントドライバ一覧画面"を表示している
    かつ "名称"に"driver1"と入力する
    かつ "有効のみ"をチェックする
    かつ "検索する"ボタンをクリックする
    ならば 以下のドライバsの一覧が表示されること
      |名称     |バージョン|有効 |
    もし "名称"に"driver1"と入力する
    かつ "無効のみ"をチェックする
    かつ "検索する"ボタンをクリックする
    ならば 以下のドライバsの一覧が表示されること
      |名称     |バージョン|有効 |
      |driver1  |3         |false|
      |driver1  |2         |false|
      |driver1  |1         |false|

  シナリオ: 無効化をする直前に、他の人が無効化していた場合
    前提 以下のイベントドライバsが登録されている
      |名称     |バージョン|有効 |
      |driver1  |3         |true |
      |driver1  |2         |false|
      |driver1  |1         |false|
    もし "イベントドライバ一覧画面"を表示している
    かつ "名称"に"driver1"と入力する
    かつ "有効のみ"をチェックする
    かつ "検索する"ボタンをクリックする
    ならば 以下のドライバsの一覧が表示されること
      |名称     |バージョン|有効 |
      |driver1  |3         |true |
    もし 以下の条件に当てはまるドライバを無効化する
      |名称     |バージョン|
      |driver1  |3         |
    かつ "イベントドライバ一覧画面"で1番目のドライバを無効化する
    ならば 「既に無効となっているイベントドライバを無効化しようとしました。」というメッセージが表示されること
    もし "名称"に"driver1"と入力する
    かつ "無効のみ"をチェックする
    かつ "検索する"ボタンをクリックする
    ならば 以下のドライバsの一覧が表示されること
      |名称     |バージョン|有効 |
      |driver1  |3         |false|
      |driver1  |2         |false|
      |driver1  |1         |false|
