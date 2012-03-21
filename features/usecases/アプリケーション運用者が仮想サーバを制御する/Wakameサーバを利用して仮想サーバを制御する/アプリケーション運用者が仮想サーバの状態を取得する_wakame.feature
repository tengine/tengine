#language:ja
機能: アプリケーション運用者が仮想サーバの状態を取得する
  分散ジョブを起動するために
  アプリケーション運用者
  は仮想サーバの状態を取得したい

  #
  # {アプリケーション運用者が仮想サーバの状態を取得する}_wakame.featureではWakameとの接続の確認を行います
  # そのため、検索などWakameの接続と無関係のものはシナリオから外しています。
  # 仮想サーバ名、説明の編集もWakameとの接続は行わないのですが、resource_watcherが仮想サーバ名と説明を変更しないことを確認します
  #

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
    # かつ TengineリソースでWakameを使用するため、Tengine::Resource::Provider#connection_settingsに設定する
    #  > rails runner features/usecases/resource/scripts/create_providor_wakame_real.rb
    # かつ 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプのデータを全削除する
    #  > rails runner features/usecases/resource/scripts/delete_all_resources.rb
    # かつ "Tengineリソースウォッチャ"プロセスが起動している
    #  > tengine_resource_watchd
    # かつ "Tengineコア"プロセスを起動している(ジョブの実行は行わないので読み込むDSLはエラーにならなければどれでもよい)
    #  > tengined -f config/tengined.yml.erb -T usecases/job/dsl/1001_one_job_in_jobnet.rb

    #
    # 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプはテストを行うWakameの環境に応じて読み替えてください
    #

  @manual
  @07_03_01
  シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面を開き、仮想サーバが表示されていることを確認する
    # 代替コースB：管理下の仮想サーバが存在しない
    # この状態はすでに仮想サーバが起動している環境では確認できません
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名|仮想サーバ名|プロバイダによるID|説明|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|仮想サーバは起動していません。|||||||

    # 基本コース:
    # 管理下の仮想サーバが存在する場合
    もし "アプリケーション運用者が仮想サーバを起動する"を実施する
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_3_virtual_servers001|virtual_server_uuid_01|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.1|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers002|virtual_server_uuid_02|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.2|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers003|virtual_server_uuid_03|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.3|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

    もし"イベント一覧"画面を表示する
    ならば 以下のイベントが3件表示されていること
    |種別名    |"Tengine::Resource::VirtualServer.updated.tengine_resource_watchd"である|
    |プロパティ|"status:"が"running"に変わっている                                      |

    # 仮想サーバの仮想サーバ名、説明を編集する
    もし "仮想サーバ名"が"run_3_virtual_servers001"列の"編集"リンクをクリックする
    ならば "仮想サーバ編集"画面が表示されていること
    かつ "仮想サーバ編集"画面に"run_3_virtual_servers001"と表示されていること

    もし "仮想サーバ名"に"virtual_server_name_01"と入力する
    かつ "説明"に"仮想サーバ説明01"と入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること # 物理サーバ名 -> 仮想サーバ名でソートするので、順序が入れ替わります
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_3_virtual_servers002|virtual_server_uuid_02|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.2|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers003|virtual_server_uuid_03|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.3|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_name_01|virtual_server_uuid_01|仮想サーバ説明01|private_ip_address: 192.168.2.1 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

    # 仮想サーバ名のバリデーションチェック
    もし "仮想サーバ名"が"run_3_virtual_servers002"列の"編集"リンクをクリックする
    ならば "仮想サーバ編集"画面が表示されていること
    かつ "仮想サーバ編集"画面に"run_3_virtual_servers002"と表示されていること

    もし "仮想サーバ名"に"virtual_server_name_01"と入力する # すでに使用している名前を入力する
    かつ "更新"ボタンをクリックする
    ならば "仮想サーバ編集"画面が表示されていること
    かつ "仮想サーバ名 はすでに使用されています"と表示されていること

    もし "キャンセル"リンクをクリックする
    ならば "仮想サーバ一覧"画面が表示されていること
    かつ "仮想サーバ一覧"画面に以下の行が表示されていること #virtual_server_uuid_02 の仮想サーバ名が更新されていないこと
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_3_virtual_servers002|virtual_server_uuid_02|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.2|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers003|virtual_server_uuid_03|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.3|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |virtual_server_name_01|virtual_server_uuid_01|仮想サーバ説明01|private_ip_address: 192.168.2.1 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
