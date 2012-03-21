#language:ja
機能: アプリケーション開発者がジョブネットをデプロイしてみる

  背景:
    前提 "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している
    かつ テンプレートジョブが1件も登録されていない
    かつ 実行ジョブが1件もない
    かつ イベントが1件もない
    かつ 仮想サーバがインスタンス識別子:"test_server1"で登録されていること
    かつ 認証情報が名称:"test_credential1"で登録されている
    かつ イベントキューにメッセージが1件もない


  # ./usecases/job/dsl/01_05_01_jobnet_directory
  #
  @manual
  @01_05_01
  シナリオ: [正常系]ディレクトリ構成の読込_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_05_01_jobnet_directory -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    ならば ルートのカテゴリの子に"1060_jobnet_directory"というカテゴリが存在すること
    かつ "1060_jobnet_directory"のカテゴリの子に"jobnetgroup_x"というカテゴリが存在すること
    かつ "1060_jobnet_directory"のカテゴリの子に"jobnetgroup_y"というカテゴリが存在すること
    かつ "1060_jobnet_directory"のカテゴリの子に"jobnetgroup_z"というカテゴリが存在しないこと

    もし "全体"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1060_a  |jobnet1060_a|
    |jobnet1060_b  |jobnet1060_b|
    |jobnet1060_c  |jobnet1060_c|
    |jobnet1060_d  |jobnet1060_d|
    |jobnet1060_e  |jobnet1060_e|
    |jobnet1060_f  |jobnet1060_f|
    |jobnet1060_g  |jobnet1060_g|
    |jobnet1060_h  |jobnet1060_h|
    |jobnet1060_i  |jobnet1060_i|

    もし "1060_jobnet_directory"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1060_a  |jobnet1060_a|
    |jobnet1060_b  |jobnet1060_b|
    |jobnet1060_c  |jobnet1060_c|
    |jobnet1060_d  |jobnet1060_d|
    |jobnet1060_e  |jobnet1060_e|
    |jobnet1060_f  |jobnet1060_f|
    |jobnet1060_g  |jobnet1060_g|
    |jobnet1060_h  |jobnet1060_h|
    |jobnet1060_i  |jobnet1060_i|

    もし "jobnetgroup_x"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1060_d  |jobnet1060_d|
    |jobnet1060_e  |jobnet1060_e|
    |jobnet1060_f  |jobnet1060_f|

    もし "jobnetgroup_y"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1060_g  |jobnet1060_g|
    |jobnet1060_h  |jobnet1060_h|
    |jobnet1060_i  |jobnet1060_i|

  
  # ./usecases/job/dsl/01_05_02_dictionary_yml
  @manual
  @01_05_02
  シナリオ: [正常系]dictionary.ymlの内容が正しく表示される_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_05_02_dictionary_yml -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    ならば ルートのカテゴリの子に"1061_dictionary_yml"というカテゴリが存在すること
    かつ "ジョブネットグループ1061"のカテゴリの子に"ジョブネットグループX"というカテゴリが存在すること
    かつ "ジョブネットグループ1061"のカテゴリの子に"ジョブネットグループY"というカテゴリが存在すること

    もし "全体"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1061_a  |jobnet1061_a|
    |jobnet1061_b  |jobnet1061_b|
    |jobnet1061_c  |jobnet1061_c|
    |jobnet1061_d  |jobnet1061_d|
    |jobnet1061_e  |jobnet1061_e|
    |jobnet1061_f  |jobnet1061_f|
    |jobnet1061_g  |jobnet1061_g|
    |jobnet1061_h  |jobnet1061_h|
    |jobnet1061_i  |jobnet1061_i|

    もし "1061_dictionary_yml"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1061_a  |jobnet1061_a|
    |jobnet1061_b  |jobnet1061_b|
    |jobnet1061_c  |jobnet1061_c|
    |jobnet1061_d  |jobnet1061_d|
    |jobnet1061_e  |jobnet1061_e|
    |jobnet1061_f  |jobnet1061_f|
    |jobnet1061_g  |jobnet1061_g|
    |jobnet1061_h  |jobnet1061_h|
    |jobnet1061_i  |jobnet1061_i|

    もし "ジョブネットグループX"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1061_d  |jobnet1061_d|
    |jobnet1061_e  |jobnet1061_e|
    |jobnet1061_f  |jobnet1061_f|

    もし "ジョブネットグループY"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1061_g  |jobnet1061_g|
    |jobnet1061_h  |jobnet1061_h|
    |jobnet1061_i  |jobnet1061_i|

  # ./usecases/job/dsl/01_05_03_dictionary_yml
  @manual
  @01_05_03
  シナリオ: [正常系]dictionary.ymlの内容が正しく表示される_を試してみる_読み込むディレクトリー自体がdictionary.ymlでカテゴリー名が指定されている
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_05_03_dictionary_yml -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    ならば ルートのカテゴリの子に"ジョブネットグループ1061"というカテゴリが存在すること
    かつ "ジョブネットグループ1061"のカテゴリの子に"ジョブネットグループX"というカテゴリが存在すること
    かつ "ジョブネットグループ1061"のカテゴリの子に"ジョブネットグループY"というカテゴリが存在すること

    もし "全体"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1061_a  |jobnet1061_a|
    |jobnet1061_b  |jobnet1061_b|
    |jobnet1061_c  |jobnet1061_c|
    |jobnet1061_d  |jobnet1061_d|
    |jobnet1061_e  |jobnet1061_e|
    |jobnet1061_f  |jobnet1061_f|
    |jobnet1061_g  |jobnet1061_g|
    |jobnet1061_h  |jobnet1061_h|
    |jobnet1061_i  |jobnet1061_i|

    もし "ジョブネットグループ1061"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1061_a  |jobnet1061_a|
    |jobnet1061_b  |jobnet1061_b|
    |jobnet1061_c  |jobnet1061_c|
    |jobnet1061_d  |jobnet1061_d|
    |jobnet1061_e  |jobnet1061_e|
    |jobnet1061_f  |jobnet1061_f|
    |jobnet1061_g  |jobnet1061_g|
    |jobnet1061_h  |jobnet1061_h|
    |jobnet1061_i  |jobnet1061_i|

    もし "ジョブネットグループX"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1061_d  |jobnet1061_d|
    |jobnet1061_e  |jobnet1061_e|
    |jobnet1061_f  |jobnet1061_f|

    もし "ジョブネットグループY"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1061_g  |jobnet1061_g|
    |jobnet1061_h  |jobnet1061_h|
    |jobnet1061_i  |jobnet1061_i|

  # ./usecases/job/dsl/01_05_04_incorrect_dictionary_yml
  @manual
  @01_05_04
  シナリオ: [正常系]dictionary.ymlの内容が間違っている_を試してみる
  
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_05_04_incorrect_dictionary_yml -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    ならば ルートのカテゴリの子に"1062_incorrect_dictionary_yml"というカテゴリが存在すること
    かつ "1062_incorrect_dictionary_yml"のカテゴリの子に"ジョブネットグループX"というカテゴリが存在すること
    かつ "1062_incorrect_dictionary_yml"のカテゴリの子に"ジョブネットグループY"というカテゴリが存在すること
    かつ "1062_incorrect_dictionary_yml"のカテゴリの子に"jobnetgroup_y"というカテゴリが存在すること
 
    もし "全体"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1062_a  |jobnet1062_a|
    |jobnet1062_b  |jobnet1062_b|
    |jobnet1062_c  |jobnet1062_c|
    |jobnet1062_d  |jobnet1062_d|
    |jobnet1062_e  |jobnet1062_e|
    |jobnet1062_f  |jobnet1062_f|
    |jobnet1062_g  |jobnet1062_g|
    |jobnet1062_h  |jobnet1062_h|
    |jobnet1062_i  |jobnet1062_i|
    |jobnet1062_j  |jobnet1062_j|
    |jobnet1062_k  |jobnet1062_k|

   もし "1062_incorrect_dictionary_yml"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1062_a  |jobnet1062_a|
    |jobnet1062_b  |jobnet1062_b|
    |jobnet1062_c  |jobnet1062_c|
    |jobnet1062_d  |jobnet1062_d|
    |jobnet1062_e  |jobnet1062_e|
    |jobnet1062_f  |jobnet1062_f|
    |jobnet1062_g  |jobnet1062_g|
    |jobnet1062_h  |jobnet1062_h|
    |jobnet1062_i  |jobnet1062_i|
    |jobnet1062_j  |jobnet1062_j|
    |jobnet1062_k  |jobnet1062_k|

   もし "ジョブネットグループX"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1062_d  |jobnet1062_d|
    |jobnet1062_e  |jobnet1062_e|
    |jobnet1062_f  |jobnet1062_f|

   もし "jobnetgroup_y"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1062_g  |jobnet1062_g|
    |jobnet1062_h  |jobnet1062_h|
    |jobnet1062_i  |jobnet1062_i|

   もし "ジョブネットグループY"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明        |
    |jobnet1062_j  |jobnet1062_j|
    |jobnet1062_k  |jobnet1062_k|


