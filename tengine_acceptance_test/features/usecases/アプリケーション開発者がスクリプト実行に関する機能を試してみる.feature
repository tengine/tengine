#language:ja
機能: アプリケーション開発者がスクリプト実行に関する機能を試してみる

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

  # ./usecases/job/dsl/01_04_01_permission_denied_script.rb
  #  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1046", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   # このジョブネット定義では、tengine_job_permission_denied_test.sh の実行権限がないこと想定しています。
  #   # 作成にあたっては、tengine_job_test.sh コピーし、実行権限を削除してください。
  #   job("job1", "$HOME/tengine_job_permission_denied_test.sh 0 job1")
  # end
  #  -------------------
  @01_04_01
  シナリオ: [異常系]スクリプトに実行権限がない_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_04_01_permission_denied_script.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1046"を実行する
    かつ ジョブネット"jobnet1046"が完了することを確認する
    
    ならば ジョブネット"/jobnet1046" のステータスが異常終了であること
    かつ ジョブ"/jobnet1046/job1" のステータスが異常終了であること


  # ./usecases/job/dsl/01_04_02_no_such_script.rb
  #  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1047", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   # このジョブネット定義では、tengine_job_no_such_script_test.sh は、存在しないことを想定しています。
  #   job("job1", "$HOME/tengine_job_no_such_script_test.sh 0 job1")
  # end
  #  -------------------
  @01_04_02
  シナリオ: [異常系]スクリプトが存在しない_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/./usecases/job/dsl/01_04_02_no_such_script.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1047"を実行する
    かつ ジョブネット"jobnet1047"が完了することを確認する
    
    ならば ジョブネット"/jobnet1047" のステータスが異常終了であること
    かつ ジョブ"/jobnet1047/job1" のステータスが異常終了であること



  # ./usecases/job/dsl/01_04_03_jobnet_script_env.rb
  #  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1048", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   jobnet("jobnet1048_2") do
  #     job("job1", "$HOME/tengine_job_env_test.sh 0 job1")
  #   end
  #   finally do
  #     job("jobnet1048_finally","$HOME/tengine_job_env_test.sh 0 jobnet1048_finally")
  #   end
  # end
  #  -------------------
  @01_04_03
  @manual
  シナリオ: [正常系]シェルスクリプトに環境変数が渡される_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_04_03_jobnet_script_env.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1048"を実行する
    かつ ジョブネット"jobnet1048"が完了することを確認する
    
    ならば ジョブネット"/jobnet1048" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1048/jobnet1048_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1048/jobnet1048_2/job1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1048/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1048/finally/jobnet1048_finally" のステータスが正常終了であること

    ########################################
    # シェルスクリプトに渡された環境変数をログファイルから確認
    ########################################
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    かつ "スクリプトログ"の"job1"の"MM_ACTUAL_JOB_ID"の値を"job1_MM_ACTUAL_JOB_ID"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値を"job1_MM_ACTUAL_JOB_ANCESTOR_IDS"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を"job1_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_ACTUAL_JOB_NAME_PATH"の値を"job1_MM_ACTUAL_JOB_NAME_PATH"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値を"job1_MM_ACTUAL_JOB_SECURITY_TOKEN"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_TEMPLATE_JOB_ID"の値を"job1_MM_TEMPLATE_JOB_ID"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を"job1_MM_TEMPLATE_JOB_ANCESTOR_IDS"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_SCHEDULE_ID"の値を"MM_SCHEDULE_ID"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_SCHEDULE_ESTIMATED_TIME"の値を"job1_MM_SCHEDULE_ESTIMATED_TIME"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_SCHEDULE_ESTIMATED_END"の値を"job1_MM_SCHEDULE_ESTIMATED_END"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_SERVER_NAME"の値を"job1_"MM_SERVER_NAME"と呼ぶ

    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_ACTUAL_JOB_ID"の値を"finally_job_MM_ACTUAL_JOB_ID"と呼ぶ
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値を"finally_job_MM_ACTUAL_JOB_ANCESTOR_IDS"と呼ぶ
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を"finally_job_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"と呼ぶ
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_ACTUAL_JOB_NAME_PATH"の値を"finally_job_MM_ACTUAL_JOB_NAME_PATH"と呼ぶ
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値を"finally_job_MM_ACTUAL_JOB_SECURITY_TOKEN"と呼ぶ
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_TEMPLATE_JOB_ID"の値を"finally_job_MM_TEMPLATE_JOB_ID"と呼ぶ
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を"finally_job_MM_TEMPLATE_JOB_ANCESTOR_IDS"と呼ぶ
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_SCHEDULE_ID"の値が"#{MM_SCHEDULE_ID}"と同じであること
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_SCHEDULE_ESTIMATED_TIME"の値を"finally_job_MM_SCHEDULE_ESTIMATED_TIME"と呼ぶ
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_SCHEDULE_ESTIMATED_END"の値を"finally_job_MM_SCHEDULE_ESTIMATED_END"と呼ぶ
    かつ "スクリプトログ"の"jobnet1048_finally"の"MM_SERVER_NAME"の値を"finally_job_"MM_SERVER_NAME"と呼ぶ

		
    ならば "job1_MM_ACTUAL_JOB_ANCESTOR_IDS"の値に";"が一つだけあること
    かつ "job1_MM_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた1つ目の文字列を"jobnet1048_ACTUAL_JOB_ID"と呼ぶ
    かつ "job1_MM_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた2つ目の文字列を"jobnet1048_2_ACTUAL_JOB_ID"と呼ぶ
    かつ "job1_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値に";"が一つだけあること
    かつ "job1_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた1つ目の文字列が"jobnet1048_ACTUAL_JOB_ID"と同じであること
    かつ "job1_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた2つ目の文字列が"jobnet1048_2_ACTUAL_JOB_ID"と同じであること
    かつ "job1_MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1048/jobnet1048_2/job1"であること
    かつ "job1_MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "job1_MM_TEMPLATE_JOB_ANCESTOR_IDS"の値に;が一つだけあること
    かつ "job1_MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を;で区切ってできた1つ目の文字列を"jobnet1048_TEMPLATE_JOB_ID"と呼ぶ
    かつ "job1_MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を;で区切ってできた2つ目の文字列を"jobnet1048_2_TEMPLATE_JOB_ID"と呼ぶ
    かつ "job1_MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "job1_MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "job1_MM_SERVER_NAME"の値が"test_server1"であること

    かつ "finally_job_MM_ACTUAL_JOB_ANCESTOR_IDS"の値に";"が一つだけあること
    かつ "finally_job_MM_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた1つ目の文字列が"jobnet1048_ACTUAL_JOB_ID"と同じであること
    かつ "finally_job_MM_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた2つ目の文字列を"finally_ACTUAL_JOB_ID"と呼ぶ
    かつ "finally_job_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値に";"が一つだけあること
    かつ "finally_job_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた1つ目の文字列が"jobnet1048_ACTUAL_JOB_ID"と同じであること
    かつ "finally_job_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた2つ目の文字列が"finally_ACTUAL_JOB_ID"と同じであること
    かつ "finally_job_MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1048/finally/jobnet1048_finally"であること
    かつ "finally_job_MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "finally_job_MM_TEMPLATE_JOB_ANCESTOR_IDS"の値に;が一つだけあること
    かつ "finally_job_MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を;で区切ってできた1つ目の文字列が"jobnet1048_TEMPLATE_JOB_ID"と同じであること
    かつ "finally_job_MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を;で区切ってできた2つ目の文字列を"finally_TEMPLATE_JOB_ID"と呼ぶ
    かつ "finally_job_MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "finally_job_MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "finally_job_MM_SERVER_NAME"の値が"test_server1"であること
		
    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                           |ジョブネット名  |説明          |操作     |
    |#{jobnet1048_TEMPLATE_JOB_ID}|jobnet1048    |jobnet1048    |表示 実行|

    もし "jobnet1048"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                |名称               |表示名            |実行するスクリプト                     |接続サーバ名        |認証情報名|次のジョブ|
    |#{jobnet1048_2_TEMPLATE_JOB_ID}   |jobnet1048_2      |jobnet1048_2      |                                    |test_server1      |test_credential1|
    |#{job1_MM_TEMPLATE_JOB_ID}        |job1              |job1              |$HOME/tengine_job_env_test.sh 0 job1|test_server1      |test_credential1|
    |#{finally_TEMPLATE_JOB_ID}        |finally           |finally           |                                    |test_server1      |test_credential1|
    |#{finally_job_MM_TEMPLATE_JOB_ID} |jobnet1048_finally|jobnet1048_finally|$HOME/tengine_job_env_test.sh 0 job1|test_server1      |test_credential1|
   
  
    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                         |ジョブネット名  |説明       |ステータス    |操作      |
    |#{jobnet1048_ACTUAL_JOB_ID}|jobnet1048    |jobnet1048|正常終了      |監視 再実行|

    もし "jobnet1048"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                             |ジョブ名            |説明                |実行スクリプト                        |接続サーバ名  |認証情報名       |ステータス    |次のジョブ  |操作  |
    |#{jobnet1048_2_ACTUAL_JOB_ID}  |jobnet1048_2       |jobnet1048_2       |                                    |test_server1|test_credential1|正常終了      |          |再実行|
    |#{job1_ACTUAL_JOB_ID}          |job1               |job1               |$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1|正常終了      |          |再実行|
    |#{finally_ACTUAL_JOB_ID}       |finally            |finally            |                                    |test_server1|test_credential1|正常終了      |          |再実行|
    |#{finally_job_MM_ACTUAL_JOB_ID}|jobnet1048_finally |jobnet1048_finally |$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1|正常終了      |          |再実行|

    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1048"の"表示"リンクをクリックする
    ならば ならば URLの最後の"/"から末尾までの文字列との#{MM_SCHEDULE_ID}が同じであること

  # ./usecases/job/dsl/01_04_04_jobnet_script_env_failure.rb
  #  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1048_failure", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   jobnet("jobnet1048_2") do
  #     job("job1", "exit 1")
  #   end
  #   finally do
  #     job("jobnet1048_finally","$HOME/tengine_job_env_test.sh 0 jobnet1048_finally")
  #   end
  # end
  #  -------------------
  @01_04_04
  @manual
  シナリオ: [正常系]シェルスクリプトに環境変数が渡される_を試してみる_ジョブが失敗した場合
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_04_04_jobnet_script_env_failure.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし 予定実行時間を10分に設定して、ジョブネット"jobnet1048_failure"を実行する
    かつ ジョブネット"jobnet1048_failure"が完了することを確認する
    
    ならば ジョブネット"/jobnet1048_failure" のステータスがエラー終了であること
    かつ ジョブネット"/jobnet1048_failure/jobnet1048_2" のステータスがエラー終了であること
    かつ ジョブ"/jobnet1048_failure/jobnet1048_2/job1" のステータスがエラー終了であること
    かつ ジョブネット"/jobnet1048_failure/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1048_failure/finally/jobnet1048_finally" のステータスが正常終了であること

    ########################################
    # シェルスクリプトに渡された環境変数をログファイルから確認
    ########################################
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_ID"の値を確認する
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値を確認する
    かつ "スクリプトログ"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を確認する
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_NAME_PATH"の値を確認する
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値を確認する
    かつ "スクリプトログ"の"MM_TEMPLATE_JOB_ID"の値を確認する
    かつ "スクリプトログ"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を確認する
    かつ "スクリプトログ"の"MM_SCHEDULE_ID"の値を確認する
    かつ "スクリプトログ"の"MM_SCHEDULE_ESTIMATED_TIME"の値を確認する
    かつ "スクリプトログ"の"MM_SCHEDULE_ESTIMATED_END"の値を確認する
# TODO 未実装。対応時期の確認が必要。
    かつ "スクリプトログ"の"MM_FAILED_JOB_ID"の値を確認する
# TODO 未実装。対応時期の確認が必要。
    かつ "スクリプトログ"の"MM_FAILED_JOB_ANCESTOR_IDS"を確認する
    かつ "スクリプトログ"の"MM_SERVER_NAME"を確認する
  
    ならば "jobnet1048_finally"の"MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1048_failure/finally/jobnet1048_finally"であること
    かつ "jobnet1048_finally"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "jobnet1048_finally"の"MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "jobnet1048_finally"の"MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "jobnet1048_finally"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値が";"で区切られていること
		かつ "jobnet1048_finally"の"MM_SERVER_NAME"の値が"test_server1"であること
		
    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                |ジョブネット名    |説明                  |操作     |
    |jobnet1048_failureのテンプレートID|jobnet1048_failure|説明jobnet1048_failure|表示 実行|

    もし "jobnet1048_failure"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                |ジョブネット名|名称        |表示名                              |実行するスクリプト|接続サーバ名    |認証情報名|次のジョブ|
    |jobnet1048_2のテンプレートID      |jobnet1048_2  |jobnet1048_2|                                    |test_server1      |test_credential1|
    |job1のテンプレートID              |job1          |job1        |exit 1                              |test_server1      |test_credential1|
    |finallyのテンプレートID           |finally       |finally     |                                    |test_server1      |test_credential1|
    |jobnet1048_finallyのテンプレートID|finally       |finally     |$HOME/tengine_job_env_test.sh 0 job1|test_server1      |test_credential1|
   
   
    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                          |ジョブネット名    |説明              |ステータス|操作       |
    |jobnet1048_failureの実行時ID|jobnet1048_failure|jobnet1048_failure|正常終了      |監視 再実行|

    もし "jobnet1048"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                          |ジョブ名    |説明        |実行スクリプト                      |接続サーバ名|認証情報名      |ステータス|次のジョブ|操作  |
    |jobnet1048_2の実行時ID      |jobnet1048_2|jobnet1048_2|                                    |test_server1|test_credential1|正常終了      |          |再実行|
    |job1の実行時ID              |job1        |job1        |exit 1                              |test_server1|test_credential1|正常終了      |          |再実行|
    |finallyの実行時ID           |finally     |finally     |                                    |test_server1|test_credential1|正常終了      |          |再実行|
    |jobnet1048_finallyの実行時ID|finally     |finally     |$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1|正常終了      |          |再実行|

    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1048_failure"の"表示"リンクをクリックする
    ならば URLのexecutionのIDと"スクリプトログ"のMM_SCHEDULE_IDが一緒であること


  # ./usecases/job/dsl/01_04_05_jobnet_script_env_finally_failure.rb
  #  -------------------
  # require 'tengine_job'
  #
  # jobnet("jobnet1048_failure", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   jobnet("jobnet1048_2") do
  #     job("job1", "exit 1"
  #   end
  #   finally do
  #     jobnet("jobnet1048_2_finally_jobnet") do
  #       job("jobnet1048_finally","exit 1")
  #       finally do
  #         job("jobnet1048_finally_in_finally","$HOME/tengine_job_env_test.sh 0 jobnet1048_finally_in_finally")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @01_04_05
  @manual
  シナリオ: [正常系]シェルスクリプトに環境変数が渡される_を試してみる_finallyのジョブが失敗した場合
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_04_05_jobnet_script_env_finally_failure.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし 予定実行時間を10分に設定して、ジョブネット"jobnet1048_finally_failure"を実行する
    かつ ジョブネット"jobnet1048_failure"が完了することを確認する
    
    ならば ジョブネット"/jobnet1048finally__failure" のステータスがエラー終了であること
    かつ ジョブネット"/jobnet1048_finally_failure/jobnet1048_2" のステータスがエラー終了であること
    かつ ジョブ"/jobnet1048_finally_failure/jobnet1048_2/job1" のステータスがエラー終了であること
    かつ ジョブネット"/jobnet1048_finally_failure/finally" のステータスがエラー終了であること
    かつ ジョブ"/jobnet1048_finally_failure/finally/jobnet1048_2_finally_jobnet/jobnet1048_finally" のステータスがエラー終了であること
    かつ ジョブ"/jobnet1048_finally_failure/finally/jobnet1048_2_finally_jobnet/finally/jobnet1048_finally_in_finally" のステータスが正常終了であること

    ########################################
    # シェルスクリプトに渡された環境変数をログファイルから確認
    ########################################
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_ID"の値を確認する
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値を確認する
    かつ "スクリプトログ"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を確認する
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_NAME_PATH"の値を確認する
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値を確認する
    かつ "スクリプトログ"の"MM_TEMPLATE_JOB_ID"の値を確認する
    かつ "スクリプトログ"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を確認する
    かつ "スクリプトログ"の"MM_SCHEDULE_ID"の値を確認する
    かつ "スクリプトログ"の"MM_SCHEDULE_ESTIMATED_TIME"の値を確認する
    かつ "スクリプトログ"の"MM_SCHEDULE_ESTIMATED_END"の値を確認する
# TODO 未実装。対応時期の確認が必要。
    かつ "スクリプトログ"の"MM_FAILED_JOB_ID"の値を確認する
# TODO 未実装。対応時期の確認が必要。
    かつ "スクリプトログ"の"MM_FAILED_JOB_ANCESTOR_IDS"を確認する
    かつ "スクリプトログ"の"MM_SERVER_NAME"を確認する
		
    ならば "jobnet1048_finally_in_finally"の"MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1048_finally_failure/finally/jobnet1048_2_finally_jobnet/finally/jobnet1048_finally_in_finally"であること
    かつ "jobnet1048_finally_in_finally"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "jobnet1048_finally_in_finally"の"MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "jobnet1048_finally_in_finally"の"MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "jobnet1048_finally_in_finally"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally_in_finally"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally_in_finally"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値が";"で区切られていること
		かつ "jobnet1048_finally_in_finally"の"MM_SERVER_NAME"の値が"test_server1"であること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                        |ジョブネット名            |説明                          |操作     |
    |jobnet1048_finally_failureのテンプレートID|jobnet1048_finally_failure|説明jobnet1048_finally_failure|表示 実行|

    もし "jobnet1048_finally_failure"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                                 |ジョブネット名               |名称                         |表示名                                                       |実行するスクリプト|接続サーバ名    |認証情報名|次のジョブ|
    |jobnet1048_2のテンプレートID                       |jobnet1048_2                 |jobnet1048_2                 |                                                             |test_server1      |test_credential1|
    |job1のテンプレートID                               |job1                         |job1                         |exit 1                                                       |test_server1      |test_credential1|
    |jobnet1048_finally_failure/finallyのテンプレートID |finally                      |finally                      |                                                             |test_server1      |test_credential1|
    |jobnet1048_2_finally_jobnetのテンプレートID        |jobnet1048_2_finally_jobnet  |jobnet1048_2_finally_jobnet  |                                                             |test_server1      |test_credential1|
    |jobnet1048_finallyのテンプレートID                 |jobnet1048_finally           |jobnet1048_finally           |exit 1                                                       |test_server1      |test_credential1|
    |jobnet1048_2_finally_jobnet/finallyのテンプレートID|finally                      |finally                      |                                                             |test_server1      |test_credential1|
    |jobnet1048_finally_in_finallyのテンプレートID      |jobnet1048_finally_in_finally|jobnet1048_finally_in_finally|$HOME/tengine_job_env_test.sh 0 jobnet1048_finally_in_finally|test_server1      |test_credential1|

    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                  |ジョブネット名            |説明                      |ステータス|操作       |
    |jobnet1048_finally_failureの実行時ID|jobnet1048_finally_failure|jobnet1048_finally_failure|正常終了      |監視 再実行|

    もし "jobnet1048_finally_failure"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                           |ジョブ名                     |説明                         |実行スクリプト                                               |接続サーバ名|認証情報名      |ステータス|次のジョブ|操作  |
    |jobnet1048_2の実行時ID                       |jobnet1048_2                 |jobnet1048_2                 |                                                             |test_server1|test_credential1|正常終了      |          |再実行|
    |job1の実行時ID                               |job1                         |job1                         |exit 1                                                       |test_server1|test_credential1|正常終了      |          |再実行|
    |jobnet1048_finally_failure/finallyの実行時ID |finally                      |finally                      |                                                             |test_server1|test_credential1|正常終了      |          |再実行|
    |jobnet1048_2_finally_jobnetの実行時ID        |jobnet1048_2_finally_jobnet  |jobnet1048_2_finally_jobnet  |                                                             |test_server1|test_credential1|正常終了      |          |再実行|
    |jobnet1048_finallyの実行時ID                 |jobnet1048_finally           |jobnet1048_finally           |exit 1                                                       |test_server1|test_credential1|正常終了      |          |再実行|
    |jobnet1048_2_finally_jobnet/finallyの実行時ID|finally                      |finally                      |                                                             |test_server1|test_credential1|正常終了      |          |再実行|
    |jobnet1048_finally_in_finallyの実行時ID      |jobnet1048_finally_in_finally|jobnet1048_finally_in_finally|$HOME/tengine_job_env_test.sh 0 jobnet1048_finally_in_finally|test_server1|test_credential1|正常終了      |          |再実行|


    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1048_finally_failure"の"表示"リンクをクリックする
    ならば URLのexecutionのIDと"スクリプトログ"のMM_SCHEDULE_IDが一緒であること


  # ./usecases/job/dsl/01_04_06_expantion_script_env.rb
  #  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1049", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   expansion("jobnet1049_2")
  # end
  # 
  # 
  # jobnet("jobnet1049_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_env_test.sh 0 job1")
  # end
  #  -------------------
  @01_04_06
  @manual
  シナリオ: [正常系]expantionを利用したシェルスクリプトに環境変数が渡される_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_04_06_expantion_script_env.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1049"を実行する
    かつ ジョブネット"jobnet1049"が完了することを確認する
    
    ならば ジョブネット"/jobnet1049" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1049/jobnet1049_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1049/jobnet1049_2/job1" のステータスが正常終了であること

    ########################################
    # シェルスクリプトに渡された環境変数をログファイルから確認
    ########################################
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    かつ "スクリプトログ"の"job1"の"MM_ACTUAL_JOB_ID"の値を"job1_MM_ACTUAL_JOB_ID"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値を"job1_MM_ACTUAL_JOB_ANCESTOR_IDS"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を"job1_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_ACTUAL_JOB_NAME_PATH"の値を"job1_MM_ACTUAL_JOB_NAME_PATH"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値を"job1_MM_ACTUAL_JOB_SECURITY_TOKEN"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_TEMPLATE_JOB_ID"の値を"job1_MM_TEMPLATE_JOB_ID"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を"job1_MM_TEMPLATE_JOB_ANCESTOR_IDS"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_SCHEDULE_ID"の値を"MM_SCHEDULE_ID"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_SCHEDULE_ESTIMATED_TIME"の値を"job1_MM_SCHEDULE_ESTIMATED_TIME"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_SCHEDULE_ESTIMATED_END"の値を"job1_MM_SCHEDULE_ESTIMATED_END"と呼ぶ
    かつ "スクリプトログ"の"job1"の"MM_SERVER_NAME"の値を"job1_"MM_SERVER_NAME"と呼ぶ
# TODO 未実装。対応時期の確認が必要。
#    かつ "スクリプトログ"の"MM_FAILED_JOB_ID"の値を確認する
# TODO 未実装。対応時期の確認が必要。
#    かつ "スクリプトログ"の"MM_FAILED_JOB_ANCESTOR_IDS"を確認する

    ならば "job1_MM_ACTUAL_JOB_ANCESTOR_IDS"の値に";"がないこと
    かつ "job1_MM_ACTUAL_JOB_ANCESTOR_IDS"の値を"jobnet1049_2_ACTUAL_JOB_ID"と呼ぶ
    かつ "job1_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値に";"が一つだけあること
    かつ "job1_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた1つ目の文字列を"jobnet1049_ACTUAL_JOB_ID"と呼ぶ
    かつ "job1_MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を;で区切ってできた2つ目の文字列が"jobnet1049_2_ACTUAL_JOB_ID"と同じであること
    かつ "job1_MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1049/jobnet1049_2/job1"であること
    かつ "job1_MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "job1_MM_TEMPLATE_JOB_ANCESTOR_IDS"の値に;がないこと
    かつ "job1_MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を"jobnet1049_2_TEMPLATE_JOB_ID"と呼ぶ
    かつ "job1_MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "job1_MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "job1_MM_SERVER_NAME"の値が"test_server1"であること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    もし "jobnet1049"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                             |名称           |表示名       |実行するスクリプト                    |接続サーバ名        |認証情報名       |次のジョブ|
    |#{jobnet1049_2_TEMPLATE_JOB_ID}|jobnet1049_2  |jobnet1049_2|                                    |test_server1      |test_credential1|         |

    もし 名称の"jobnet1049_2"をクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                             |名称           |表示名       |実行するスクリプト                    |接続サーバ名        |認証情報名       |次のジョブ|
    |#{job1_MM_TEMPLATE_JOB_ID}     |job1          |job1        |$HOME/tengine_job_env_test.sh 0 job1|test_server1      |test_credential1|         |
    
   
    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                         |ジョブネット名  |説明       |ステータス    |操作      |
    |#{jobnet1049_ACTUAL_JOB_ID}|jobnet1049    |jobnet1049|正常終了      |監視 再実行|

    もし "jobnet1049"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                           |ジョブ名     |説明         |実行スクリプト                        |接続サーバ名  |認証情報名       |ステータス    |次のジョブ |操作  |
    |#{jobnet1049_2_ACTUAL_JOB_ID}|jobnet1049_2|jobnet1049_2|                                    |test_server1|test_credential1|正常終了      |          |再実行|
    |#{job1_MM_ACTUAL_JOB_ID}     |  job1      |job1        |$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1|正常終了      |          |再実行|

    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1049"の"表示"リンクをクリックする
    ならば ならば URLの最後の"/"から末尾までの文字列との#{MM_SCHEDULE_ID}が同じであること


  # ./usecases/job/dsl/01_04_07_expantion_script_env_failure.rb
  #  -------------------
  #  require 'tengine_job'
  #  
  #  jobnet("jobnet1049_failure", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #    auto_sequence
  #    expansion("jobnet1049_2")
  #    finally do
  #      job("jobnet1049_finally","$HOME/tengine_job_env_test.sh 0 jobnet1049_finally")
  #    end
  #  end
  #  
  #  
  #  jobnet("jobnet1049_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #    auto_sequence
  #    job("job1", "exit 1")
  #  end
  #  -------------------
  @01_04_07
  @manual
  シナリオ: [正常系]expantion_failureを利用したシェルスクリプトに環境変数が渡される_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_04_07_expantion_script_env_failure.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし 予定実行時間を10分に設定して、ジョブネット"jobnet1049"を実行する
    かつ ジョブネット"jobnet1049"がエラー終了することを確認する
    
    ならば ジョブネット"/jobnet1049_failure" のステータスがエラー終了であること
    かつ ジョブネット"/jobnet1049_failure/jobnet1049_2" のステータスがエラー終了であること
    かつ ジョブ"/jobnet1049_failure/jobnet1049_2/job1" のステータスがエラー終了であること
    かつ ジョブ"/jobnet1049_failure/finally/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1049_failure/finally/jobnet1049_finally" のステータスが正常終了であること

    ########################################
    # シェルスクリプトに渡された環境変数をログファイルから確認
    ########################################
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_ID"の値を確認する
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値を確認する
    かつ "スクリプトログ"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値を確認する
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_NAME_PATH"の値を確認する
    かつ "スクリプトログ"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値を確認する
    かつ "スクリプトログ"の"MM_TEMPLATE_JOB_ID"の値を確認する
    かつ "スクリプトログ"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値を確認する
    かつ "スクリプトログ"の"MM_SCHEDULE_ID"の値を確認する
    かつ "スクリプトログ"の"MM_SCHEDULE_ESTIMATED_TIME"の値を確認する
    かつ "スクリプトログ"の"MM_SCHEDULE_ESTIMATED_END"の値を確認する
# TODO 未実装。対応時期の確認が必要。
    かつ "スクリプトログ"の"MM_FAILED_JOB_ID"の値を確認する
# TODO 未実装。対応時期の確認が必要。
    かつ "スクリプトログ"の"MM_FAILED_JOB_ANCESTOR_IDS"を確認する
    かつ "スクリプトログ"の"MM_SERVER_NAME"を確認する
		
    ならば "jobnet1049_finally"の"MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1049_failure/jobnet1049_2/finally/jobnet1049_finally"であること
    かつ "jobnet1049_finally"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "jobnet1049_finally"の"MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "jobnet1049_finally"の"MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "jobnet1049_finally"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1049_finally"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1049_finally"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値が";"で区切られていること
		かつ "jobnet1049_finally"の"MM_SERVER_NAME"の値が"test_server1"であること
		
    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                |ジョブネット名    |説明                  |操作     |
    |jobnet1049_failureのテンプレートID|jobnet1049_failure|説明jobnet1049_failure|表示 実行|

    もし "jobnet1049_failure"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                |ジョブネット名    |名称              |表示名                              |実行するスクリプト|接続サーバ名    |認証情報名|次のジョブ|
    |jobnet1049_2のテンプレートID      |jobnet1049_2      |jobnet1049_2      |                                    |test_server1      |test_credential1|
    |job1のテンプレートID              |job1              |job1              |exit 1                              |test_server1      |test_credential1|
    |finallyのテンプレートID           |finally           |finally           |                                    |test_server1      |test_credential1|
    |jobnet1049_finallyのテンプレートID|jobnet1049_finally|jobnet1049_finally|$HOME/tengine_job_env_test.sh 0 job1|test_server1      |test_credential1|

    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                          |ジョブネット名    |説明              |ステータス|操作       |
    |jobnet1049_failureの実行時ID|jobnet1049_failure|jobnet1049_failure|エラー終了|監視 再実行|

    もし "jobnet1049_failure"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID                                        |ジョブ名          |説明              |実行スクリプト                      |接続サーバ名|認証情報名      |ステータス|次のジョブ|操作  |
    |jobnet1049_2の実行時ID                    |jobnet1049_2      |jobnet1049_2      |                                    |test_server1|test_credential1|エラー終了   |          |再実行|
    |job1の実行時ID                            |job1              |job1              |exit 1                              |test_server1|test_credential1|エラー終了   |          |再実行|
    |jobnet1049_failure/finallyのテンプレートID|finally           |finally           |                                    |test_server1|test_credential1|正常終了      |          |再実行|
    |jobnet1049_finallyのテンプレートID        |jobnet1049_finally|jobnet1049_finally|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1|正常終了      |          |再実行|
    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1049_failure"の"表示"リンクをクリックする
    ならば URLのexecutionのIDと"スクリプトログ"のMM_SCHEDULE_IDが一緒であること


  # ./usecases/job/dsl/01_04_08_preparation_check.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # require 'tengine_job'
  # require "socket" 
  # 
  # jobnet("rjn1054", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1", "$HOME/preparation.sh", :to => "j2", :preparation => proc{ "export IP_MESSAGE=#{IPSocket::getaddress(Socket::gethostname)}_j1"})
  #   job("j2", "$HOME/preparation.sh", :to => "j3")
  #   job("j3", "$HOME/preparation.sh", :to => "j4", :preparation => proc{ "export IP_MESSAGE=#{IPSocket::getaddress(Socket::gethostname)}_j3"})
  #   job("j4", "$HOME/preparation.sh")
  # end
  #  -------------------
  @success
  @01_04_08
  シナリオ: [正常系]ジョブの動的な事前実行コマンドを求める:preparationオプションを試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_04_08_preparation_check.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"rjn1054"を実行する
    かつ ジョブネット"rjn1054"が完了することを確認する
    
    ならば ジョブネット"/rjn1054" のステータスが正常終了であること
    かつ ジョブ"/rjn1054/j1" のステータスが正常終了であること
    かつ ジョブ"/rjn1054/j2" のステータスが正常終了であること
    かつ ジョブ"/rjn1054/j3" のステータスが正常終了であること
    かつ ジョブ"/rjn1054/j4" のステータスが正常終了であること

    もし IPアドレスを確認するために"ifconfig"コマンドを実行する

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "preparation /rjn1054/j1 #{IP}_j1"と"スクリプトログ"に出力されていること
    かつ "preparation /rjn1054/j2"と"スクリプトログ"に出力されており、"preparation /rjn1054/j1 #{IP}_j1"の後であること
    ならば "preparation /rjn1054/j3 #{IP}_j3"と"スクリプトログ"に出力されており、"preparation /rjn1054/j2"の後であること
    かつ ""preparation /rjn1054/j4"と"スクリプトログ"に出力されており、"preparation /rjn1054/j3 #{IP}_j3"の後であること

