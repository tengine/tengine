#language:ja
機能: アプリケーション運用者が物理サーバの状態を取得する
  仮想サーバを起動するために
  アプリケーション運用者
  は仮想サーバイメージの状態を取得したい

  # @manual
  # 背景に関しては@manualタグを付けることができないのでコメントアウトしています
  背景:
    # 前提 日本語でアクセスする
    # かつ サーバ仮想基盤がセットアップされている
    # かつ Tengineにサーバ仮想基盤の接続先の設定を行なっている
    # かつ TengineリソースでTamaのテストモードを使用するため、Tengine::Resource::Provider#connection_settingsに設定する
    #  > rails runner features/usecases/アプリケーション運用者が仮想サーバを制御する/scripts/create_providor_wakame_test.rb features/usecases/アプリケーション運用者が仮想サーバを制御する/scripts/test_files -e production
    # かつ 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプのデータを全削除する
    #  > rails runner features/usecases/アプリケーション運用者が仮想サーバを制御する/scripts/delete_all_resources.rb -e production
    # かつ "Tengineリソースウォッチャ"プロセスが起動している
    #  > tengine_resource_watchd
    # かつ "Tengineコア"プロセスを起動している(ジョブの実行は行わないので読み込むDSLはエラーにならなければどれでもよい)
    #  > tengined -f config/tengined.yml.erb -T usecases/job/dsl/1001_one_job_in_jobnet.rb

  @manual
  @07_02_07
  シナリオ: [正常系]アプリケーション運用者は仮想サーバイメージ一覧画面を開き、仮想サーバイメージが表示されていることを確認する
    # 代替コースB: 管理下の仮想サーバイメージが存在しない
    # 仮想サーバイメージが0件のファイル
    もし Wakameのモックファイル"./features/usecases/アプリケーション運用者が仮想サーバを制御する/test_files/20_describe_images_0_virtual_server_images.json"を"./features/usecases/アプリケーション運用者が仮想サーバを制御する/test_files/describe_images.json"にコピーする
    かつ "Tengineリソースウォッチャ"プロセスを再起動する
    もし "仮想サーバイメージ一覧"画面を表示する
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    # tableには何も表示されない
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|

    # Wakameに物理サーバの登録を行う
    # 仮想サーバイメージが5件のファイル
    もし Wakameのモックファイル"./features/usecases/アプリケーション運用者が仮想サーバを制御する/test_files/21_describe_images_5_virtual_server_images.json"を"./features/usecases/アプリケーション運用者が仮想サーバを制御する/test_files/describe_images.json"にコピーする
    かつ "Tengineリソースウォッチャ"プロセスを再起動する
    # > tengine_resource_watchd
    もし "仮想サーバイメージ一覧"画面を表示する
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_uuid_01|virtual_server_image_uuid_01|virtual_server_image_description_01||
    |virtual_server_image_uuid_02|virtual_server_image_uuid_02|virtual_server_image_description_02||
    |virtual_server_image_uuid_03|virtual_server_image_uuid_03|virtual_server_image_description_03||
    |virtual_server_image_uuid_04|virtual_server_image_uuid_04|virtual_server_image_description_04||
    |virtual_server_image_uuid_05|virtual_server_image_uuid_05|virtual_server_image_description_05||

    もし"イベント一覧"画面を表示する
    ならば "種別名"に"Tengine::Resource::VirtualServerImage.created.tengine_resource_watchd"のイベントが5件表示されていること

    # 仮想サーバイメージの説明を編集する
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
    |virtual_server_image_uuid_02|virtual_server_image_uuid_02|virtual_server_image_description_02||
    |virtual_server_image_uuid_03|virtual_server_image_uuid_03|virtual_server_image_description_03||
    |virtual_server_image_uuid_04|virtual_server_image_uuid_04|virtual_server_image_description_04||
    |virtual_server_image_uuid_05|virtual_server_image_uuid_05|virtual_server_image_description_05||

    # 仮想サーバイメージ名のバリデーションチェック
    もし "プロバイダによるID"が"virtual_server_image_uuid_02"列の"編集"リンクをクリックする
    ならば "仮想サーバイメージ編集"画面が表示されていること
    かつ "仮想サーバイメージ編集"画面に"virtual_server_uuid_02"と表示されていること

    もし "仮想サーバイメージ名"に"virtual_server_image_name_01"と入力する　# すでに使用している名前を入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバイメージ編集"画面が表示されていること
    かつ "仮想サーバイメージ名 はすでに使用されています"と表示されていること

    # 代替コースA: 仮想サーバイメージ一覧表を絞り込み検索して表示する
    # 仮想サーバイメージ名で検索を行う
    もし "仮想サーバイメージ一覧"を表示する
    かつ "仮想サーバイメージ名"に"virtual_server_image_name_01"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_name_01|virtual_server_image_uuid_01|virtual_server_image_description_01|仮想サーバイメージ説明01|

    # 代替コースC: 検索条件にマッチする項目が0台と表示される
    # 仮想サーバイメージ名で検索を行う(結果が0件)
    もし "仮想サーバイメージ一覧"を表示する
    かつ "仮想サーバイメージ名"に"virtual_server_image_name_none"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|

    # 代替コースD: 絞り込み検索をしている状態でページ切り替えを行う
    # 仮想サーバイメージが60件のファイル
    もし Wakameのモックファイル"./features/usecases/アプリケーション運用者が仮想サーバを制御する/test_files/22_describe_images_60_virtual_server_images.json"を"./features/usecases/アプリケーション運用者が仮想サーバを制御する/test_files/describe_images.json"にコピーする
    かつ "Tengineリソースウォッチャ"プロセスを再起動する
    # > tengine_resource_watchd
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_name_01|virtual_server_image_uuid_01|virtual_server_image_description_01|仮想サーバイメージ説明01|
    |virtual_server_image_uuid_02|virtual_server_image_uuid_02|virtual_server_image_description_02||
    |virtual_server_image_uuid_03|virtual_server_image_uuid_03|virtual_server_image_description_03||
    |virtual_server_image_uuid_04|virtual_server_image_uuid_04|virtual_server_image_description_04||
    |virtual_server_image_uuid_05|virtual_server_image_uuid_05|virtual_server_image_description_05||
    |virtual_server_image_uuid_06|virtual_server_image_uuid_06|virtual_server_image_description_06||
    |virtual_server_image_uuid_07|virtual_server_image_uuid_07|virtual_server_image_description_07||
    |virtual_server_image_uuid_08|virtual_server_image_uuid_08|virtual_server_image_description_08||
    |virtual_server_image_uuid_09|virtual_server_image_uuid_09|virtual_server_image_description_09||
    |virtual_server_image_uuid_10|virtual_server_image_uuid_10|virtual_server_image_description_10||
    |virtual_server_image_uuid_11|virtual_server_image_uuid_11|virtual_server_image_description_11||
    |virtual_server_image_uuid_12|virtual_server_image_uuid_12|virtual_server_image_description_12||
    |virtual_server_image_uuid_13|virtual_server_image_uuid_13|virtual_server_image_description_13||
    |virtual_server_image_uuid_14|virtual_server_image_uuid_14|virtual_server_image_description_14||
    |virtual_server_image_uuid_15|virtual_server_image_uuid_15|virtual_server_image_description_15||
    |virtual_server_image_uuid_16|virtual_server_image_uuid_16|virtual_server_image_description_16||
    |virtual_server_image_uuid_17|virtual_server_image_uuid_17|virtual_server_image_description_17||
    |virtual_server_image_uuid_18|virtual_server_image_uuid_18|virtual_server_image_description_18||
    |virtual_server_image_uuid_19|virtual_server_image_uuid_19|virtual_server_image_description_19||
    |virtual_server_image_uuid_20|virtual_server_image_uuid_20|virtual_server_image_description_20||
    |virtual_server_image_uuid_21|virtual_server_image_uuid_21|virtual_server_image_description_21||
    |virtual_server_image_uuid_22|virtual_server_image_uuid_22|virtual_server_image_description_22||
    |virtual_server_image_uuid_23|virtual_server_image_uuid_23|virtual_server_image_description_23||
    |virtual_server_image_uuid_24|virtual_server_image_uuid_24|virtual_server_image_description_24||
    |virtual_server_image_uuid_25|virtual_server_image_uuid_25|virtual_server_image_description_25||
    |virtual_server_image_uuid_26|virtual_server_image_uuid_26|virtual_server_image_description_26||
    |virtual_server_image_uuid_27|virtual_server_image_uuid_27|virtual_server_image_description_27||
    |virtual_server_image_uuid_28|virtual_server_image_uuid_28|virtual_server_image_description_28||
    |virtual_server_image_uuid_29|virtual_server_image_uuid_29|virtual_server_image_description_29||
    |virtual_server_image_uuid_30|virtual_server_image_uuid_30|virtual_server_image_description_30||
    |virtual_server_image_uuid_31|virtual_server_image_uuid_31|virtual_server_image_description_31||
    |virtual_server_image_uuid_32|virtual_server_image_uuid_32|virtual_server_image_description_32||
    |virtual_server_image_uuid_33|virtual_server_image_uuid_33|virtual_server_image_description_33||
    |virtual_server_image_uuid_34|virtual_server_image_uuid_34|virtual_server_image_description_34||
    |virtual_server_image_uuid_35|virtual_server_image_uuid_35|virtual_server_image_description_35||
    |virtual_server_image_uuid_36|virtual_server_image_uuid_36|virtual_server_image_description_36||
    |virtual_server_image_uuid_37|virtual_server_image_uuid_37|virtual_server_image_description_37||
    |virtual_server_image_uuid_38|virtual_server_image_uuid_38|virtual_server_image_description_38||
    |virtual_server_image_uuid_39|virtual_server_image_uuid_39|virtual_server_image_description_39||
    |virtual_server_image_uuid_40|virtual_server_image_uuid_40|virtual_server_image_description_40||
    |virtual_server_image_uuid_41|virtual_server_image_uuid_41|virtual_server_image_description_41||
    |virtual_server_image_uuid_42|virtual_server_image_uuid_42|virtual_server_image_description_42||
    |virtual_server_image_uuid_43|virtual_server_image_uuid_43|virtual_server_image_description_43||
    |virtual_server_image_uuid_44|virtual_server_image_uuid_44|virtual_server_image_description_44||
    |virtual_server_image_uuid_45|virtual_server_image_uuid_45|virtual_server_image_description_45||
    |virtual_server_image_uuid_46|virtual_server_image_uuid_46|virtual_server_image_description_46||
    |virtual_server_image_uuid_47|virtual_server_image_uuid_47|virtual_server_image_description_47||
    |virtual_server_image_uuid_48|virtual_server_image_uuid_48|virtual_server_image_description_48||
    |virtual_server_image_uuid_49|virtual_server_image_uuid_49|virtual_server_image_description_49||
    |virtual_server_image_uuid_50|virtual_server_image_uuid_50|virtual_server_image_description_50||

    もし "次へ"ボタンをクリックする
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_uuid_51|virtual_server_image_uuid_51|virtual_server_image_description_51||
    |virtual_server_image_uuid_52|virtual_server_image_uuid_52|virtual_server_image_description_52||
    |virtual_server_image_uuid_53|virtual_server_image_uuid_53|virtual_server_image_description_53||
    |virtual_server_image_uuid_54|virtual_server_image_uuid_54|virtual_server_image_description_54||
    |virtual_server_image_uuid_55|virtual_server_image_uuid_55|virtual_server_image_description_55||
    |virtual_server_image_uuid_56|virtual_server_image_uuid_56|virtual_server_image_description_56||
    |virtual_server_image_uuid_57|virtual_server_image_uuid_57|virtual_server_image_description_57||
    |virtual_server_image_uuid_58|virtual_server_image_uuid_58|virtual_server_image_description_58||
    |virtual_server_image_uuid_59|virtual_server_image_uuid_59|virtual_server_image_description_59||
    |virtual_server_image_uuid_60|virtual_server_image_uuid_60|virtual_server_image_description_60||
