#language:ja
機能: アプリケーション運用屋が仮想サーバを停止する
  分散ジョブの実行後に物理サーバのリソースを確保するために
  アプリケーション運用者
  は仮想サーバを停止したい

  # @manual
  # 背景に関しては@manualタグを付けることができないのでコメントアウトしています
  背景:
    # 前提 日本語でアクセスする
    # かつ サーバ仮想基盤がセットアップされている
    # かつ Tengineにサーバ仮想基盤の接続先の設定を行なっている
    # # Tamaのテストモードの利用に関しては ./README を参照ください
    # かつ "Tengineリソースウォッチャ"プロセスが起動している

  @manual
  シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面から仮想サーバの停止を行う
    # 物理サーバが10件のファイル
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/01_describe_host_nodes_10_physical_servers.json"を"./features/usecases/resouce/test_files/describe_host_nodes.json"にコピーする
    # 仮想サーバが10件のファイル
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/12_describe_instances_after_run_instances.json"を"./features/usecases/resouce/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが5件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/21_describe_images_5_virtual_server_images.json"を"./features/usecases/resouce/test_files/describe_images.json"にコピーする
    # 仮想サーバタイプが2件のファイル
    かつ Wakameのモックファイル"./features/usecases/resouce/test_files/31_describe_instance_specs_4_virtual_server_specs.json"を"./features/usecases/resouce/test_files/31_describe_instance_specs.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|           |vertual_server_id_01|    |nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_02|    |nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_03|    |nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_04|    |nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_05|    |nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |仮想サーバを1台起動001|vertual_server_id_91|仮想サーバを1台起動テストの説明|nw-data: 192.168.2.91 <br>nw-outside: 172.16.0.91 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |仮想サーバを5台起動001|vertual_server_id_92|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.92 <br>nw-outside: 172.16.0.92 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |仮想サーバを5台起動002|vertual_server_id_93|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.93 <br>nw-outside: 172.16.0.93 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |仮想サーバを5台起動003|vertual_server_id_94|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.94 <br>nw-outside: 172.16.0.94 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |仮想サーバを5台起動004|vertual_server_id_95|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.95 <br>nw-outside: 172.16.0.95 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |仮想サーバを5台起動005|vertual_server_id_96|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.96 <br>nw-outside: 172.16.0.96 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
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

    # 仮想サーバの停止を行う
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/51_terminate_instances_3_virtual_servers.json"を"./features/usecases/resouce/test_files/terminate_instances.json"にコピーする
    もし "vertual_server_id_91"の列の"削除"チェックボックスをオンにする
    かつ "vertual_server_id_92"の列の"削除"チェックボックスをオンにする
    かつ "vertual_server_id_93"の列の"削除"チェックボックスをオンにする
    かつ "選択したサーバを停止"ボタンをクリックする
    
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/13_describe_instances_after_terminate_instances.json"を"./features/usecases/resouce/test_files/describe_instances.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|           |vertual_server_id_01|    |nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_02|    |nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_03|    |nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_04|    |nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |vertual_server_id_05|    |nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |仮想サーバを1台起動001|vertual_server_id_91|仮想サーバを1台起動テストの説明|nw-data: 192.168.2.91 <br>nw-outside: 172.16.0.91 |terminated|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |仮想サーバを5台起動001|vertual_server_id_92|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.92 <br>nw-outside: 172.16.0.92 |terminated|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |仮想サーバを5台起動002|vertual_server_id_93|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.93 <br>nw-outside: 172.16.0.93 |terminated|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |仮想サーバを5台起動003|vertual_server_id_94|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.94 <br>nw-outside: 172.16.0.94 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |仮想サーバを5台起動004|vertual_server_id_95|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.95 <br>nw-outside: 172.16.0.95 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |仮想サーバを5台起動005|vertual_server_id_96|仮想サーバを5台起動テストの説明|nw-data: 192.168.2.96 <br>nw-outside: 172.16.0.96 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
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
