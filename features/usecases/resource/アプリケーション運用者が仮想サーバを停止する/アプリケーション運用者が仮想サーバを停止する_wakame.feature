#language:ja
機能: アプリケーション運用屋が仮想サーバを停止する
  分散ジョブの実行後に物理サーバのリソースを確保するために
  アプリケーション運用者
  は仮想サーバを停止したい

  # @manual
  # 背景に関しては@manualタグを付けることができないのでコメントアウトしています
  背景:
    # 前提 日本語でアクセスする
    # かつ Wakameがセットアップされている
    # かつ TengineにWakameの接続先の設定を以下のファイルに対して行なっている
    #  > vi features/usecases/resource/scripts/create_providor_wakame_real.rb
    # かつ TengineリソースでTamaのテストモードを使用するため、Tengine::Resource::Provider#connection_settingsに設定する
    #  > rails runner features/usecases/resource/scripts/create_providor_wakame_real.rb
    # かつ 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプのデータを全削除する
    #  > rails runner features/usecases/resource/scripts/delete_all_resources.rb
    # かつ "Tengineリソースウォッチャ"プロセスが起動している
    #  > tengine_resource_watchd

  @manual
  シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面から仮想サーバの停止を行う
    # 起動可能数の確認
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"is-demospec"を選択する
    ならば "起動可能数"の表示を確認する
    # 起動している仮想サーバの確認
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面にいくつかのステータスrunningの仮想サーバが表示されている
    # 仮想サーバの停止を行う
    もし 一列目の仮想サーバのチェックボックスをオンにする
    かつ "選択したサーバを停止"ボタンをクリックする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面にチェックボックスをオンにした仮想サーバのステータスが"shutdown in progress"で表示されている

    # 発火イベントの確認
    もし"60"秒間待機する
    もし"イベント一覧"画面を表示する
    ならば"種別名"に"Tengine::Resource::VirtualServerImage.updated.tengine_resource_watchd"のイベントが一件表示されていること
    もし"仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面にチェックボックスをオンにした仮想サーバのステータスが"terminated"で表示されている

    # 発火イベントの確認
    もし"15"分間待機する
    もし"イベント一覧"画面を表示する
    ならば "種別名"に"Tengine::Resource::VirtualServerImage.destroyed.tengine_resource_watchd"のイベントが一件表示されていること
    もし"仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面にチェックボックスをオンにした仮想サーバが表示されていないこと

    # 起動可能数の確認
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"is-demospec"を選択する
    # CPU (100 - 8) / 5 = 18
    ならば 仮想サーバの停止前に確認した"起動可能数"に +1 で表示されること
    もし "キャンセル"ボタンをクリックする
    ならば "仮想サーバ一覧"画面が表示されていること
