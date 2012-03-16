#language:ja
機能: アプリケーション運用者が物理サーバの状態を取得する
  仮想サーバを起動するために
  アプリケーション運用者
  は仮想サーバイメージの状態を取得したい

  # @manual
  # 背景に関しては@manualタグを付けることができないのでコメントアウトしています
  背景:
    # 前提 日本語でアクセスする
    # かつ Wakameがセットアップされている
    # かつ TengineにWakameの接続先の設定を以下のファイルに対して行なっている
    #  > vi features/usecases/resource/scripts/create_providor_wakame_real.rb
    #  12行目あたりのconnection_settings変数を実際の環境に合わせて修正する
    #  connection_settings = {
    #    :account => 'a-zzzzzzxx',
    #    :ec2_host => '127.0.0.1',
    #    :ec2_port => '9005',
    #    :ec2_protocol => 'http',
    #    :wakame_host => '127.0.0.1',
    #    :wakame_port => '9001',
    #    :wakame_protocol => 'http'
    #  }
    # かつ TengineリソースでTamaのテストモードを使用するため、Tengine::Resource::Provider#connection_settingsに設定する
    #  > rails runner features/usecases/resource/scripts/create_providor_wakame_real.rb -e production
    # かつ 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプのデータを全削除する
    #  > rails runner features/usecases/resource/scripts/delete_all_resources.rb -e production
    # かつ "Tengineリソースウォッチャ"プロセスが起動している
    #  > tengine_resource_watchd
    # かつ "Tengineコア"プロセスを起動している(ジョブの実行は行わないので読み込むDSLはエラーにならなければどれでもよい)
    #  > tengined -f config/tengined.yml.erb -T usecases/job/dsl/1001_one_job_in_jobnet.rb

    #
    # 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプはテストを行うWakameの環境に応じて読み替えてください
    #

  @manual
  @7104
  シナリオ: [正常系]アプリケーション運用者は仮想サーバイメージ一覧画面を開き、仮想サーバイメージが表示されていることを確認する
    もし "仮想サーバイメージ一覧"画面を表示する
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_uuid_01|virtual_server_image_uuid_01|virtual_server_image_description_01||

    もし"イベント一覧"画面を表示する
    ならば "種別名"に"Tengine::Resource::VirtualServerImage.created.tengine_resource_watchd"のイベントが<仮想サーバイメージの件数>件表示されていること

    # 仮想サーバイメージの説明を編集する
    # Wakameサーバに対してリクエストは送信しないので借り物の環境でも実行して大丈夫です
    もし "仮想サーバイメージ一覧"画面を表示する
    もし "仮想サーバイメージ名"が"virtual_server_image_uuid_01"列の"編集"リンクをクリックする
    ならば "仮想サーバイメージ編集"画面が表示されていること
    かつ "仮想サーバイメージ編集"画面に"virtual_server_image_uuid_01"と表示されていること

    もし "仮想サーバ名"に"virtual_server_image_name_01"と入力する
    かつ "説明"に"仮想サーバイメージ説明01"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_name_01|virtual_server_image_uuid_01|virtual_server_image_description_01|仮想サーバイメージ説明01|
