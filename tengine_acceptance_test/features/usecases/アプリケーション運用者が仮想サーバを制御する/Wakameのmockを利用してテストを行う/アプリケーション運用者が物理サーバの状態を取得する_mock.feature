#language:ja
機能: アプリケーション運用者が物理サーバの状態を取得する
  仮想サーバを起動するために
  アプリケーション運用者
  は物理サーバの状態を取得したい

  # @manual
  # 背景に関しては@manualタグを付けることができないのでコメントアウトしています
  背景:
    # 前提 日本語でアクセスする
    # かつ サーバ仮想基盤がセットアップされている
    # かつ Tengineにサーバ仮想基盤の接続先の設定を行なっている
    # かつ TengineリソースでTamaのテストモードを使用するため、Tengine::Resource::Provider#connection_settingsに設定する
    #  > rails runner features/script/create_providor_wakame_test.rb features/test_files -e production
    # かつ 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプのデータを全削除する
    #  > rails runner features/script/delete_all_resources.rb -e production
    # かつ "Tengineリソースウォッチャ"プロセスが起動している
    #  > tengine_resource_watchd
    # かつ "Tengineコア"プロセスを起動している(ジョブの実行は行わないので読み込むDSLはエラーにならなければどれでもよい)
    #  > tengined -f config/tengined.yml.erb -T usecases/job/dsl/1001_one_job_in_jobnet.rb

  @manual
  @07_02_08
  シナリオ: [正常系]アプリケーション運用者は物理サーバ一覧画面を開き、物理サーバが表示されていることを確認する
    # 代替コースB: 管理下の物理サーバが存在しない
    # 物理サーバが0件のファイル
    もし Wakameのモックファイル"./features/test_files/00_describe_host_nodes_0_physical_servers.json"を"./features/test_files/describe_host_nodes.json"にコピーする
    もし "物理サーバ一覧"画面を表示する
    ならば "物理サーバ一覧"画面に以下の行が表示されていること
    # tableには何も表示されない
    |物理サーバ名|プロバイダによるID|説明|CPUコア数|メモリサイズ|ステータス|

    # Wakameに物理サーバの登録を行う
    # 物理サーバが10件のファイル
    もし Wakameのモックファイル"./features/test_files/01_describe_host_nodes_10_physical_servers.json"を"./features/test_files/describe_host_nodes.json"にコピーする
    もし "物理サーバ一覧"画面を表示する
    ならば "物理サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|プロバイダによるID|説明|CPUコア数|メモリサイズ|ステータス|
    |physical_server_name_01|physical_server_uuid_01||100 |100000|online|
    |physical_server_name_02|physical_server_uuid_02||200 |200000|online|
    |physical_server_name_03|physical_server_uuid_03||300 |300000|online|
    |physical_server_name_04|physical_server_uuid_04||400 |400000|online|
    |physical_server_name_05|physical_server_uuid_05||500 |500000|online|
    |physical_server_name_06|physical_server_uuid_06||600 |600000|online|
    |physical_server_name_07|physical_server_uuid_07||700 |700000|online|
    |physical_server_name_08|physical_server_uuid_08||800 |800000|online|
    |physical_server_name_09|physical_server_uuid_09||900 |900000|online|
    |physical_server_name_10|physical_server_uuid_10||100 |100000|offline|

    もし"イベント一覧"画面を表示する
    ならば "種別名"に"Tengine::Resource::PhysicalServer.created.tengine_resource_watchd"のイベントが10件表示されていること

    # 物理サーバの説明を編集する
    もし "物理サーバ一覧"画面を表示する
    もし "物理サーバ名"が"physical_server_name_01"列の"編集"リンクをクリックする
    ならば "物理サーバ編集"画面が表示されていること
    かつ "物理サーバ編集"画面に"physical_server_name_01"と表示されていること

    もし "説明"に"物理サーバ説明01"と入力する
    かつ "更新"ボタンをクリックする
    ならば "物理サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|プロバイダによるID|説明|CPUコア数|メモリサイズ|ステータス|
    |physical_server_name_01|physical_server_uuid_01|物理サーバ説明01|100 |100000|online|
    |physical_server_name_02|physical_server_uuid_02||200 |200000|online|
    |physical_server_name_03|physical_server_uuid_03||300 |300000|online|
    |physical_server_name_04|physical_server_uuid_04||400 |400000|online|
    |physical_server_name_05|physical_server_uuid_05||500 |500000|online|
    |physical_server_name_06|physical_server_uuid_06||600 |600000|online|
    |physical_server_name_07|physical_server_uuid_07||700 |700000|online|
    |physical_server_name_08|physical_server_uuid_08||800 |800000|online|
    |physical_server_name_09|physical_server_uuid_09||900 |900000|online|
    |physical_server_name_10|physical_server_uuid_10||100 |100000|offline|

    # 代替コースA: 物理サーバ一覧表を絞り込み検索して表示する
    # 物理サーバ名で検索を行う
    もし "物理サーバ一覧"を表示する
    かつ "物理サーバ名"に"physical_server_name_02"と入力する
    かつ "検索"ボタンをクリックする
    ならば "物理サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|プロバイダによるID|説明|CPUコア数|メモリサイズ|ステータス|
    |physical_server_name_02|physical_server_uuid_02||200 |200000|online|

    # ステータスで検索を行う
    もし "物理サーバ一覧"を表示する
    かつ "ステータス"の"offline"をチェックする
    かつ "検索"ボタンをクリックする
    ならば "物理サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|プロバイダによるID|説明|CPUコア数|メモリサイズ|ステータス|
    |physical_server_name_10|physical_server_uuid_10||100 |100000|offline|

    # 代替コースC: 検索条件にマッチする項目が0台と表示される
    # 物理サーバ名で検索を行う(結果が0件)
    もし "物理サーバ一覧"を表示する
    かつ "物理サーバ名"に"physical_server_name_none"と入力する
    かつ "検索"ボタンをクリックする
    ならば "物理サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|プロバイダによるID|説明|CPUコア数|メモリサイズ|ステータス|

    # 代替コースD: 絞り込み検索をしている状態でページ切り替えを行う
    # 物理サーバが60件のファイル
    もし Wakameのモックファイル"./features/test_files/02_describe_host_nodes_60_physical_servers.json"を"./features/test_files/describe_host_nodes.json"にコピーする
    もし "物理サーバ一覧"画面を表示する
    ならば "物理サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|プロバイダによるID|説明|CPUコア数|メモリサイズ|ステータス|
    |physical_server_name_01|physical_server_uuid_01|物理サーバ説明01|100 |100000|online|
    |physical_server_name_02|physical_server_uuid_02||200 |200000|online|
    |physical_server_name_03|physical_server_uuid_03||300 |300000|online|
    |physical_server_name_04|physical_server_uuid_04||400 |400000|online|
    |physical_server_name_05|physical_server_uuid_05||500 |500000|online|
    |physical_server_name_06|physical_server_uuid_06||600 |600000|online|
    |physical_server_name_07|physical_server_uuid_07||700 |700000|online|
    |physical_server_name_08|physical_server_uuid_08||800 |800000|online|
    |physical_server_name_09|physical_server_uuid_09||900 |900000|online|
    |physical_server_name_10|physical_server_uuid_10||100 |100000|offline|
    |physical_server_name_11|physical_server_uuid_11||100 |100000|online|
    |physical_server_name_12|physical_server_uuid_12||200 |200000|online|
    |physical_server_name_13|physical_server_uuid_13||300 |300000|online|
    |physical_server_name_14|physical_server_uuid_14||400 |400000|online|
    |physical_server_name_15|physical_server_uuid_15||500 |500000|online|
    |physical_server_name_16|physical_server_uuid_16||600 |600000|online|
    |physical_server_name_17|physical_server_uuid_17||700 |700000|online|
    |physical_server_name_18|physical_server_uuid_18||800 |800000|online|
    |physical_server_name_19|physical_server_uuid_19||900 |900000|online|
    |physical_server_name_20|physical_server_uuid_20||100 |100000|offline|
    |physical_server_name_21|physical_server_uuid_21||100 |100000|online|
    |physical_server_name_22|physical_server_uuid_22||200 |200000|online|
    |physical_server_name_23|physical_server_uuid_23||300 |300000|online|
    |physical_server_name_24|physical_server_uuid_24||400 |400000|online|
    |physical_server_name_25|physical_server_uuid_25||500 |500000|online|
    |physical_server_name_26|physical_server_uuid_26||600 |600000|online|
    |physical_server_name_27|physical_server_uuid_27||700 |700000|online|
    |physical_server_name_28|physical_server_uuid_28||800 |800000|online|
    |physical_server_name_29|physical_server_uuid_29||900 |900000|online|
    |physical_server_name_30|physical_server_uuid_30||100 |100000|offline|
    |physical_server_name_31|physical_server_uuid_31||100 |100000|online|
    |physical_server_name_32|physical_server_uuid_32||200 |200000|online|
    |physical_server_name_33|physical_server_uuid_33||300 |300000|online|
    |physical_server_name_34|physical_server_uuid_34||400 |400000|online|
    |physical_server_name_35|physical_server_uuid_35||500 |500000|online|
    |physical_server_name_36|physical_server_uuid_36||600 |600000|online|
    |physical_server_name_37|physical_server_uuid_37||700 |700000|online|
    |physical_server_name_38|physical_server_uuid_38||800 |800000|online|
    |physical_server_name_39|physical_server_uuid_39||900 |900000|online|
    |physical_server_name_40|physical_server_uuid_40||100 |100000|offline|
    |physical_server_name_41|physical_server_uuid_41||100 |100000|online|
    |physical_server_name_42|physical_server_uuid_42||200 |200000|online|
    |physical_server_name_43|physical_server_uuid_43||300 |300000|online|
    |physical_server_name_44|physical_server_uuid_44||400 |400000|online|
    |physical_server_name_45|physical_server_uuid_45||500 |500000|online|
    |physical_server_name_46|physical_server_uuid_46||600 |600000|online|
    |physical_server_name_47|physical_server_uuid_47||700 |700000|online|
    |physical_server_name_48|physical_server_uuid_48||800 |800000|online|
    |physical_server_name_49|physical_server_uuid_49||900 |900000|online|
    |physical_server_name_50|physical_server_uuid_50||100 |100000|offline|

    # ステータスで検索を行う
    もし "物理サーバ一覧"を表示する
    かつ "ステータス"に"online"をチェックする
    かつ "検索"ボタンをクリックする
    ならば "物理サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|プロバイダによるID|説明|CPUコア数|メモリサイズ|ステータス|
    |physical_server_name_01|physical_server_uuid_01|物理サーバ説明01|100 |100000|online|
    |physical_server_name_02|physical_server_uuid_02||200 |200000|online|
    |physical_server_name_03|physical_server_uuid_03||300 |300000|online|
    |physical_server_name_04|physical_server_uuid_04||400 |400000|online|
    |physical_server_name_05|physical_server_uuid_05||500 |500000|online|
    |physical_server_name_06|physical_server_uuid_06||600 |600000|online|
    |physical_server_name_07|physical_server_uuid_07||700 |700000|online|
    |physical_server_name_08|physical_server_uuid_08||800 |800000|online|
    |physical_server_name_09|physical_server_uuid_09||900 |900000|online|
    |physical_server_name_11|physical_server_uuid_11||100 |100000|online|
    |physical_server_name_12|physical_server_uuid_12||200 |200000|online|
    |physical_server_name_13|physical_server_uuid_13||300 |300000|online|
    |physical_server_name_14|physical_server_uuid_14||400 |400000|online|
    |physical_server_name_15|physical_server_uuid_15||500 |500000|online|
    |physical_server_name_16|physical_server_uuid_16||600 |600000|online|
    |physical_server_name_17|physical_server_uuid_17||700 |700000|online|
    |physical_server_name_18|physical_server_uuid_18||800 |800000|online|
    |physical_server_name_19|physical_server_uuid_19||900 |900000|online|
    |physical_server_name_21|physical_server_uuid_21||100 |100000|online|
    |physical_server_name_22|physical_server_uuid_22||200 |200000|online|
    |physical_server_name_23|physical_server_uuid_23||300 |300000|online|
    |physical_server_name_24|physical_server_uuid_24||400 |400000|online|
    |physical_server_name_25|physical_server_uuid_25||500 |500000|online|
    |physical_server_name_26|physical_server_uuid_26||600 |600000|online|
    |physical_server_name_27|physical_server_uuid_27||700 |700000|online|
    |physical_server_name_28|physical_server_uuid_28||800 |800000|online|
    |physical_server_name_29|physical_server_uuid_29||900 |900000|online|
    |physical_server_name_31|physical_server_uuid_31||100 |100000|online|
    |physical_server_name_32|physical_server_uuid_32||200 |200000|online|
    |physical_server_name_33|physical_server_uuid_33||300 |300000|online|
    |physical_server_name_34|physical_server_uuid_34||400 |400000|online|
    |physical_server_name_35|physical_server_uuid_35||500 |500000|online|
    |physical_server_name_36|physical_server_uuid_36||600 |600000|online|
    |physical_server_name_37|physical_server_uuid_37||700 |700000|online|
    |physical_server_name_38|physical_server_uuid_38||800 |800000|online|
    |physical_server_name_39|physical_server_uuid_39||900 |900000|online|
    |physical_server_name_41|physical_server_uuid_41||100 |100000|online|
    |physical_server_name_42|physical_server_uuid_42||200 |200000|online|
    |physical_server_name_43|physical_server_uuid_43||300 |300000|online|
    |physical_server_name_44|physical_server_uuid_44||400 |400000|online|
    |physical_server_name_45|physical_server_uuid_45||500 |500000|online|
    |physical_server_name_46|physical_server_uuid_46||600 |600000|online|
    |physical_server_name_47|physical_server_uuid_47||700 |700000|online|
    |physical_server_name_48|physical_server_uuid_48||800 |800000|online|
    |physical_server_name_49|physical_server_uuid_49||900 |900000|online|
    |physical_server_name_51|physical_server_uuid_51||100 |100000|online|
    |physical_server_name_52|physical_server_uuid_52||200 |200000|online|
    |physical_server_name_53|physical_server_uuid_53||300 |300000|online|
    |physical_server_name_54|physical_server_uuid_54||400 |400000|online|
    |physical_server_name_55|physical_server_uuid_55||500 |500000|online|

    もし "次へ"ボタンをクリックする
    ならば "物理サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|プロバイダによるID|説明|CPUコア数|メモリサイズ|ステータス|
    |physical_server_name_56|physical_server_uuid_56||600 |600000|online|
    |physical_server_name_57|physical_server_uuid_57||700 |700000|online|
    |physical_server_name_58|physical_server_uuid_58||800 |800000|online|
    |physical_server_name_59|physical_server_uuid_59||900 |900000|online|
