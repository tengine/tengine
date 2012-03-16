#language:ja
機能: アプリケーション運用者が仮想サーバを停止する
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
  @07_02_03
  シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面から仮想サーバの停止を行う
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_uuid_91|virtual_server_uuid_91|  |private_ip_address: 192.168.2.91 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_92|virtual_server_uuid_92|  |private_ip_address: 192.168.2.92 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_93|virtual_server_uuid_93|  |private_ip_address: 192.168.2.93 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|

    # 起動可能数の確認
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    ならば "起動可能数"を確認する # 後で実行する仮想サーバ停止の後に起動可能数が増加することを確認します

    # 仮想サーバの停止を行う
    もし 1列目の仮想サーバのチェックボックスをオンにする
    かつ "選択したサーバを停止"ボタンをクリックする

    # 発火イベントの確認
    もし"60"秒間待機する # 秒数はWakameの環境によって異なります

    もし"仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること # 停止処理を行った仮想サーバのステータスが"terminated"になることを確認する
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_uuid_91|virtual_server_uuid_91|  |private_ip_address: 192.168.2.91 |terminated|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_uuid_92|virtual_server_uuid_92|  |private_ip_address: 192.168.2.92 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_93|virtual_server_uuid_93|  |private_ip_address: 192.168.2.93 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|

    もし"イベント一覧"画面を表示する
    ならば 以下のイベントが1件表示されていること
    |種別名    |"Tengine::Resource::VirtualServer.updated.tengine_resource_watchd"である|
    |プロパティ|"status:"が"terminated"に変わっている                                   |

    # 起動可能数の確認
    もし"イベント一覧"画面を表示する
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    ならば "起動可能数"が停止前の数値から"+1"された値が表示されること # ステータスがterminatedの仮想サーバは起動可能数の計算対象外となる
    もし "キャンセル"ボタンをクリックする
    ならば "仮想サーバ一覧"画面が表示されていること

    # 発火イベントの確認
    もし"15"分間待機する # 分数はWakameの環境によって異なります
    もし"イベント一覧"画面を表示する
    ならば "種別名"に"Tengine::Resource::VirtualServer.destroyed.tengine_resource_watchd"のイベントが1件表示されていること
    もし"仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること # 停止処理を行った仮想サーバが存在しないことを確認する
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|virtual_server_uuid_92|virtual_server_uuid_92|  |private_ip_address: 192.168.2.92 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|
    |                       |virtual_server_uuid_93|virtual_server_uuid_93|  |private_ip_address: 192.168.2.93 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|

    # 起動可能数の確認
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    ならば "起動可能数"が停止前の数値から"+1"された値が表示されること
