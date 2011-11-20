#language:ja
機能: アプリケーション運用屋が仮想サーバの状態を取得する
  分散ジョブを起動するために
  アプリケーション運用者
  は仮想サーバの状態を取得したい

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
  シナリオ: [正常系]アプリケーション運用者は物理サーバ一覧画面を開き、物理サーバが表示されていることを確認する
　  # 代替コースC: 管理下の物理サーバが存在しない
    # 物理サーバが0件のファイル
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/00_describe_host_nodes_0_physical_servers.json"を"./features/usecases/resouce/test_files/describe_host_nodes.json"にコピーする
    # 仮想サーバが0件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/10_describe_instances_0_virtual_servers.json"を"./features/usecases/resouce/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが0件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/20_describe_images_0_virtual_server_images.json"を"./features/usecases/resouce/test_files/describe_images.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|仮想サーバ名|プロバイダによるID|説明|ステータス|仮想サーバイメージ名|仮想サーバタイプ|

    # 代替コースB：管理下の仮想サーバが存在しない
    # Wakameに仮想サーバの登録を行う
    # 物理サーバが10件のファイル
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/01_describe_host_nodes_10_physical_servers.json"を"./features/usecases/resouce/test_files/describe_host_nodes.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|仮想サーバ名|プロバイダによるID|説明|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01||||||||
    |physical_server_name_02||||||||
    |physical_server_name_03||||||||
    |physical_server_name_04||||||||
    |physical_server_name_05||||||||
    |physical_server_name_06||||||||
    |physical_server_name_07||||||||
    |physical_server_name_08||||||||
    |physical_server_name_09||||||||
    |physical_server_name_10||||||||

    # 基本コース:
    # 仮想サーバが10件のファイル
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/11_describe_instances_10_virtual_servers.json"を"./features/usecases/resouce/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが5件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/21_describe_images_5_virtual_server_images.json"を"./features/usecases/resouce/test_files/describe_images.json"にコピーする
    # 仮想サーバタイプが2件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/31_describe_instance_specs_4_virtual_server_specs.json"を"./features/usecases/resouce/test_files/31_describe_instance_specs.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_id_01|virtual_server_id_01|    |nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_02|virtual_server_id_02|    |nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_03|virtual_server_id_03|    |nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_04|virtual_server_id_04|    |nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_05|virtual_server_id_05|    |nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_name_01|virtual_server_spec_name_01|
    |physical_server_name_02|virtual_server_id_06|virtual_server_id_06|    |nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |virtual_server_id_07|virtual_server_id_07|    |nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |virtual_server_id_08|virtual_server_id_08|    |nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |physical_server_name_03|virtual_server_id_09|virtual_server_id_09|    |nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_10|virtual_server_id_10|    |nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |physical_server_name_04||||||||
    |physical_server_name_05||||||||
    |physical_server_name_06||||||||
    |physical_server_name_07||||||||
    |physical_server_name_08||||||||
    |physical_server_name_09||||||||
    |physical_server_name_10||||||||

    # 仮想サーバの仮想サーバ名、説明を編集する
    もし "プロバイダによるID"が"virtual_server_id_01"列の"編集"リンクをクリックする
    ならば "仮想サーバ編集"画面が表示されていること
    かつ "仮想サーバ編集"画面に"physical_server_id_01"と表示されていること

    もし "仮想サーバ名"に"仮想サーバ名01"と入力する
    かつ "説明"に"仮想サーバ説明01"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|仮想サーバ名01|virtual_server_id_01|仮想サーバ説明01|nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_02|virtual_server_id_02|    |nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_03|virtual_server_id_03|    |nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_04|virtual_server_id_04|    |nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_05|virtual_server_id_05|    |nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_name_01|virtual_server_spec_name_01|
    |physical_server_name_02|virtual_server_id_06|virtual_server_id_06|    |nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |virtual_server_id_07|virtual_server_id_07|    |nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |virtual_server_id_08|virtual_server_id_08|    |nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |physical_server_name_03|virtual_server_id_09|virtual_server_id_09|    |nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_10|virtual_server_id_10|    |nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |physical_server_name_04||||||||
    |physical_server_name_05||||||||
    |physical_server_name_06||||||||
    |physical_server_name_07||||||||
    |physical_server_name_08||||||||
    |physical_server_name_09||||||||
    |physical_server_name_10||||||||

    もし "プロバイダによるID"が"virtual_server_id_06"列の"編集"リンクをクリックする
    ならば "仮想サーバ編集"画面が表示されていること
    かつ "仮想サーバ編集"画面に"physical_server_id_06"と表示されていること

    もし "仮想サーバ名"に"仮想サーバ名06"と入力する
    かつ "説明"に"仮想サーバ説明06"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|仮想サーバ名01|virtual_server_id_01|仮想サーバ説明01|nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_02|virtual_server_id_02|    |nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_03|virtual_server_id_03|    |nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_04|virtual_server_id_04|    |nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_05|virtual_server_id_05|    |nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_name_01|virtual_server_spec_name_01|
    |physical_server_name_02|仮想サーバ名06|virtual_server_id_06|仮想サーバ説明06|nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |virtual_server_id_07|virtual_server_id_07|    |nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |virtual_server_id_08|virtual_server_id_08|    |nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |physical_server_name_03|virtual_server_id_09|virtual_server_id_09|    |nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_10|virtual_server_id_10|    |nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |physical_server_name_04||||||||
    |physical_server_name_05||||||||
    |physical_server_name_06||||||||
    |physical_server_name_07||||||||
    |physical_server_name_08||||||||
    |physical_server_name_09||||||||
    |physical_server_name_10||||||||

    # 代替コースA: 仮想サーバ一覧表を絞り込み検索して表示する。
    # 仮想サーバ名で検索を行う
    もし "仮想サーバ一覧"を表示する
    かつ "仮想サーバ名"に"仮想サーバ名06"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_02|仮想サーバ名06|virtual_server_id_06|仮想サーバ説明06|nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_name_02|virtual_server_spec_name_02|

    # ステータスで検索を行う
    もし "仮想サーバ一覧"を表示する
    かつ "ステータス"の"shuttingdown","terminated"をチェックする
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_id_04|virtual_server_id_04|    |nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |virtual_server_id_05|virtual_server_id_05|    |nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_name_01|virtual_server_spec_name_01|

    # 物理サーバ名で検索を行う(仮想サーバが存在する)
    もし "仮想サーバ一覧"を表示する
    かつ "物理サーバ名"に"physical_server_name_02"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_02|仮想サーバ名06|virtual_server_id_06|仮想サーバ説明06|nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |virtual_server_id_07|virtual_server_id_07|    |nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |virtual_server_id_08|virtual_server_id_08|    |nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_name_02|virtual_server_spec_name_02|

    # 物理サーバ名で検索を行う(仮想サーバが存在しない)
    もし "仮想サーバ一覧"を表示する
    かつ "物理サーバ名"に"physical_server_name_10"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_10||||||||

    # 代替コースD：検索条件にマッチする項目が0件である
    # 仮想サーバ名で検索を行う(結果が0件)
    もし "仮想サーバ一覧"を表示する
    かつ "仮想サーバ名"に"virtual_server_name_none"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
