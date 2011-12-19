#language:ja
機能: アプリケーション運用者が仮想サーバを起動する(wakame)
  分散ジョブを実行するために
  アプリケーション運用者
  は仮想サーバを起動したい

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
  シナリオ: [正常系]アプリケーション運用者は仮想サーバ一覧画面から仮想サーバの起動を行う
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # 物理サーバ名は実際の環境に応じて読み替えてください
    # また、環境によってはすでに仮想サーバが起動しています
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|仮想サーバは起動していません。|||||||

    # 起動可能数の確認
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    ならば "起動可能数"を確認する # 後に実行する仮想サーバ起動の後に起動可能数が増加することを確認します

    # 仮想サーバを3台起動
    もし "仮想サーバ名"に"run_3_virtual_servers"と入力する
    かつ "物理サーバ名"に"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"に"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "起動サーバ数"に3を選択する
    かつ "説明"に"仮想サーバを3台起動テストの説明"と入力する
    かつ "起動"ボタンをクリックする
    ならば tengine_console のログに以下の文言が表示されること
    """
    Tama::Controllers::TamaTestController#run_instances("virtual_server_image_uuid_01", 3, 3, [], nil, "", nil, "virtual_server_spec_uuid_01", nil, nil, "physical_server_uuid_01", nil)
    """
    ならば "仮想サーバ起動結果"画面が表示されること
    かつ  "仮想サーバ起動結果"画面に以下の表示があること
    virtual_server_uuid_01
    virtual_server_uuid_02
    virtual_server_uuid_03
    もし "閉じる"ボタンを押下する
    ならば "仮想サーバ一覧"画面が表示されていること

    # 起動後の画面状態を確認
    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # ステータスがrunningになるまで時間がかかります(環境によって異なります)
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_3_virtual_servers001|virtual_server_uuid_01|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.1|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers002|virtual_server_uuid_02|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.2|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|
    |                       |run_3_virtual_servers003|virtual_server_uuid_03|仮想サーバを3台起動テストの説明|private_ip_address: 192.168.1.3|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

    # 起動イベントの確認
    もし"イベント一覧"画面を表示する
    ならば "種別名"に"Tengine::Resource::VirtualServer.created.tengine_resource_watchd"のイベントが3件表示されていること

    # 起動可能数の確認
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    ならば "起動可能数"が起動前の数値から"-3"された値が表示されること

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
    |physical_server_name_01|run_3_virtual_servers001|virtual_server_uuid_01|
    |                       |run_3_virtual_servers002|virtual_server_uuid_02|
    |                       |run_3_virtual_servers003|virtual_server_uuid_03|

    # 起動可能数より多い起動サーバ数を指定
    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動画面"を表示していること

    もし 以下の項目を入力する
    |仮想サーバ名       |run_many_virtual_servers|
    |起動サーバ数       |<起動可能数より多い数値>|
    かつ "物理サーバ名"から"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"から"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"から"virtual_server_spec_uuid_01"を選択する
    かつ "起動"ボタンをクリックする
    ならば "仮想サーバ起動画面"を表示していること
    かつ "起動サーバ数 は<起動可能数>以下の値にしてください"と表示されていること

    # マイナス値の起動サーバ数を指定
    もし 以下の項目を入力する
    |仮想サーバ名       |run_minus_virtual_servers|
    |起動サーバ数       |-1|
    かつ "物理サーバ名"から"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"から"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"から"virtual_server_spec_uuid_01"を選択する
    かつ "起動"ボタンをクリックする
    ならば "仮想サーバ起動画面"を表示していること
    かつ "起動サーバ数 は0より大きい値にしてください"と表示されていること

    #
    # 重複した仮想サーバ名で仮想サーバを起動
    #
    # すでに存在している「run_3_virtual_servers001」と仮想サーバ名を重複させる
    もし 以下の項目を入力する
    |仮想サーバ名       |run_3_virtual_servers|
    |起動サーバ数       |3|
    かつ "物理サーバ名"から"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"から"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"から"virtual_server_spec_uuid_01"を選択する
    かつ "起動"ボタンをクリックする

    # 動的に連番が振られる「run_3_virtual_servers001, run_3_virtual_servers002, run_3_virtual_servers003」が重複するためにバリデーションチェックに引っかかる
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバ名に指定されたrun_3_virtual_servers001,run_3_virtual_servers002,run_3_virtual_servers003は既に登録されています"と表示されていること
    # サーバ仮想基盤に起動要求が送信されていないことを確認する
    かつ tengine_console のログに以下の文言が表示されないこと # 起動リクエストを送信していないことを確認する
    """
    Tama::Controllers::TamaTestController#run_instances("virtual_server_image_uuid_01", 3, 3, [], nil, "", nil, "virtual_server_spec_uuid_01", nil, nil, "physical_server_uuid_01", nil)
    """

    # 仮想サーバ一覧を確認して、仮想サーバのプロバイダによるIDが変わっていないことを確認する
    もし "仮想サーバ一覧画面"を表示する
    ならば "仮想サーバ一覧画面"を表示していること
    かつ 以下の仮想サーバの一覧が表示されること
    |物理サーバ名|仮想サーバ名|プロバイダによるID|
    |physical_server_name_01|run_3_virtual_servers001|virtual_server_uuid_01|
    |                       |run_3_virtual_servers002|virtual_server_uuid_02|
    |                       |run_3_virtual_servers003|virtual_server_uuid_03|
