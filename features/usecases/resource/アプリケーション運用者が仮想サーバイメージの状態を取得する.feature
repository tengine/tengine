#language:ja
機能: アプリケーション運用屋が物理サーバの状態を取得する
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
    #  > rails runner features/usecases/resource/scripts/create_providor_wakame_test.rb <テストファイル群の配置ディレクトリ>
    # かつ 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプのデータを全削除する
    #  > rails runner features/usecases/resource/scripts/delete_all_resources.rb
    # かつ "Tengineリソースウォッチャ"プロセスが起動している
    #  > tengine_resource_watchd

  @manual
  シナリオ: [正常系]アプリケーション運用者は仮想サーバイメージ一覧画面を開き、仮想サーバイメージが表示されていることを確認する
    # 代替コースB: 管理下の仮想サーバイメージが存在しない
    # 仮想サーバイメージが0件のファイル
    もし Wakameのモックファイル"./features/usecases/resource/test_files/20_describe_images_0_virtual_server_images.json"を"./features/usecases/resource/test_files/describe_images.json"にコピーする
    もし "仮想サーバイメージ一覧"画面を表示する
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    # tableには何も表示されない
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|

    # Wakameに物理サーバの登録を行う
    # 仮想サーバイメージが5件のファイル
    もし Wakameのモックファイル"./features/usecases/resource/test_files/21_describe_images_5_virtual_server_images.json"を"./features/usecases/resource/test_files/describe_images.json"にコピーする
    もし "仮想サーバイメージ一覧"画面を表示する
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_id_01|virtual_server_image_id_01|virtual_server_image_description_01||
    |virtual_server_image_id_02|virtual_server_image_id_02|virtual_server_image_description_02||
    |virtual_server_image_id_03|virtual_server_image_id_03|virtual_server_image_description_03||
    |virtual_server_image_id_04|virtual_server_image_id_04|virtual_server_image_description_04||
    |virtual_server_image_id_05|virtual_server_image_id_05|virtual_server_image_description_05||

    # 仮想サーバイメージの説明を編集する
    もし "仮想サーバイメージ名"が"virtual_server_image_id_01"列の"編集"リンクをクリックする
    ならば "仮想サーバイメージ編集"画面が表示されていること
    かつ "仮想サーバイメージ編集"画面に"virtual_server_image_id_01"と表示されていること

    もし "仮想サーバ名"に"virtual_server_image_name_01"と入力する
    かつ "説明"に"仮想サーバイメージ説明01"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_name_01|virtual_server_image_id_01|virtual_server_image_description_01|仮想サーバイメージ説明01|
    |virtual_server_image_id_02|virtual_server_image_id_02|virtual_server_image_description_02||
    |virtual_server_image_id_03|virtual_server_image_id_03|virtual_server_image_description_03||
    |virtual_server_image_id_04|virtual_server_image_id_04|virtual_server_image_description_04||
    |virtual_server_image_id_05|virtual_server_image_id_05|virtual_server_image_description_05||

    # 代替コースA: 仮想サーバイメージ一覧表を絞り込み検索して表示する
    # 仮想サーバイメージ名で検索を行う
    もし "仮想サーバイメージ一覧"を表示する
    かつ "仮想サーバイメージ名"に"virtual_server_image_name_01"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_name_01|virtual_server_image_id_01|virtual_server_image_description_01|仮想サーバイメージ説明01|

    # 代替コースC: 検索条件にマッチする項目が0台と表示される
    # 仮想サーバイメージ名で検索を行う(結果が0件)
    もし "仮想サーバイメージ一覧"を表示する
    かつ "仮想サーバイメージ名"に"virtual_server_image_name_none"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|

    # 代替コースD: 絞り込み検索をしている状態でページ切り替えを行う
    # 仮想サーバイメージが60件のファイル
    もし Wakameのモックファイル"./features/usecases/resource/test_files/22_describe_images_60_virtual_server_images.json"を"./features/usecases/resource/test_files/describe_images.json"にコピーする
    もし "仮想サーバイメージ一覧"画面を表示する
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_name_01|virtual_server_image_id_01|virtual_server_image_description_01|仮想サーバイメージ説明01|
    |virtual_server_image_id_02|virtual_server_image_id_02|virtual_server_image_description_02||
    |virtual_server_image_id_03|virtual_server_image_id_03|virtual_server_image_description_03||
    |virtual_server_image_id_04|virtual_server_image_id_04|virtual_server_image_description_04||
    |virtual_server_image_id_05|virtual_server_image_id_05|virtual_server_image_description_05||
    |virtual_server_image_id_06|virtual_server_image_id_06|virtual_server_image_description_06||
    |virtual_server_image_id_07|virtual_server_image_id_07|virtual_server_image_description_07||
    |virtual_server_image_id_08|virtual_server_image_id_08|virtual_server_image_description_08||
    |virtual_server_image_id_09|virtual_server_image_id_09|virtual_server_image_description_09||
    |virtual_server_image_id_10|virtual_server_image_id_10|virtual_server_image_description_10||
    |virtual_server_image_id_11|virtual_server_image_id_11|virtual_server_image_description_11||
    |virtual_server_image_id_12|virtual_server_image_id_12|virtual_server_image_description_12||
    |virtual_server_image_id_13|virtual_server_image_id_13|virtual_server_image_description_13||
    |virtual_server_image_id_14|virtual_server_image_id_14|virtual_server_image_description_14||
    |virtual_server_image_id_15|virtual_server_image_id_15|virtual_server_image_description_15||
    |virtual_server_image_id_16|virtual_server_image_id_16|virtual_server_image_description_16||
    |virtual_server_image_id_17|virtual_server_image_id_17|virtual_server_image_description_17||
    |virtual_server_image_id_18|virtual_server_image_id_18|virtual_server_image_description_18||
    |virtual_server_image_id_19|virtual_server_image_id_19|virtual_server_image_description_19||
    |virtual_server_image_id_20|virtual_server_image_id_20|virtual_server_image_description_20||
    |virtual_server_image_id_21|virtual_server_image_id_21|virtual_server_image_description_21||
    |virtual_server_image_id_22|virtual_server_image_id_22|virtual_server_image_description_22||
    |virtual_server_image_id_23|virtual_server_image_id_23|virtual_server_image_description_23||
    |virtual_server_image_id_24|virtual_server_image_id_24|virtual_server_image_description_24||
    |virtual_server_image_id_25|virtual_server_image_id_25|virtual_server_image_description_25||
    |virtual_server_image_id_26|virtual_server_image_id_26|virtual_server_image_description_26||
    |virtual_server_image_id_27|virtual_server_image_id_27|virtual_server_image_description_27||
    |virtual_server_image_id_28|virtual_server_image_id_28|virtual_server_image_description_28||
    |virtual_server_image_id_29|virtual_server_image_id_29|virtual_server_image_description_29||
    |virtual_server_image_id_30|virtual_server_image_id_30|virtual_server_image_description_30||
    |virtual_server_image_id_31|virtual_server_image_id_31|virtual_server_image_description_31||
    |virtual_server_image_id_32|virtual_server_image_id_32|virtual_server_image_description_32||
    |virtual_server_image_id_33|virtual_server_image_id_33|virtual_server_image_description_33||
    |virtual_server_image_id_34|virtual_server_image_id_34|virtual_server_image_description_34||
    |virtual_server_image_id_35|virtual_server_image_id_35|virtual_server_image_description_35||
    |virtual_server_image_id_36|virtual_server_image_id_36|virtual_server_image_description_36||
    |virtual_server_image_id_37|virtual_server_image_id_37|virtual_server_image_description_37||
    |virtual_server_image_id_38|virtual_server_image_id_38|virtual_server_image_description_38||
    |virtual_server_image_id_39|virtual_server_image_id_39|virtual_server_image_description_39||
    |virtual_server_image_id_40|virtual_server_image_id_40|virtual_server_image_description_40||
    |virtual_server_image_id_41|virtual_server_image_id_41|virtual_server_image_description_41||
    |virtual_server_image_id_42|virtual_server_image_id_42|virtual_server_image_description_42||
    |virtual_server_image_id_43|virtual_server_image_id_43|virtual_server_image_description_43||
    |virtual_server_image_id_44|virtual_server_image_id_44|virtual_server_image_description_44||
    |virtual_server_image_id_45|virtual_server_image_id_45|virtual_server_image_description_45||
    |virtual_server_image_id_46|virtual_server_image_id_46|virtual_server_image_description_46||
    |virtual_server_image_id_47|virtual_server_image_id_47|virtual_server_image_description_47||
    |virtual_server_image_id_48|virtual_server_image_id_48|virtual_server_image_description_48||
    |virtual_server_image_id_49|virtual_server_image_id_49|virtual_server_image_description_49||
    |virtual_server_image_id_50|virtual_server_image_id_50|virtual_server_image_description_50||

    もし "次へ"ボタンをクリックする
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_id_51|virtual_server_image_id_51|virtual_server_image_description_51||
    |virtual_server_image_id_52|virtual_server_image_id_52|virtual_server_image_description_52||
    |virtual_server_image_id_53|virtual_server_image_id_53|virtual_server_image_description_53||
    |virtual_server_image_id_54|virtual_server_image_id_54|virtual_server_image_description_54||
    |virtual_server_image_id_55|virtual_server_image_id_55|virtual_server_image_description_55||
    |virtual_server_image_id_56|virtual_server_image_id_56|virtual_server_image_description_56||
    |virtual_server_image_id_57|virtual_server_image_id_57|virtual_server_image_description_57||
    |virtual_server_image_id_58|virtual_server_image_id_58|virtual_server_image_description_58||
    |virtual_server_image_id_59|virtual_server_image_id_59|virtual_server_image_description_59||
    |virtual_server_image_id_60|virtual_server_image_id_60|virtual_server_image_description_60||
