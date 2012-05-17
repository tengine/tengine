#language:ja
機能: アプリケーション運用者が仮想サーバを起動する
  分散ジョブを実行するために
  アプリケーション運用者
  は仮想サーバを起動したい

  # @manual
  # 背景に関しては@manualタグを付けることができないのでコメントアウトしています
  背景:
    # 前提 日本語でアクセスする
    # かつ サーバ仮想基盤がセットアップされている
    # かつ Tengineにサーバ仮想基盤の接続先の設定を行なっている
    # かつ TengineリソースでTamaのテストモードを使用するため、Tengine::Resource::Provider#connection_settingsに設定する
    # #ファイルを置く予定のディレクトリには実行権限を付与する必要があります。例:chmod +x /home/user
    # #ファイル自身にも読み込み権限を付与する必要があります
    #  > rails runner features/script/create_providor_wakame_test.rb features/test_files -e production
    # かつ 仮想サーバ、物理サーバ、仮想サーバイメージ、仮想サーバタイプのデータを全削除する
    #  > rails runner features/script/delete_all_resources.rb -e production
    # かつ "Tengineコア"プロセスを起動している(ジョブの実行は行わないので読み込むDSLはエラーにならなければどれでもよい)
    #  > tengined -f config/tengined.yml.erb -T usecases/job/dsl/1001_one_job_in_jobnet.rb

  @manual
  @07_02_03
  シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面から仮想サーバの起動を行う
    # 物理サーバが10件のファイル
    もし Wakameのモックファイル"./features/test_files/01_describe_host_nodes_10_physical_servers.json"を"./features/test_files/describe_host_nodes.json"にコピーする
    # 仮想サーバが0件のファイル
    かつ Wakameのモックファイル"./features/test_files/10_describe_instances_0_virtual_servers.json"を"./features/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが5件のファイル
    かつ Wakameのモックファイル"./features/test_files/21_describe_images_5_virtual_server_images.json"を"./features/test_files/describe_images.json"にコピーする
    # 仮想サーバタイプが4件のファイル
    かつ Wakameのモックファイル"./features/test_files/31_describe_instance_specs_4_virtual_server_specs.json"を"./features/test_files/describe_instance_specs.json"にコピーする
    かつ "Tengineリソースウォッチャ"プロセスを起動する
    #  > tengine_resource_watchd
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
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

    # 起動可能数の確認
    # physical_server_uuid_01 CPU:100, メモリ:100000
    # virtual_server_spec_uuid_03 CPU:5, メモリ:1
    # virtual_server_spec_uuid_04 CPU:1, メモリ:3000
    # physical_server_name_01 内のterminated以外のの仮想サーバの合計 CPU:4, メモリ:1024
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_03"を選択する
    # CPU (100 - 0) / 5 = 20
    ならば "起動可能数"に"20"と表示されること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_04"を選択する
    # メモリ (100000 - 0) / 1500 = 66
    ならば "起動可能数"に"66"と表示されること
    もし "キャンセル"ボタンをクリックする
    ならば "仮想サーバ一覧"画面が表示されていること

    # 仮想サーバを1台起動
    もし "Tengineリソースウォッチャ"プロセスを停止する
    もし Wakameのモックファイル"./features/test_files/41_run_instances_1_virtual_servers.json"を"./features/test_files/run_instances.json"にコピーする
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    もし "仮想サーバ名"に"run_1_virtual_server"と入力する
    かつ "物理サーバ名"に"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"に"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "起動サーバ数"に1を選択する
    かつ "説明"に"仮想サーバを1台起動テストの説明"と入力する
    かつ "起動"ボタンをクリックする
    ならば tengine_console のログに以下の文言が表示されること
    """
    Tama::Controllers::TamaTestController#run_instances("virtual_server_image_uuid_01", 1, 1, [], nil, "", nil, "virtual_server_spec_uuid_01", nil, nil, "physical_server_uuid_01", nil)
    """
    ならば "仮想サーバ起動結果"画面が表示されること
    かつ  "仮想サーバ起動結果"画面に以下の表示があること
    virtual_server_uuid_91
    もし "一覧に戻る"ボタンを押下する
    ならば "仮想サーバ一覧"画面が表示されていること

    # 仮想サーバを5台起動
    もし Wakameのモックファイル"./features/test_files/42_run_instances_5_virtual_servers.json"を"./features/test_files/run_instances.json"にコピーする
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    もし "仮想サーバ名"に"run_5_virtual_servers"と入力する
    かつ "物理サーバ名"に"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"に"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_02"を選択する
    かつ "起動サーバ数"に5を選択する
    かつ "説明"に"仮想サーバを5台起動テストの説明"と入力する
    かつ "起動"ボタンをクリックする
    ならば tengine_console のログに以下の文言が表示されること
    """
    Tama::Controllers::TamaTestController#run_instances("virtual_server_image_uuid_01", 5, 5, [], nil, "", nil, "virtual_server_spec_uuid_02", nil, nil, "physical_server_uuid_01", nil)
    """
    ならば "仮想サーバ起動結果"ダイアログが表示されること
    かつ  "仮想サーバ起動結果"ダイアログに以下の表示があること
    virtual_server_uuid_92
    virtual_server_uuid_93
    virtual_server_uuid_94
    virtual_server_uuid_95
    virtual_server_uuid_96
    もし "一覧に戻る"ボタンを押下する
    ならば "仮想サーバ一覧"画面が表示されていること

    # 起動後の画面状態を確認
    もし Wakameのモックファイル"./features/test_files/12_describe_instances_after_run_instances.json"を"./features/test_files/describe_instances.json"にコピーする
    もし "Tengineリソースウォッチャ"プロセスを起動する
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_1_virtual_server001 |virtual_server_uuid_91|仮想サーバを1台起動テストの説明|private_ip_address: 192.168.2.91 <br>nw-data: 192.168.2.91 <br>nw-outside: 172.16.0.91 <br>nw-data_2: 192.168.3.91 <br>nw-outside_2: 172.16.1.91 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_5_virtual_servers001|virtual_server_uuid_92|仮想サーバを5台起動テストの説明|private_ip_address: 192.168.2.92 <br>nw-data: 192.168.2.92 <br>nw-outside: 172.16.0.92 <br>nw-data_2: 192.168.3.92 <br>nw-outside_2: 172.16.1.92 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|
    |                       |run_5_virtual_servers002|virtual_server_uuid_93|仮想サーバを5台起動テストの説明|private_ip_address: 192.168.2.93 <br>nw-data: 192.168.2.93 <br>nw-outside: 172.16.0.93 <br>nw-data_2: 192.168.3.93 <br>nw-outside_2: 172.16.1.93 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|
    |                       |run_5_virtual_servers003|virtual_server_uuid_94|仮想サーバを5台起動テストの説明|private_ip_address: 192.168.2.94 <br>nw-data: 192.168.2.94 <br>nw-outside: 172.16.0.94 <br>nw-data_2: 192.168.3.94 <br>nw-outside_2: 172.16.1.94 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|
    |                       |run_5_virtual_servers004|virtual_server_uuid_95|仮想サーバを5台起動テストの説明|private_ip_address: 192.168.2.95 <br>nw-data: 192.168.2.95 <br>nw-outside: 172.16.0.95 <br>nw-data_2: 192.168.3.95 <br>nw-outside_2: 172.16.1.95 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|
    |                       |run_5_virtual_servers005|virtual_server_uuid_96|仮想サーバを5台起動テストの説明|private_ip_address: 192.168.2.96 <br>nw-data: 192.168.2.96 <br>nw-outside: 172.16.0.96 <br>nw-data_2: 192.168.3.96 <br>nw-outside_2: 172.16.1.96 |running|virtual_server_image_uuid_01|virtual_server_spec_uuid_02|
    |physical_server_name_02|仮想サーバは起動していません。|||||||
    |physical_server_name_03|仮想サーバは起動していません。|||||||
    |physical_server_name_04|仮想サーバは起動していません。|||||||
    |physical_server_name_05|仮想サーバは起動していません。|||||||
    |physical_server_name_06|仮想サーバは起動していません。|||||||
    |physical_server_name_07|仮想サーバは起動していません。|||||||
    |physical_server_name_08|仮想サーバは起動していません。|||||||
    |physical_server_name_09|仮想サーバは起動していません。|||||||
    |physical_server_name_10|仮想サーバは起動していません。|||||||

    # 起動イベントの確認
    もし"イベント一覧"画面を表示する
    ならば "種別名"に"Tengine::Resource::VirtualServer.updated.tengine_resource_watchd"のイベントが6件表示されていること

    # 起動可能数の確認
    # physical_server_uuid_01 CPU:100, メモリ:100000
    # virtual_server_spec_uuid_03 CPU:5, メモリ:1
    # virtual_server_spec_uuid_04 CPU:1, メモリ:5000
    # physical_server_uuid_01 内で起動中の仮想サーバの合計 CPU:(1*1)+(2*5)=11, メモリ:(256*1)+(512*5)=2816
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_03"を選択する
    # CPU (100 - 11) / 5 = 17
    ならば "起動可能数"に"17"と表示されること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_04"を選択する
    # メモリ (100000 - 2816) / 1500 = 64
    ならば "起動可能数"に"64"と表示されること
    もし "キャンセル"ボタンをクリックする
    ならば "仮想サーバ一覧"画面が表示されていること

  @manual
  @07_02_04
  シナリオ: [正常系]アプリケーション運用者は重複する仮想サーバ名で仮想サーバの起動を試みる
    # このシナリオは以下のシナリオを事前に実施している想定です
    #   シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面から仮想サーバの起動を行う
    # 上記シナリオを実施せずにこのシナリオのみを行う場合はシナリオ内にある【注意】を参照ください

    #
    # 仮想サーバ名に重複があった場合の確認
    # ・関連するストーリー
    #   [「仮想サーバ起動」画面でバリデーションに引っかかった場合、エラー画面が出力されてしまう]
    #     https://www.pivotaltracker.com/story/show/21749503
    #   [仮想サーバの起動を行った際、重複する名前を設定した際にバリデーションでエラーになるが、仮想サーバが起動してしまう]
    #     https://www.pivotaltracker.com/story/show/21750925
    #
    # 「仮想サーバ起動」画面から仮想サーバを起動する際に、001から連番を振られるがすでに存在する仮想サーバ名と重複があった場合、以下の文言を表示する
    # 「仮想サーバ名 はすでに使用されています」
    #
    # また、バリデーションエラーが発生した際にはサーバ仮想基盤に起動要求は投げない
    #
    # 複数台の仮想サーバの起動を行おうをした際、一つでも仮想サーバ名の重複が起こる場合は、起動要求を送信しない
    #

    もし モックファイル"01_describe_host_nodes_10_physical_servers.json"を"describe_host_nodes.json"にコピーする
    かつ モックファイル"21_describe_images_5_virtual_server_images.json"を"describe_images.json"にコピーする
    かつ モックファイル"31_describe_instance_specs_4_virtual_server_specs.json"を"describe_instance_specs.json"にコピーする
    かつ モックファイル"15_describe_instances_validation_run_instances.json"を"describe_instances.json"にコピーする
    もし "Tengineリソースウォッチャ"プロセスを起動する

    #
    # 【注意】
    # 以下のシナリオを実施していない場合、一覧の仮想サーバ名がテスト内容とは異なります
    #   シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面から仮想サーバの起動を行う
    # その場合、「仮想サーバ編集」画面から、仮想サーバ名を変更してください。
    #
    もし "仮想サーバ一覧画面"を表示する
    ならば "仮想サーバ一覧画面"を表示していること
    かつ 以下の仮想サーバの一覧が表示されること
    |物理サーバ名|仮想サーバ名|プロバイダによるID|
    |physical_server_name_01|run_1_virtual_server001 |virtual_server_uuid_91|
    |                       |run_5_virtual_servers003|virtual_server_uuid_94|
    |                       |run_5_virtual_servers004|virtual_server_uuid_95|
    |                       |run_5_virtual_servers005|virtual_server_uuid_96|
    |physical_server_name_02|仮想サーバは起動していません。| |
    |physical_server_name_03|仮想サーバは起動していません。| |
    |physical_server_name_04|仮想サーバは起動していません。| |
    |physical_server_name_05|仮想サーバは起動していません。| |
    |physical_server_name_06|仮想サーバは起動していません。| |
    |physical_server_name_07|仮想サーバは起動していません。| |
    |physical_server_name_08|仮想サーバは起動していません。| |
    |physical_server_name_09|仮想サーバは起動していません。| |
    |physical_server_name_10|仮想サーバは起動していません。| |

    もし "Tengineリソースウォッチャ"プロセスを停止する

    #
    # 起動可能数のチェック
    #
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動画面"を表示していること
    もし "仮想サーバタイプ"から"virtual_server_spec_uuid_03"を選択する
    # CPU (100 - 5) / 5 = 19
    ならば "起動可能数"に"19"と表示されること

    # 起動可能数より多い起動サーバ数を指定
    もし 以下の項目を入力する
    |仮想サーバ名       |run_many_virtual_servers|
    |起動サーバ数       |100|
    かつ "物理サーバ名"から"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"から"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"から"virtual_server_spec_uuid_03"を選択する
    かつ "起動"ボタンをクリックする
    ならば "仮想サーバ起動画面"を表示していること
    かつ "起動サーバ数 は19以下の値にしてください"と表示されていること

    # マイナス値の起動サーバ数を指定
    もし 以下の項目を入力する
    |仮想サーバ名       |run_many_virtual_servers|
    |起動サーバ数       |-1|
    かつ "物理サーバ名"から"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"から"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"から"virtual_server_spec_uuid_03"を選択する
    かつ "起動"ボタンをクリックする
    ならば "仮想サーバ起動画面"を表示していること
    かつ "起動サーバ数 は0より大きい値にしてください"と表示されていること

    #
    # 重複した仮想サーバ名で仮想サーバを1台起動
    #

    # 本来であれば不要だが、Wakameにリクエストが飛ばない事を確認するためにも別のaws_idが帰ってくるモックファイルを準備する
    # aws_id: virtual_server_uuid_97 を返すモックファイル
    もし モックファイル"43_run_instances_1_virtual_servers_other_aws_id.json"を"run_instances.json"にコピーする

    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動画面"を表示していること

    # すでに存在している「run_1_virtual_server001」と仮想サーバ名を重複させる
    もし 以下の項目を入力する
    |仮想サーバ名       |run_1_virtual_server|
    |起動サーバ数       |1|
    |説明              |仮想サーバを1台起動テストの説明|
    かつ "物理サーバ名"から"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"から"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"から"virtual_server_spec_uuid_01"を選択する
    かつ "起動"ボタンをクリックする

    # 動的に連番が振られる「run_1_virtual_server001」が重複するためにバリデーションチェックに引っかかる
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "run_1_virtual_server001は既に登録されています"と表示されていること
    # サーバ仮想基盤に起動要求が送信されていないことを確認する
    かつ tengine_console のログに以下の文言が表示されないこと # 起動リクエストを送信していないことを確認する
    """
    Tama::Controllers::TamaTestController#run_instances("virtual_server_image_uuid_01", 1, 1, [], nil, "", nil, "virtual_server_spec_uuid_01", nil, nil, "physical_server_uuid_01", nil)
    """

    #
    # 複数台の仮想サーバを起動する際、一部の仮想サーバ名が重複する
    #

    # 本来であれば不要だが、Wakameにリクエストが飛ばない事を確認するためにも別のaws_idが帰ってくるモックファイルを準備する
    # aws_id: virtual_server_uuid_98 〜 virtual_server_uuid_102 を返すモックファイル
    もし モックファイル"44_run_instances_5_virtual_servers_other_aws_id.json"を"run_instances.json"にコピーする

    # すでに存在している「run_5_virtual_servers003」と仮想サーバ名を重複させる
    もし 以下の項目を入力する
    |仮想サーバ名       |run_5_virtual_servers|
    |起動サーバ数       |5|
    |説明              |仮想サーバを5台起動テストの説明|
    かつ "物理サーバ名"から"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"から"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"から"virtual_server_spec_uuid_02"を選択する
    かつ "起動"ボタンをクリックする

    # 動的に連番が振られる「run_5_virtual_servers003, run_5_virtual_servers004, run_5_virtual_servers005」が重複するためにバリデーションチェックに引っかかる
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバ名 に指定されたrun_5_virtual_servers003,run_5_virtual_servers004,run_5_virtual_servers005は既に登録されています"と表示されていること
    # サーバ仮想基盤に起動要求が送信されていないことを確認する
    かつ tengine_console のログに以下の文言が表示されないこと # 起動リクエストを送信していないことを確認する
    """
    Tama::Controllers::TamaTestController#run_instances("virtual_server_image_uuid_01", 5, 5, [], nil, "", nil, "virtual_server_spec_uuid_02", nil, nil, "physical_server_uuid_01", nil)
    """

    # 仮想サーバ一覧を確認して、仮想サーバのプロバイダによるIDが変わっていないことを確認する
    もし "仮想サーバ一覧画面"を表示する
    ならば "仮想サーバ一覧画面"を表示していること
    かつ 以下の仮想サーバの一覧が表示されること
    |物理サーバ名|仮想サーバ名|プロバイダによるID|
    |physical_server_name_01|run_1_virtual_server001 |virtual_server_uuid_91|
    |                       |run_5_virtual_servers003|virtual_server_uuid_94|
    |                       |run_5_virtual_servers004|virtual_server_uuid_95|
    |                       |run_5_virtual_servers005|virtual_server_uuid_96|
    |physical_server_name_02|仮想サーバは起動していません。| |
    |physical_server_name_03|仮想サーバは起動していません。| |
    |physical_server_name_04|仮想サーバは起動していません。| |
    |physical_server_name_05|仮想サーバは起動していません。| |
    |physical_server_name_06|仮想サーバは起動していません。| |
    |physical_server_name_07|仮想サーバは起動していません。| |
    |physical_server_name_08|仮想サーバは起動していません。| |
    |physical_server_name_09|仮想サーバは起動していません。| |
    |physical_server_name_10|仮想サーバは起動していません。| |

  @manual
  @07_02_05
  シナリオ: [正常系]アプリケーション運用者は仮想サーバ起動起動後すぐにあらたな仮想サーバの起動を試みる
    #
    # 仮想サーバ名に重複があった場合の確認
    # ・関連するストーリー
    #   [仮想サーバ起動後、すぐに再度仮想サーバを起動しようとするとエラーとなってしまう]
    #     https://www.pivotaltracker.com/story/show/22714561
    #
    # 「仮想サーバ起動」画面から仮想サーバの起動後、すぐに「仮想サーバ起動」画面を表示しようとするとサーバエラーになる
    #

    # 物理サーバが10件のファイル
    もし Wakameのモックファイル"./features/test_files/01_describe_host_nodes_10_physical_servers.json"を"./features/test_files/describe_host_nodes.json"にコピーする
    # 仮想サーバが10件のファイル
    かつ Wakameのモックファイル"./features/test_files/10_describe_instances_0_virtual_servers.json"を"./features/test_files/describe_instances.json"にコピーする
    # 仮想サーバイメージが5件のファイル
    かつ Wakameのモックファイル"./features/test_files/21_describe_images_5_virtual_server_images.json"を"./features/test_files/describe_images.json"にコピーする
    # 仮想サーバタイプが4件のファイル
    かつ Wakameのモックファイル"./features/test_files/31_describe_instance_specs_4_virtual_server_specs.json"を"./features/test_files/describe_instance_specs.json"にコピーする
    かつ "Tengineリソースウォッチャ"プロセスを起動する
    #  > tengine_resource_watchd
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    |物理サーバ名           |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
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

    # Tengineリソースウォッチャを停止した状態で仮想サーバの起動処理を複数回実行する
    もし "Tengineリソースウォッチャ"プロセスを停止する

    # 仮想サーバを1台起動
    もし Wakameのモックファイル"./features/test_files/41_run_instances_1_virtual_servers.json"を"./features/test_files/run_instances.json"にコピーする
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    もし "仮想サーバ名"に"run_1_virtual_server"と入力する
    かつ "物理サーバ名"に"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"に"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "起動サーバ数"に1を選択する
    かつ "説明"に"仮想サーバを1台起動テストの説明"と入力する
    かつ "起動"ボタンをクリックする
    ならば tengine_console のログに以下の文言が表示されること
    """
    Tama::Controllers::TamaTestController#run_instances("virtual_server_image_uuid_01", 1, 1, [], nil, "", nil, "virtual_server_spec_uuid_01", nil, nil, "physical_server_uuid_01", nil)
    """
    ならば "仮想サーバ起動結果"画面が表示されること
    かつ  "仮想サーバ起動結果"画面に以下の表示があること
    """
    virtual_server_uuid_91
    """
    もし "一覧に戻る"ボタンを押下する
    ならば "仮想サーバ一覧"画面が表示されていること

    # さらに仮想サーバを1台起動
    #  [仮想サーバ起動後、すぐに再度仮想サーバを起動しようとするとエラーとなってしまう]の対応前は、ここで「仮想サーバ起動」画面を表示しようとするとサーバエラーになります
    もし Wakameのモックファイル"./features/test_files/43_run_instances_1_virtual_servers_other_aws_id.json"を"./features/test_files/run_instances.json"にコピーする
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    もし "仮想サーバ名"に"run_1_virtual_server_again"と入力する
    かつ "物理サーバ名"に"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"に"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "起動サーバ数"に1を選択する
    かつ "説明"に"仮想サーバを1台起動テストの説明"と入力する
    かつ "起動"ボタンをクリックする
    ならば tengine_console のログに以下の文言が表示されること
    """
    Tama::Controllers::TamaTestController#run_instances("virtual_server_image_uuid_01", 1, 1, [], nil, "", nil, "virtual_server_spec_uuid_01", nil, nil, "physical_server_uuid_01", nil)
    """
    ならば "仮想サーバ起動結果"画面が表示されること
    かつ  "仮想サーバ起動結果"画面に以下の表示があること
    """
    virtual_server_uuid_97
    """
    もし "一覧に戻る"ボタンを押下する
    ならば "仮想サーバ一覧"画面が表示されていること
