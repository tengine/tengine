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
    # # Tamaのテストモードの利用に関しては ./README を参照ください
    # かつ "Tengineリソースウォッチャ"プロセスが起動している

  @manual
  シナリオ: [正常系]アプリケーション運用者は物理サーバ一覧画面を開き、物理サーバが表示されていることを確認する
    # 代替コースB：管理下の物理サーバ、仮想サーバが存在しない
    # 物理サーバが0件のファイル
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/00_describe_host_nodes_0_physical_servers.json"を"./features/usecases/resouce/test_files/describe_host_nodes.json"にコピーする
    # 仮想サーバが0件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/10_describe_instances_0_virtual_servers.json"を"./features/usecases/resouce/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが0件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/20_describe_images_0_virtual_server_images.json"を"./features/usecases/resouce/test_files/describe_images.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|仮想サーバ名|プロバイダによるID|説明|ステータス|仮想サーバイメージ名|仮想サーバタイプ|

    # Wakameに仮想サーバの登録を行う
    # 物理サーバが10件のファイル
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/01_describe_host_nodes_10_physical_servers.json"を"./features/usecases/resouce/test_files/describe_host_nodes.json"にコピーする
    # 仮想サーバが10件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/11_describe_instances_10_virtual_servers.json"を"./features/usecases/resouce/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが5件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/20_describe_images_5_virtual_server_images.json"を"./features/usecases/resouce/test_files/describe_images.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|           |vertual_server_id_01|    |nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_02|    |nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_03|    |nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_04|    |nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_05|    |nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_name_01|virtual_server_spec_name_01|
    |physical_server_name_02|           |vertual_server_id_06|    |nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |           |vertual_server_id_07|    |nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |                       |           |vertual_server_id_08|    |nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |physical_server_name_03|           |vertual_server_id_09|    |nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_10|    |nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running|virtual_server_image_name_02|virtual_server_spec_name_02|
    |physical_server_name_04||||||||
    |physical_server_name_05||||||||
    |physical_server_name_06||||||||
    |physical_server_name_07||||||||
    |physical_server_name_08||||||||
    |physical_server_name_09||||||||
    |physical_server_name_10||||||||
