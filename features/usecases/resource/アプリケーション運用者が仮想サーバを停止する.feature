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
    # かつ TengineリソースでTamaのテストモードを使用するため、Tengine::Resource::Provider#connection_settingsに設定する
    #  > rails runner features/usecases/resource/scripts/create_providor_wakame_test.rb <テストファイル群の配置ディレクトリ>
    # かつ 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプのデータを全削除する
    #  > rails runner features/usecases/resource/scripts/delete_all_resources.rb
    # かつ "Tengineリソースウォッチャ"プロセスが起動している
    #  > tengine_resource_watchd

  @manual
  シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面から仮想サーバの停止を行う
    # 物理サーバが10件のファイル
    もし Wakameのモックファイル"./features/usecases/resouce/test_files/01_describe_host_nodes_10_physical_servers.json"を"./features/usecases/resouce/test_files/describe_host_nodes.json"にコピーする
    # 仮想サーバを起動した後のファイル
    もし Wakameのモックファイル"./features/usecases/resource/test_files/12_describe_instances_after_run_instances.json"を"./features/usecases/resource/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが5件のファイル
    かつ Wakameのモックファイル"./features/usecases/resource/test_files/21_describe_images_5_virtual_server_images.json"を"./features/usecases/resource/test_files/describe_images.json"にコピーする
    # 仮想サーバタイプが4件のファイル
    かつ Wakameのモックファイル"./features/usecases/resource/test_files/31_describe_instance_specs_4_virtual_server_specs.json"を"./features/usecases/resource/test_files/31_describe_instance_specs.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|           |virtual_server_id_91|  |nw-data: 192.168.2.91 <br>nw-outside: 172.16.0.91 |running|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |virtual_server_id_92|  |nw-data: 192.168.2.92 <br>nw-outside: 172.16.0.92 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |           |virtual_server_id_93|  |nw-data: 192.168.2.93 <br>nw-outside: 172.16.0.93 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |           |virtual_server_id_94|  |nw-data: 192.168.2.94 <br>nw-outside: 172.16.0.94 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |           |virtual_server_id_95|  |nw-data: 192.168.2.95 <br>nw-outside: 172.16.0.95 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |           |virtual_server_id_96|  |nw-data: 192.168.2.96 <br>nw-outside: 172.16.0.96 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |physical_server_name_02||||||||
    |physical_server_name_03||||||||
    |physical_server_name_04||||||||
    |physical_server_name_05||||||||
    |physical_server_name_06||||||||
    |physical_server_name_07||||||||
    |physical_server_name_08||||||||
    |physical_server_name_09||||||||
    |physical_server_name_10||||||||

    # 仮想サーバの停止を行う
    もし Wakameのモックファイル"./features/usecases/resource/test_files/51_terminate_instances_3_virtual_servers.json"を"./features/usecases/resource/test_files/terminate_instances.json"にコピーする
    もし "virtual_server_id_91"の列の"削除"チェックボックスをオンにする
    かつ "virtual_server_id_92"の列の"削除"チェックボックスをオンにする
    かつ "virtual_server_id_93"の列の"削除"チェックボックスをオンにする
    かつ "選択したサーバを停止"ボタンをクリックする
    
    もし Wakameのモックファイル"./features/usecases/resource/test_files/13_describe_instances_after_terminate_instances.json"を"./features/usecases/resource/test_files/describe_instances.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|           |virtual_server_id_91|  |nw-data: 192.168.2.91 <br>nw-outside: 172.16.0.91 |terminated|virtual_server_image_name_01|virtual_server_spec_name_01|
    |                       |           |virtual_server_id_92|  |nw-data: 192.168.2.92 <br>nw-outside: 172.16.0.92 |terminates|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |           |virtual_server_id_93|  |nw-data: 192.168.2.93 <br>nw-outside: 172.16.0.93 |shuttingdown|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |           |virtual_server_id_94|  |nw-data: 192.168.2.94 <br>nw-outside: 172.16.0.94 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |           |virtual_server_id_95|  |nw-data: 192.168.2.95 <br>nw-outside: 172.16.0.95 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |                       |           |virtual_server_id_96|  |nw-data: 192.168.2.96 <br>nw-outside: 172.16.0.96 |running|virtual_server_image_name_01|virtual_server_spec_name_02|
    |physical_server_name_02||||||||
    |physical_server_name_03||||||||
    |physical_server_name_04||||||||
    |physical_server_name_05||||||||
    |physical_server_name_06||||||||
    |physical_server_name_07||||||||
    |physical_server_name_08||||||||
    |physical_server_name_09||||||||
    |physical_server_name_10||||||||

    # 起動可能数の確認
    # physical_server_name_01 CPU:100, メモリ:100000
    # virtual_server_spec_name_03 CPU:5, メモリ:1
    # virtual_server_spec_name_04 CPU:1, メモリ:1500
    # physical_server_name_01 内で起動中の仮想サーバの合計 CPU:(1*0)+(2*4)=8, メモリ:(256*0)+(512*4)=2048
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_name_03"を選択する
    # CPU (100 - 8) / 5 = 18
    ならば "起動可能数"に"18"と表示されること
    かつ "仮想サーバタイプ"に"virtual_server_spec_name_04"を選択する
    # メモリ (100000 - 2048) / 1500 = 65
    ならば "起動可能数"に"32"と表示されること
    もし "キャンセル"ボタンをクリックする
    ならば "仮想サーバ一覧"画面が表示されていること
