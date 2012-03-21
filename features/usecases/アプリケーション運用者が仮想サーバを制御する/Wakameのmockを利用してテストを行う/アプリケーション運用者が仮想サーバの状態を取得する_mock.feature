#language:ja
機能: アプリケーション運用者が仮想サーバの状態を取得する
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
    #  > rails runner features/usecases/resource/scripts/create_providor_wakame_test.rb features/usecases/resource/scripts/test_files -e production
    # かつ 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプのデータを全削除する
    #  > rails runner features/usecases/resource/scripts/delete_all_resources.rb -e production
    # かつ "Tengineコア"プロセスを起動している(ジョブの実行は行わないので読み込むDSLはエラーにならなければどれでもよい)
    #  > tengined -f config/tengined.yml.erb -T usecases/job/dsl/1001_one_job_in_jobnet.rb

  @manual
  @07_02_01
  シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面を開き、仮想サーバが表示されていることを確認する
    # 代替コースC: 管理下の物理サーバが存在しない
    # 物理サーバが0件のファイル
    もし Wakameのモックファイル"./features/usecases/resource/test_files/00_describe_host_nodes_0_physical_servers.json"を"./features/usecases/resource/test_files/describe_host_nodes.json"にコピーする
    # 仮想サーバが0件のファイル
    かつ Wakameのモックファイル"./features/usecases/resource/test_files/10_describe_instances_0_virtual_servers.json"を"./features/usecases/resource/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが5件のファイル
    かつ Wakameのモックファイル"./features/usecases/resource/test_files/21_describe_images_5_virtual_server_images.json"を"./features/usecases/resource/test_files/describe_images.json"にコピーする
    # 仮想サーバタイプが4件のファイル
    かつ Wakameのモックファイル"./features/usecases/resource/test_files/31_describe_instance_specs_4_virtual_server_specs.json"を"./features/usecases/resource/test_files/describe_instance_specs.json"にコピーする
    かつ "Tengineリソースウォッチャ"プロセスを起動する
    # > tengine_resource_watchd
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|仮想サーバ名|プロバイダによるID|説明|ステータス|仮想サーバイメージ名|仮想サーバタイプ|

    # 代替コースB：管理下の仮想サーバが存在しない
    # Wakameに仮想サーバの登録を行う
    # 物理サーバが10件のファイル
    もし Wakameのモックファイル"./features/usecases/resource/test_files/01_describe_host_nodes_10_physical_servers.json"を"./features/usecases/resource/test_files/describe_host_nodes.json"にコピーする
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|仮想サーバ名|プロバイダによるID|説明|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|仮想サーバは起動していません。|||||||
    |physical_server_name_02|仮想サーバは起動していません。|||||||
    |physical_server_name_03|仮想サーバは起動していません。|||||||
    |physical_server_name_04|仮想サーバは起動していません。|||||||
    |physical_server_name_05|仮想サーバは起動していません。|||||||
    |physical_server_name_06|仮想サーバは起動していません。|||||||
    |physical_server_name_07|仮想サーバは起動していません。|||||||
    |physical_server_name_08|仮想サーバは起動していません。|||||||
    |physical_server_name_09|仮想サーバは起動していません。|||||||
    |physical_server_name_10|仮想サーバは起動していません。|||||||

    # 基本コース:
    # 仮想サーバが10件のファイル
    もし Wakameのモックファイル"./features/usecases/resource/test_files/11_describe_instances_10_virtual_servers.json"を"./features/usecases/resource/test_files/describe_instances.json"にコピーする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_uuid_01|virtual_server_uuid_01|    |private_ip_address: 192.168.2.1 <br>nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_02|virtual_server_uuid_02|    |private_ip_address: 192.168.2.2 <br>nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_03|virtual_server_uuid_03|    |private_ip_address: 192.168.2.3 <br>nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_04|virtual_server_uuid_04|    |private_ip_address: 192.168.2.4 <br>nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_05|virtual_server_uuid_05|    |private_ip_address: 192.168.2.5 <br>nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |physical_server_name_02|virtual_server_uuid_06|virtual_server_uuid_06|    |private_ip_address: 192.168.2.6 <br>nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_07|virtual_server_uuid_07|    |private_ip_address: 192.168.2.7 <br>nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_08|virtual_server_uuid_08|    |private_ip_address: 192.168.2.8 <br>nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_03|virtual_server_uuid_09|virtual_server_uuid_09|    |private_ip_address: 192.168.2.9 <br>nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_10|virtual_server_uuid_10|    |private_ip_address: 192.168.2.10 <br>nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_04|仮想サーバは起動していません。|||||||
    |physical_server_name_05|仮想サーバは起動していません。|||||||
    |physical_server_name_06|仮想サーバは起動していません。|||||||
    |physical_server_name_07|仮想サーバは起動していません。|||||||
    |physical_server_name_08|仮想サーバは起動していません。|||||||
    |physical_server_name_09|仮想サーバは起動していません。|||||||
    |physical_server_name_10|仮想サーバは起動していません。|||||||

    もし"イベント一覧"画面を表示する
    ならば"種別名"に"Tengine::Resource::VirtualServer.created.tengine_resource_watchd"のイベントが10件表示されていること

    # 仮想サーバの仮想サーバ名、説明を編集する
    もし "仮想サーバ一覧"画面を表示する
    もし "プロバイダによるID"が"virtual_server_uuid_01"列の"編集"リンクをクリックする
    ならば "仮想サーバ編集"画面が表示されていること
    かつ "仮想サーバ編集"画面に"virtual_server_uuid_01"と表示されていること

    もし "仮想サーバ名"に"virtual_server_name_01"と入力する
    かつ "説明"に"仮想サーバ説明01"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_name_01|virtual_server_uuid_01|仮想サーバ説明01|private_ip_address: 192.168.2.1 <br>nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_02|virtual_server_uuid_02|    |private_ip_address: 192.168.2.2 <br>nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_03|virtual_server_uuid_03|    |private_ip_address: 192.168.2.3 <br>nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_04|virtual_server_uuid_04|    |private_ip_address: 192.168.2.4 <br>nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_05|virtual_server_uuid_05|    |private_ip_address: 192.168.2.5 <br>nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |physical_server_name_02|virtual_server_uuid_06|virtual_server_uuid_06|    |private_ip_address: 192.168.2.6 <br>nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_07|virtual_server_uuid_07|    |private_ip_address: 192.168.2.7 <br>nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_08|virtual_server_uuid_08|    |private_ip_address: 192.168.2.8 <br>nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_03|virtual_server_uuid_09|virtual_server_uuid_09|    |private_ip_address: 192.168.2.9 <br>nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_10|virtual_server_uuid_10|    |private_ip_address: 192.168.2.10 <br>nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_04|仮想サーバは起動していません。|||||||
    |physical_server_name_05|仮想サーバは起動していません。|||||||
    |physical_server_name_06|仮想サーバは起動していません。|||||||
    |physical_server_name_07|仮想サーバは起動していません。|||||||
    |physical_server_name_08|仮想サーバは起動していません。|||||||
    |physical_server_name_09|仮想サーバは起動していません。|||||||
    |physical_server_name_10|仮想サーバは起動していません。|||||||

    もし "プロバイダによるID"が"virtual_server_uuid_06"列の"編集"リンクをクリックする
    ならば "仮想サーバ編集"画面が表示されていること
    かつ "仮想サーバ編集"画面に"virtual_server_uuid_06"と表示されていること

    もし "仮想サーバ名"に"virtual_server_name_06"と入力する
    かつ "説明"に"仮想サーバ説明06"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_name_01|virtual_server_uuid_01|仮想サーバ説明01|private_ip_address: 192.168.2.1 <br>nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_02|virtual_server_uuid_02|    |private_ip_address: 192.168.2.2 <br>nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_03|virtual_server_uuid_03|    |private_ip_address: 192.168.2.3 <br>nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_04|virtual_server_uuid_04|    |private_ip_address: 192.168.2.4 <br>nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_05|virtual_server_uuid_05|    |private_ip_address: 192.168.2.5 <br>nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |physical_server_name_02|virtual_server_name_06|virtual_server_uuid_06|仮想サーバ説明06|private_ip_address: 192.168.2.6 <br>nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_07|virtual_server_uuid_07|    |private_ip_address: 192.168.2.7 <br>nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_08|virtual_server_uuid_08|    |private_ip_address: 192.168.2.8 <br>nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_03|virtual_server_uuid_09|virtual_server_uuid_09|    |private_ip_address: 192.168.2.9 <br>nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_10|virtual_server_uuid_10|    |private_ip_address: 192.168.2.10 <br>nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_04|仮想サーバは起動していません。|||||||
    |physical_server_name_05|仮想サーバは起動していません。|||||||
    |physical_server_name_06|仮想サーバは起動していません。|||||||
    |physical_server_name_07|仮想サーバは起動していません。|||||||
    |physical_server_name_08|仮想サーバは起動していません。|||||||
    |physical_server_name_09|仮想サーバは起動していません。|||||||
    |physical_server_name_10|仮想サーバは起動していません。|||||||

    # 仮想サーバ名のバリデーションチェック
    もし "プロバイダによるID"が"virtual_server_uuid_02"列の"編集"リンクをクリックする
    ならば "仮想サーバ編集"画面が表示されていること
    かつ "仮想サーバ編集"画面に"virtual_server_uuid_02"と表示されていること

    もし "仮想サーバ名"に"virtual_server_name_01"と入力する # すでに使用している名前を入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ編集"画面が表示されていること
    かつ "仮想サーバ名 はすでに使用されています"と表示されていること

    もし "キャンセル"リンクをクリックする
    ならば "仮想サーバ一覧"画面が表示されていること
    かつ "仮想サーバ一覧"画面に以下の行が表示されていること #virtual_server_uuid_02 の仮想サーバ名が更新されていないこと
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_name_01|virtual_server_uuid_01|仮想サーバ説明01|private_ip_address: 192.168.2.1 <br>nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_02|virtual_server_uuid_02|    |private_ip_address: 192.168.2.2 <br>nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_03|virtual_server_uuid_03|    |private_ip_address: 192.168.2.3 <br>nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_04|virtual_server_uuid_04|    |private_ip_address: 192.168.2.4 <br>nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_05|virtual_server_uuid_05|    |private_ip_address: 192.168.2.5 <br>nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |physical_server_name_02|virtual_server_name_06|virtual_server_uuid_06|仮想サーバ説明06|private_ip_address: 192.168.2.6 <br>nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_07|virtual_server_uuid_07|    |private_ip_address: 192.168.2.7 <br>nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_08|virtual_server_uuid_08|    |private_ip_address: 192.168.2.8 <br>nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_03|virtual_server_uuid_09|virtual_server_uuid_09|    |private_ip_address: 192.168.2.9 <br>nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_10|virtual_server_uuid_10|    |private_ip_address: 192.168.2.10 <br>nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_04|仮想サーバは起動していません。|||||||
    |physical_server_name_05|仮想サーバは起動していません。|||||||
    |physical_server_name_06|仮想サーバは起動していません。|||||||
    |physical_server_name_07|仮想サーバは起動していません。|||||||
    |physical_server_name_08|仮想サーバは起動していません。|||||||
    |physical_server_name_09|仮想サーバは起動していません。|||||||
    |physical_server_name_10|仮想サーバは起動していません。|||||||

    # 代替コースA: 仮想サーバ一覧表を絞り込み検索して表示する。
    # 仮想サーバ名で検索を行う
    もし "仮想サーバ一覧"を表示する
    かつ "仮想サーバ名"に"virtual_server_name_06"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_02|virtual_server_name_06|virtual_server_uuid_06|仮想サーバ説明06|private_ip_address: 192.168.2.6 <br>nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|

    # ステータスで検索を行う
    もし "仮想サーバ一覧"を表示する
    かつ "ステータス"の"shuttingdown","terminated"をチェックする
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_uuid_04|virtual_server_uuid_04|    |private_ip_address: 192.168.2.4 <br>nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_05|virtual_server_uuid_05|    |private_ip_address: 192.168.2.5 <br>nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

    # 物理サーバ名で検索を行う(仮想サーバが存在する)
    もし "仮想サーバ一覧"を表示する
    かつ "物理サーバ名"に"physical_server_name_02"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_02|virtual_server_name_06|virtual_server_uuid_06|仮想サーバ説明06|private_ip_address: 192.168.2.6 <br>nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_07|virtual_server_uuid_07|    |private_ip_address: 192.168.2.7 <br>nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_08|virtual_server_uuid_08|    |private_ip_address: 192.168.2.8 <br>nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|

    # 物理サーバ名で検索を行う(仮想サーバが存在しない)
    もし "仮想サーバ一覧"を表示する
    かつ "物理サーバ名"に"physical_server_name_10"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_10|仮想サーバは起動していません。|||||||

    # 代替コースD：検索条件にマッチする項目が0件である
    # 仮想サーバ名で検索を行う(結果が0件)
    もし "仮想サーバ一覧"を表示する
    かつ "仮想サーバ名"に"virtual_server_name_none"と入力する
    かつ "検索"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|

  @manual
  @07_02_02
  シナリオ: [正常系]仮想サーバイメージ名の変更が仮想サーバ一覧画面の仮想サーバイメージ名に反映されることを確認する
    # 物理サーバが10件のファイル
    もし Wakameのモックファイル"./features/usecases/resource/test_files/01_describe_host_nodes_10_physical_servers.json"を"./features/usecases/resource/test_files/describe_host_nodes.json"にコピーする
    # 仮想サーバが10件のファイル
    かつ Wakameのモックファイル"./features/usecases/resource/test_files/11_describe_instances_10_virtual_servers.json"を"./features/usecases/resource/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが5件のファイル
    かつ Wakameのモックファイル"./features/usecases/resource/test_files/21_describe_images_5_virtual_server_images.json"を"./features/usecases/resource/test_files/describe_images.json"にコピーする
    # 仮想サーバタイプが4件のファイル
    かつ Wakameのモックファイル"./features/usecases/resource/test_files/31_describe_instance_specs_4_virtual_server_specs.json"を"./features/usecases/resource/test_files/31_describe_instance_specs.json"にコピーする
    かつ "Tengineリソースウォッチャ"プロセスを起動する
    # > tengine_resource_watchd

    もし "仮想サーバ一覧"を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_uuid_01|virtual_server_uuid_01|    |private_ip_address: 192.168.2.1 <br>nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_02|virtual_server_uuid_02|    |private_ip_address: 192.168.2.2 <br>nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_03|virtual_server_uuid_03|    |private_ip_address: 192.168.2.3 <br>nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_04|virtual_server_uuid_04|    |private_ip_address: 192.168.2.4 <br>nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_05|virtual_server_uuid_05|    |private_ip_address: 192.168.2.5 <br>nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |physical_server_name_02|virtual_server_uuid_06|virtual_server_uuid_06|    |private_ip_address: 192.168.2.6 <br>nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_07|virtual_server_uuid_07|    |private_ip_address: 192.168.2.7 <br>nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_08|virtual_server_uuid_08|    |private_ip_address: 192.168.2.8 <br>nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_03|virtual_server_uuid_09|virtual_server_uuid_09|    |private_ip_address: 192.168.2.9 <br>nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_10|virtual_server_uuid_10|    |private_ip_address: 192.168.2.10 <br>nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running|virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_04|仮想サーバは起動していません。|||||||
    |physical_server_name_05|仮想サーバは起動していません。|||||||
    |physical_server_name_06|仮想サーバは起動していません。|||||||
    |physical_server_name_07|仮想サーバは起動していません。|||||||
    |physical_server_name_08|仮想サーバは起動していません。|||||||
    |physical_server_name_09|仮想サーバは起動していません。|||||||
    |physical_server_name_10|仮想サーバは起動していません。|||||||

    # 仮想サーバイメージ名を編集する
    もし "仮想サーバイメージ一覧"画面を表示する
    ならば "仮想サーバイメージ一覧"画面に以下の行が表示されていること
    |仮想サーバイメージ名|プロバイダによるID|プロバイダによる説明|説明|
    |virtual_server_image_uuid_01|virtual_server_image_uuid_01|virtual_server_image_description_01||
    |virtual_server_image_uuid_02|virtual_server_image_uuid_02|virtual_server_image_description_02||
    |virtual_server_image_uuid_03|virtual_server_image_uuid_03|virtual_server_image_description_03||
    |virtual_server_image_uuid_04|virtual_server_image_uuid_04|virtual_server_image_description_04||
    |virtual_server_image_uuid_05|virtual_server_image_uuid_05|virtual_server_image_description_05||

    もし "仮想サーバイメージ名"が"virtual_server_image_uuid_01"列の"編集"リンクをクリックする
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

    もし "仮想サーバ一覧"を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること # 仮想サーバイメージ名の"virtual_server_image_uuid_01"が"virtual_server_image_name_01"に変わっていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名           |プロバイダによるID       |説明|IPアドレス                                                                            |ステータス    |仮想サーバイメージ名   |仮想サーバタイプ|
    |physical_server_name_01|virtual_server_uuid_01|virtual_server_uuid_01|仮想サーバイメージ説明01|private_ip_address: 192.168.2.1 <br>nw-data: 192.168.2.1 <br>nw-outside: 172.16.0.1 |running      |virtual_server_image_name_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_02|virtual_server_uuid_02|    |private_ip_address: 192.168.2.2 <br>nw-data: 192.168.2.2 <br>nw-outside: 172.16.0.2 |running      |virtual_server_image_name_01(仮想サーバイメージ説明01)|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_03|virtual_server_uuid_03|    |private_ip_address: 192.168.2.3 <br>nw-data: 192.168.2.3 <br>nw-outside: 172.16.0.3 |starting     |virtual_server_image_name_01(仮想サーバイメージ説明01)|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_04|virtual_server_uuid_04|    |private_ip_address: 192.168.2.4 <br>nw-data: 192.168.2.4 <br>nw-outside: 172.16.0.4 |shuttingdown |virtual_server_image_name_01(仮想サーバイメージ説明01)|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_05|virtual_server_uuid_05|    |private_ip_address: 192.168.2.5 <br>nw-data: 192.168.2.5 <br>nw-outside: 172.16.0.5 |terminated   |virtual_server_image_name_01(仮想サーバイメージ説明01)|virtual_server_spec_uuid_01|
    |physical_server_name_02|virtual_server_uuid_06|virtual_server_uuid_06|    |private_ip_address: 192.168.2.6 <br>nw-data: 192.168.2.6 <br>nw-outside: 172.16.0.6 |running      |virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_07|virtual_server_uuid_07|    |private_ip_address: 192.168.2.7 <br>nw-data: 192.168.2.7 <br>nw-outside: 172.16.0.7 |running      |virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_08|virtual_server_uuid_08|    |private_ip_address: 192.168.2.8 <br>nw-data: 192.168.2.8 <br>nw-outside: 172.16.0.8 |running      |virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_03|virtual_server_uuid_09|virtual_server_uuid_09|    |private_ip_address: 192.168.2.9 <br>nw-data: 192.168.2.9 <br>nw-outside: 172.16.0.9 |running      |virtual_server_image_name_01(仮想サーバイメージ説明01)|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_10|virtual_server_uuid_10|    |private_ip_address: 192.168.2.10 <br>nw-data: 192.168.2.10<br>nw-outside: 172.16.0.10|running     |virtual_server_image_uuid_02|virtual_server_spec_uuid_02|
    |physical_server_name_04|仮想サーバは起動していません。|||||||
    |physical_server_name_05|仮想サーバは起動していません。|||||||
    |physical_server_name_06|仮想サーバは起動していません。|||||||
    |physical_server_name_07|仮想サーバは起動していません。|||||||
    |physical_server_name_08|仮想サーバは起動していません。|||||||
    |physical_server_name_09|仮想サーバは起動していません。|||||||
    |physical_server_name_10|仮想サーバは起動していません。|||||||
