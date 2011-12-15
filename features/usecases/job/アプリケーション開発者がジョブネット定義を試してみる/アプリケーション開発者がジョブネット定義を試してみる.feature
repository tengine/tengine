#language:ja
機能: アプリケーション開発者がジョブネット定義を試してみる

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

  @success
  @1000
  シナリオ: [正常系]1000_1つのジョブが含まれるジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1001"を実行する
    かつ ジョブネット"jobnet1001"が完了することを確認する
    
    ならば ジョブネット"/jobnet1001" のステータスが正常終了であること
    かつ ジョブ"/jobnet1001/job1" のステータスが正常終了であること

    # -----------------------------
    # tengine_job_test job1 start
    # tengine_job_test job1 finish
    # -----------------------------
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること

    
  # ./usecases/job/dsl/1001_one_job_in_jobnet.rb
  # -------------------
  # require 'tengine_job'
  #
  # jobnet("jobnet1001", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "~/tengine_job_test.sh 0 'job1'")
  # end
  # -------------------
  #
  @success
  @1001
  シナリオ: [正常系]1001_1つのジョブが含まれるジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1001"を実行する
    かつ ジョブネット"jobnet1001"が完了することを確認する
    
    ならば ジョブネット"/jobnet1001" のステータスが正常終了であること
    かつ ジョブ"/jobnet1001/job1" のステータスが正常終了であること

    # -----------------------------
    # tengine_job_test job1 start
    # tengine_job_test job1 finish
    # -----------------------------
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること

    ###############################
    # エレメントのフェーズ遷移の確認
    ###############################

    # Execution
    もし 実行ジョブ"jobnet1001"のExecutionを"execution"と呼ぶことにする
    # /jobnet1001 => jobnet1001
    かつ 実行ジョブ"jobnet1001"のルートジョブネット"/jobnet1001"を"root_jobnet"と呼ぶことにする
    # next!start@/jobnet1001 => e1
    かつ 実行ジョブ"jobnet1001"のエッジ"next!start@/jobnet1001"を"e1"と呼ぶことにする
    # /jobnet1001/job1 => job1
    もし 実行ジョブ"jobnet1001"のジョブ"/jobnet1001/job1"を"job1"と呼ぶことにする
    # next!/jobnet1001/job1 => e2
    かつ 実行ジョブ"jobnet1001"のエッジ"next!/jobnet1001/job1"を"e2"と呼ぶことにする

    # receive event "start.execution.job.tengine"
    ならば "Tengineコアプロセス"のアプリケーションログに"#{execution} initialized -> ready"とジョブのフェーズが変更した情報が出力されていること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{execution} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{execution} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} initialized -> ready"とジョブのフェーズが変更した情報が出力されており、"#{execution} ready -> starting"の後であること

    # receive event "start.jobnet.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{execution} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} ready -> starting"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e1} active -> transmitting"とジョブのフェーズが変更した情報が出力されており、"#{execution} starting -> running"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{job1} initialized -> ready"とジョブのフェーズが変更した情報が出力されており、"#{e1} active -> transmitting"の後であること

    # receive event "start.job.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e1} transmitting -> transmitted"とジョブのフェーズが変更した情報が出力されており、"#{job1} initialized -> ready"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{job1} ready -> starting"とジョブのフェーズが変更した情報が出力されており、"#{e1} transmitting -> transmitted"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{job1} ready -> starting"の後であること
    # SSH接続
    かつ "Tengineコアプロセス"のアプリケーションログに"#{job1} starting -> running"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} starting -> running"の後であること

    # receive event "success.process.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{job1} running -> success"とジョブのフェーズが変更した情報が出力されており、"#{job1} starting -> running"の後であること

    # receive event "success.job.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e2} active -> transmitting"とジョブのフェーズが変更した情報が出力されており、"#{job1} running -> success"の後であること
    かつ "Tengineコアプロセス"のアプリケーションログに"#{e2} transmitting -> transmitted"とジョブのフェーズが変更した情報が出力されており、"#{e2} active -> transmitting"の後であること

    # tengine_core fire "success.jobnet.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{root_jobnet} running -> success"とジョブのフェーズが変更した情報が出力されており、"#{e2} transmitting -> transmitted"の後であること

    # tengine_core fire "success.jobnet.job.tengine"
    かつ "Tengineコアプロセス"のアプリケーションログに"#{execution} running -> success"とジョブのフェーズが変更した情報が出力されており、"#{root_jobnet} running -> success"の後であること


    ###############################
    # ジョブ実行サーバのログを確認
    ###############################
    
    もし 仮想サーバ"test_server1"のファイル"~/log/tengine_job_test.log"を開く。このファイルを"tengine_job_runログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"tengine_job_runログ"に出力されていること
    かつ "tengine_job_test job1 finish"と"tengine_job_runログ"に出力されており、"tengine_job_test job1 start"の後であること
    
    

  # ./usecases/job/dsl/1002_series_jobs_in_jobnet.rb
  #  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1002", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "echo 'job1'", :to => "job2")
  #   job("job2", "echo 'job2'")
  # end
  # -------------------
  #
  @success
  @1002
  シナリオ: [正常系]1002_複数のジョブ(直列)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1002_series_jobs_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1002"を実行する
    かつ ジョブネット"jobnet1002"が完了することを確認する
    
    ならば ジョブネット"/jobnet1002" のステータスが正常終了であること
    かつ ジョブ"/jobnet1002/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1002/job2" のステータスが正常終了であること

    # -----------------------------
    # tengine_job_test job1 start
    # tengine_job_test job1 finish
    # tengine_job_test job2 start
    # tengine_job_test job2 finish
    # -----------------------------
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/1003_parallel_jobs_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1003", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1","job2")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  # end
  #  -------------------
  @success
  @1003
  シナリオ: [正常系]1003_複数のジョブ(並列)が含まれるジョブネット
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1003_parallel_jobs_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1003"を実行する
    かつ ジョブネット"jobnet1003"が完了することを確認する
    
    ならば ジョブネット"/jobnet1003" のステータスが正常終了であること
    かつ ジョブ"/jobnet1003/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1003/job2" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること
    ならば "tengine_job_test job2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"の後であること

  
  # ./usecases/job/dsl/1004_hadoop_job_in_jobnet.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1004", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "import_hdfs.sh")
  #   hadoop_job_run("hadoop_job_run1", "Hadoopジョブ1", "hadoop_job_run.sh") do
  #     hadoop_job("hadoop_job1")
  #     hadoop_job("hadoop_job2")
  #   end
  #   job("job2", "export_hdfs.sh")
  # end
  #  -------------------
  @success
  @1004
  シナリオ: [正常系]1004_hadoopジョブが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1004_hadoop_job_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1004"を実行する
    かつ ジョブネット"jobnet1004"が完了することを確認する
    
    ならば ジョブネット"/jobnet1004" のステータスが正常終了であること
    かつ ジョブ"/jobnet1004/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1004/hadoop_job_run1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1004/job2" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test import_hdfs start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test import_hdfs finish"と"スクリプトログ"に出力されており、"tengine_job_test import_hdfs start"と"tengine_job_test hadoop_job_run start"の間であること
    かつ "tengine_job_test hadoop_job_run start"と"スクリプトログ"に出力されており、"tengine_job_test import_hdfs start"と"tengine_job_test hadoop_job_run finish"の間であること
    かつ "tengine_job_test hadoop_job_run finish"と"スクリプトログ"に出力されており、"tengine_job_test hadoop_job_run start"と"tengine_job_test export_hdfs start"の間であること
    かつ "tengine_job_test export_hdfs start"と"スクリプトログ"に出力されており、"tengine_job_test hadoop_job_run finish"と"tengine_job_test export_hdfs finish"の間であること
    かつ "tengine_job_test export_hdfs finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/1005_finally_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1005", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   finally do
  #     job("jobnet1005_finally","$HOME/tengine_job_test.sh 0 jobnet1005_finally")
  #   end
  # end
  #  -------------------
  @success
  @1005
  シナリオ: [正常系]1005_finallyが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1005_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1005"を実行する
    かつ ジョブネット"jobnet1005"が完了することを確認する
    
    ならば ジョブネット"/jobnet1005" のステータスが正常終了であること
    かつ ジョブ"/jobnet1005/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1005/finally/jobnet1005_finally" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test jobnet1005_finally start"の間であること
    かつ "tengine_job_test jobnet1005_finally start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test jobnet1005_finally finish"の間であること
    かつ "tengine_job_test jobnet1005_finally finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/1006_expansion_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1006", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "jobnet1006_2")
  #   expansion("jobnet1006_2", :to => "job3")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  # jobnet("jobnet1006_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job2")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  # end
  #  -------------------
  @success
  @1006
  シナリオ: [正常系]1006_expansionが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1006_expansion_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006"を実行する
    かつ ジョブネット"jobnet1006"が完了することを確認する
    
    ならば ジョブネット"/jobnet1006" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job3" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/1006_2_expansion_in_jobnet_x2.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1006_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "jobnet1006_2_2")
  #   expansion("jobnet1006_2_2", :to => "job4")
  #   job("job4", "$HOME/tengine_job_test.sh 0 job4")
  # end
  # jobnet("jobnet1006_2_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job2")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2", :to => "jobnet1006_2_3")
  #   expansion("jobnet1006_2_3")
  # end
  # jobnet("jobnet1006_2_3", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job3")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @success
  @1006_2
  シナリオ: [正常系]expansionされたジョブネット内で更にexpansionされているジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1006_2_expansion_in_jobnet_x2.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006_2"を実行する
    かつ ジョブネット"jobnet1006_2"が完了することを確認する
    
    ならば ジョブネット"/jobnet1006_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2_2/jobnet1006_2_3/job3" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job4" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"に出力されており、"tengine_job_test job3 start"と"tengine_job_test job4 start"の間であること
    かつ "tengine_job_test job4 start"と"スクリプトログ"に出力されており、"tengine_job_test job3 finish"と"tengine_job_test job4 finish"の間であること
    かつ "tengine_job_test job4 finish"と"スクリプトログ"の末尾に出力されていること

  # ./usecases/job/dsl/1006_expansion_in_jobnet_2.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1006", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "jobnet1006_2")
  #   expansion("jobnet1006_2", :to => "job3")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  # jobnet("jobnet1006_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job2")
  #   job("job2", "exit 1")
  # end
  #  -------------------
  @manual
  @1006_3
  シナリオ: [正常系]expansionで指定するジョブネット名が、以前のtengined起動時に読み込んでいたジョブネット名と被っている場合でも同じバージョンのジョブネットが利用される
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1006_expansion_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006"を実行する
    かつ ジョブネット"jobnet1006"が完了することを確認する
    
    ならば ジョブネット"/jobnet1006" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job3" のステータスが正常終了であること

    もし "Tengineコアプロセス"の停止を行うために"tengined -k stop"というコマンドを実行する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1006_expansion_in_jobnet_2.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006"を実行する
    かつ ジョブネット"jobnet1006"がエラー終了することを確認する
    かつ job2の実行スクリプトが"exit 1"になっていること

  @manual
  @1006_4
  シナリオ: [正常系]expansionで指定するジョブネット名が、以前のtengined起動時に読み込んでいたジョブネット名と被っている場合でも同じバージョンのジョブネットが利用される_パターン2
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1006_2_expansion_in_jobnet_x2.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006_2"を実行する
    かつ ジョブネット"jobnet1006_2"が完了することを確認する
    かつ ジョブ"/jobnet1006_2/jobnet1006_2_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006_2/jobnet1006_2_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006_2/jobnet1006_2_2/jobnet1006_2_3" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006_2/jobnet1006_2_2/jobnet1006_2_3/job3" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006_2/job4" のステータスが正常終了であること

    もし "Tengineコアプロセス"の停止を行うために"tengined -k stop"というコマンドを実行する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
   
    もし テストを行うために"mv ./usecases/job/dsl/1006_2_expansion_in_jobnet_x2.rb ./usecases/job/dsl/1006_2_expansion_in_jobnet_x2.rb_tmp"というコマンドを実行する 
   
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1006_expansion_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006"を実行する
    かつ ジョブネット"jobnet1006"が完了することを確認する
    かつ ジョブ"/jobnet1006/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job3" のステータスが正常終了であること

    もし 後始末を行うために"mv ./usecases/job/dsl/1006_2_expansion_in_jobnet_x2.rb_tmp ./usecases/job/dsl/1006_2_expansion_in_jobnet_x2.rb"というコマンドを実行する 


  # ./usecases/job/dsl/1007_boot_jobs_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1007", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
  #  -------------------
  @success
  @1007
  シナリオ: [正常系]1007_boot_jobsが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1007_boot_jobs_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1007"を実行する
    かつ ジョブネット"jobnet1007"が完了することを確認する
    
    ならば ジョブネット"/jobnet1007" のステータスが正常終了であること
    かつ ジョブ"/jobnet1007/job1" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"の末尾に出力されていること
  
  # ./usecases/job/dsl/1008_auto_sequence_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1008", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @success
  @1008
  シナリオ: [正常系]1008_auto_sequenceが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1008_auto_sequence_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1008"を実行する
    かつ ジョブネット"jobnet1008"が完了することを確認する
    
    ならば ジョブネット"/jobnet1008" のステータスが正常終了であること
    かつ ジョブ"/jobnet1008/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1008/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1008/job3" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/1009_2_layer_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1009", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   jobnet("jobnet1009_2") do
  #     auto_sequence
  #     job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   end
  # end
  #  -------------------
  @success
  @1009
  シナリオ: [正常系]1009_入れ子(2階層)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1009_2_layer_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1009"を実行する
    かつ ジョブネット"jobnet1009"が完了することを確認する
    
    ならば ジョブネット"/jobnet1009" のステータスが正常終了であること
    かつ ジョブ"/jobnet1009/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1009/jobnet1009_2/job2" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/1010_3_layer_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1010", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   jobnet("jobnet1010_2") do
  #     auto_sequence
  #     job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #     jobnet("jobnet1010_3") do
  #       auto_sequence
  #       job("job3", "$HOME/tengine_job_test.sh 0 job3")
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1010
  シナリオ: [正常系]1010_入れ子(3階層)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1010_3_layer_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1010"を実行する
    かつ ジョブネット"jobnet1010"が完了することを確認する
    
    ならば ジョブネット"/jobnet1010" のステータスが正常終了であること
    かつ ジョブ"/jobnet1010/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1010/jobnet1010_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1010/jobnet1010_2/jobnet1010_3/job3" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/1011_2_layer_finally_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1011", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   finally do
  #     jobnet("jobnet1011_2") do
  #       auto_sequence
  #       job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1011
  シナリオ: [正常系]1011_入れ子(2階層)のfinallyが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1011_2_layer_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1011"を実行する
    かつ ジョブネット"jobnet1011"が完了することを確認する
    
    ならば ジョブネット"/jobnet1011" のステータスが正常終了であること
    かつ ジョブ"/jobnet1011/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1011/finally/jobnet1011_2/job2" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/1012_3_layer_finally_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1012", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   finally do
  #     jobnet("jobnet1012_2") do
  #       auto_sequence
  #       job("job2", "$HOME/tengine_job_test.sh 0 job2", :to => "jobnet1012_3")
  #       jobnet("jobnet1012_3") do
  #         auto_sequence
  #         job("job3", "$HOME/tengine_job_test.sh 0 job3")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1012
  シナリオ: [正常系]1012_入れ子(3階層)のfinallyが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1012_3_layer_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1012"を実行する
    かつ ジョブネット"jobnet1012"が完了することを確認する
    
    ならば ジョブネット"/jobnet1012" のステータスが正常終了であること
    かつ ジョブ"/jobnet1012/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1012/finally/jobnet1012_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1012/finally/jobnet1012_2/jobnet1012_3/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること

  

  # ./usecases/job/dsl/1013_3_rayer_complicated_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1013", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   jobnet("jobnet1013_2", :instance_name => "test_server2", :credential_name => "test_credential2") do
  #     auto_sequence
  #     job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #     jobnet("jobnet1013_3", :instance_name => "test_server3", :credential_name => "test_credential3") do
  #       auto_sequence
  #       job("job3", "$HOME/tengine_job_test.sh 0 job3")
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1013
  シナリオ: [正常系]1013_入れ子の中でinstanceとcredential_nameが違うジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1013_3_rayer_complicated_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する
    かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    かつ ジョブネット"jobnet1013"を実行する
    かつ ジョブネット"jobnet1013"が完了することを確認する
    
    ならば ジョブネット"/jobnet1013" のステータスが正常終了であること
    かつ ジョブ"/jobnet1013/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1013/jobnet1013_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1013/jobnet1013_2/jobnet1013_3/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ1"に出力されており、"tengine_job_test job1 start"の後であること
    
    もし 仮想サーバ"test_server2"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    ならば "tengine_job_test job2 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test job2 finish"と"スクリプトログ2"に出力されており、"tengine_job_test job2 start"の後であること

    もし 仮想サーバ"test_server3"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    ならば "tengine_job_test job3 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test job3 finish"と"スクリプトログ3"に出力されており、"tengine_job_test job3 start"の後であること

  
  # ./usecases/job/dsl/1014_3_layer_complicated_finally_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1014", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   finally do
  #     jobnet("jobnet1014_2", :instance_name => "test_server2", :credential_name => "test_credential2") do
  #       auto_sequence
  #       job("job2", "$HOME/tengine_job_test.sh 0 job2", :to => "jobnet1014_3")
  #       jobnet("jobnet1014_3", :instance_name => "test_server3", :credential_name => "test_credential3") do
  #         auto_sequence
  #         job("job3", "$HOME/tengine_job_test.sh 0 job3")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1014
  シナリオ: [正常系]1014_finallyの入れ子の中でinstanceとcredential_nameが違うジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1014_3_layer_complicated_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する
    かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    かつ ジョブネット"jobnet1014"を実行する
    かつ ジョブネット"jobnet1014"が完了することを確認する
    
    ならば ジョブネット"/jobnet1014" のステータスが正常終了であること
    かつ ジョブ"/jobnet1014/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1014/finally/jobnet1014_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1014/finally/jobnet1014_2/jobnet1014_3/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ1"に出力されており、"tengine_job_test job1 start"の後であること
    
    もし 仮想サーバ"test_server2"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    ならば "tengine_job_test job2 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test job2 finish"と"スクリプトログ2"に出力されており、"tengine_job_test job2 start"の後であること

    もし 仮想サーバ"test_server3"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    ならば "tengine_job_test job3 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test job3 finish"と"スクリプトログ3"に出力されており、"tengine_job_test job3 start"の後であること


  

  # ./usecases/job/dsl/1015_complicated_jobnet_1.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # c.f -> http://bts.tenginefw.com/trac/monkey-magic/wiki/0.9.6/function_test_additional_scenario
  # #
  # jobnet('complicated_jobnet', '複雑なジョブネット', :vm_instance_name => "test_server1",:credential_name => "test_credential1") do  
  # boot_jobs("i_jobnet1-1", "i_jobnet1-2", "i_jobnet1-3", "i_jobnet2-1", "i_jobnet2-2")  
  #   jobnet('i_jobnet1-1', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
  #       auto_sequence
  #       job("i_jobnet1-1", "$HOME/tengine_job_test.sh 5 jobnet1-1")
  #   end
  #   jobnet('i_jobnet1-2',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
  #       auto_sequence
  #       job("i_jobnet1-2", "$HOME/tengine_job_test.sh 10 jobnet1-2")
  #   end
  #   jobnet('i_jobnet1-3', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
  #       boot_jobs("i_job1-1","i_job1-2","i_job1-3","i_job2-1","i_job2-2")
  #       job("i_job1-1", "$HOME/tengine_job_test.sh 1 job1-1",:to => "i_job3")
  #       job("i_job1-2", "$HOME/tengine_job_test.sh 1 job1-2",:to => "i_job3")
  #       job("i_job1-3", "$HOME/tengine_job_test.sh 1 job1-3",:to => "i_job3")
  #       job("i_job2-1", "sleeeeeep 1",:to => "i_job2-0")
  #       job("i_job2-2", "$HOME/tengine_job_test.sh 1 job2-2",:to => "i_job2-0")
  #       job("i_job2-0", "$HOME/tengine_job_test.sh 1 job2-0",:to => "i_job3")
  #       job("i_job3", "$HOME/tengine_job_test.sh 1 job3")
  #   end
  #   jobnet('i_jobnet2-1',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet2-0") do   
  #       auto_sequence
  #       job("i_jobnet2-1", "$HOME/tengine_job_test.sh 1 jobnet2-1")
  #   end
  #   jobnet('i_jobnet2-2', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet2-0") do    
  #       auto_sequence
  #       job("i_jobnet2-2", "$HOME/tengine_job_test.sh 1 jobnet2-2")
  #   end
  #   jobnet('i_jobnet2-0',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
  #       auto_sequence
  #       job("i_jobnet2-0", "$HOME/tengine_job_test.sh 1 jobnet2-0")
  #   end
  #   jobnet('i_jobnet3',  :vm_instance_name => "test_server1",:credential_name => "test_credential1") do
  #       auto_sequence
  #       job("i_jobnet3", "$HOME/tengine_job_test.sh 1 jobnet3")
  #   end
  # end
  #  -------------------
  @success
  @1015
  シナリオ: [正常系]1015_複雑なジョブネット１_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1015_complicated_jobnet_1.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"complicated_jobnet"を実行する
    かつ ジョブネット"complicated_jobnet"が完了することを確認する。少なくとも120秒間は待つ。
    
    ならば ジョブネット"/complicated_jobnet" のステータスがエラー終了であること

    # jobnet視点
    ならば ジョブネット"/complicated_jobnet/i_jobnet1-1" のステータスが正常終了であること
      かつ ジョブ"/complicated_jobnet/i_jobnet1-1/i_jobnet1-1" のステータスが正常終了であること    
    かつ ジョブネット"/complicated_jobnet/i_jobnet1-2" のステータスが正常終了であること
      かつ ジョブ"/complicated_jobnet/i_jobnet1-2/i_jobnet1-2" のステータスが正常終了であること
    かつ ジョブネット"/complicated_jobnet/i_jobnet1-3" のステータスがエラー終了であること
      # 後述の i_jobnet1-3内のjob視点 を参照
    かつ ジョブネット"/complicated_jobnet/i_jobnet2-1" のステータスが正常終了であること
      かつ ジョブ"/complicated_jobnet/i_jobnet2-1/i_jobnet2-1" のステータスが正常終了であること   
    かつ ジョブネット"/complicated_jobnet/i_jobnet2-2" のステータスが正常終了であること
      かつ ジョブ"/complicated_jobnet/i_jobnet2-2/i_jobnet2-2" のステータスが正常終了であること   
    かつ ジョブネット"/complicated_jobnet/i_jobnet2-0" のステータスが正常終了であること
      かつ ジョブ"/complicated_jobnet/i_jobnet2-0/i_jobnet2-0" のステータスが正常終了であること   
    かつ ジョブネット"/complicated_jobnet/i_jobnet3" のステータスが初期化済であること
      かつ ジョブ"/complicated_jobnet/i_jobnet3/i_jobnet3" のステータスが初期化済であること   

    # i_jobnet1-3内のjob視点
    かつ ジョブ"/complicated_jobnet/i_jobnet1-3/i_job1-1" のステータスが正常終了であること
    かつ ジョブ"/complicated_jobnet/i_jobnet1-3/i_job1-2" のステータスが正常終了であること
    かつ ジョブ"/complicated_jobnet/i_jobnet1-3/i_job1-3" のステータスが正常終了であること
    かつ ジョブ"/complicated_jobnet/i_jobnet1-3/i_job2-1" のステータスがエラー終了であること
    かつ ジョブ"/complicated_jobnet/i_jobnet1-3/i_job2-2" のステータスが正常終了であること
    かつ ジョブ"/complicated_jobnet/i_jobnet1-3/i_job2-0" のステータスが初期化済であること
    かつ ジョブ"/complicated_jobnet/i_jobnet1-3/i_job3" のステータスが初期化済であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。

    # i_jobnet1-3 以外
    ならば "tengine_job_test jobnet1-1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test jobnet1-1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1-1 start"の後であること
    かつ "tengine_job_test jobnet1-2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test jobnet1-2 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1-2 start"の後であること
    かつ "tengine_job_test jobnet2-1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test jobnet2-1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet2-1 start"の後であること
    かつ "tengine_job_test jobnet2-2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test jobnet2-2 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet2-2 start"の後であること
    かつ "tengine_job_test jobnet2-0 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet2-1 finish"の後であること
    かつ "tengine_job_test jobnet2-0 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet2-2 finish"の後であること
    かつ "tengine_job_test jobnet2-0 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet2-0 start"の後であること
    かつ "tengine_job_test jobnet3 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test jobnet3 finish"と"スクリプトログ"に出力されていないこと

    
    # i_jobnet1-3
    かつ "tengine_job_test job1-1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1-1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1-1 start"の後であること
    かつ "tengine_job_test job1-2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1-2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1-2 start"の後であること
    かつ "tengine_job_test job1-3 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1-3 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1-3 start"の後であること
    かつ "tengine_job_failure_test job2-1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_failure_test job2-1 finish"と"スクリプトログ"に出力されており、"tengine_job_failure_test job2-1 start"の後であること
    かつ "tengine_job_test job2-2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job2-2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2-2 start"の後であること
    かつ "tengine_job_test job2-0 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test job2-0 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test job3 finish"と"スクリプトログ"に出力されていないこと
  
  # ./usecases/job/dsl/1020_hadoop_job_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1020", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   hadoop_job("hadoop_job1")
  # end
  #  -------------------
  @1020
  @bug
  シナリオ: [正常系]1020_jobnetにhadoop_jobが含まれる_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1020_hadoop_job_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E1  jobnet block contains unexpected method(hadoop_job).
    ならば "Tengineコアプロセス"の標準出力に"jobnet block contains unexpected method(hadoop_job)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/1021_job_in_hadoop_job_run.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1021", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "import_hdfs.sh")
  #   hadoop_job_run("hadoop_job_run1", "hadoop_job_run.sh") do
  #     hadoop_job("hadoop_job1")
  #     hadoop_job("hadoop_job2")
  #     job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   end
  #   job("job3", "export_hdfs.sh")
  # end
  #  -------------------
  @1021
  @bug
  シナリオ: [正常系]1021_hadoop_job_run にjobが含まれる_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1021_job_in_hadoop_job_run.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E2  hadoop_job_run block contains unexpected method(job).
    ならば "Tengineコアプロセス"の標準出力に"hadoop_job_run block contains unexpected method(job)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/1022_hadoop_job_in_finally.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1022", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   finally do
  #     hadoop_job("hadoop_job1")
  #   end
  # end
  #  -------------------
  @1022
  @bug
  シナリオ: [正常系]1022_finally にhadoop_jobが含まれる_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1022_hadoop_job_in_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E3  finally block contains unexpected method(hadoop_job).
    ならば "Tengineコアプロセス"の標準出力に"finally block contains unexpected method(hadoop_job)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/1023_finally_in_finally.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1023", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   finally do
  #     finally do
  #       job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #     end
  #   end
  # end
  #  -------------------
  @1023
  @bug
  シナリオ: [正常系]1023_finally にfinallyが含まれる_を試してみる
  
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1023_finally_in_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E4  finally block contains unexpected method(finally).
    ならば "Tengineコアプロセス"の標準出力に"finally block contains unexpected method(finally)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/1024_finally_not_last_of_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1024", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "job3")
  #   finally do
  #     job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   end
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @success  
  @1024
  シナリオ: [正常系]1024_finallyがjobnetの途中に書かれている_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1024_finally_not_last_of_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1024"を実行する
    かつ ジョブネット"jobnet1024"が完了することを確認する
    
    ならば ジョブネット"/jobnet1024" のステータスが正常終了であること
    かつ ジョブ"/jobnet1024/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1024/finally/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1024/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"に出力されており、"tengine_job_test job3 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job3 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/1025_boot_jobs_not_first_of_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1025", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "job2")
  #   boot_jobs("job1")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   finally do
  #     job("job3", "$HOME/tengine_job_test.sh 0 job3")
  #   end
  # end
  #  -------------------
  @success
  @1025
  シナリオ: [正常系]1025_boot_jobsがjobnetの途中に書かれている_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1025_boot_jobs_not_first_of_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1025"を実行する
    かつ ジョブネット"jobnet1025"が完了することを確認する
    
    ならば ジョブネット"/jobnet1025" のステータスが正常終了であること
    かつ ジョブ"/jobnet1025/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1025/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1025/finally/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/1026_auto_sequence_not_first_of_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1026", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "job2")
  #   auto_sequence
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @success
  @1026
  シナリオ: [正常系]1026_auto_sequenceがjobnetの途中に書かれている_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1026_auto_sequence_not_first_of_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1026"を実行する
    かつ ジョブネット"jobnet1026"が完了することを確認する
    
    ならば ジョブネット"/jobnet1026" のステータスが正常終了であること
    かつ ジョブ"/jobnet1026/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1026/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1026/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  
  # ./usecases/job/dsl/1027_twice_finally_in_jobnet.rb  
  #  -------------------
 # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1027", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   finally do
  #     job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   end
  #   finally do
  #     job("job3", "$HOME/tengine_job_test.sh 0 job3")
  #   end
  # end
  #  -------------------
  @1027
  シナリオ: [正常系]1027_finallyが2回書かれている_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1027_twice_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E5  finally is duplicated.
    ならば "Tengineコアプロセス"の標準出力に"finally is duplicated."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること

  

  # ./usecases/job/dsl/1028_twice_auto_sequence_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1028", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   auto_sequence
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @1028
  シナリオ: [正常系]1028_auto_sequenceが2回書かれている_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1028_twice_auto_sequence_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E6  auto_sequence is duplicated.
    ならば "Tengineコアプロセス"の標準出力に"auto_sequence is duplicated."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/1029_boot_jobs_after_auto_sequence.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1029", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @1029
  シナリオ: [正常系]1029_auto_sequenceのあとにboot_jobsが定義されている_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1029_boot_jobs_after_auto_sequence.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E10 boot_jobs or auto_sequence is duplicated.
    ならば "Tengineコアプロセス"の標準出力に"boot_jobs or auto_sequence is duplicated."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/1030_no_jobnet.rb
  #  -------------------
  # require 'tengine_job'
  # 
  #  -------------------
  @success
  @1030
  シナリオ: [正常系]1030_jobnetが1つもない_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1030_no_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する

    ならば "Tengineコアプロセス"の状態が"稼働中"であること


  # ./usecases/job/dsl/1031_no_job_or_hadoop_job_run_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1031", :instance_name => "test_server1", :credential_name => "test_credential1") do
  # end
  #  -------------------
  @1031
  シナリオ: [正常系]1031_job/hadoop_job_runが1つもない_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1031_no_job_or_hadoop_job_run_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1031"を実行する
    かつ ジョブネット"jobnet1031"が完了することを確認する
    
    ならば ジョブネット"/jobnet1031" のステータスが正常終了であること

    
  # ./usecases/job/dsl/1032_error_on_execute.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1032", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   }
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @1032
  シナリオ: [正常系]1032_DSLにシンタックスエラーがある_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1032_error_on_execute.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E7  syntax error. #(e.message}¥n#{e.backtrace.join("\n")}
    ならば "Tengineコアプロセス"の標準出力に"syntax error, unexpected '}', expecting keyword_end (SyntaxError)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること
    

  # ./usecases/job/dsl/1033_execute_on_error.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1033", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   hoge
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @1033
  シナリオ: [正常系]1033_実行時にエラーとなる_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1033_execute_on_error.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1033"を実行する
    かつ ジョブネット"jobnet1033"が完了することを確認する
    
    ならば ジョブネット"/jobnet1033" のステータスが正常終了であること
    かつ ジョブ"/jobnet1033/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1033/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1033/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/1034_unexpected_option_for_jobnet.rb
  #  -------------------
  #
  # require 'tengine_job'
  # 
  # jobnet("jobnet1034", :instance_name => "test_server1", :credential_name => "test_credential1" ,:hoge => "hoge") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
  #  -------------------
  @1034
  シナリオ: [正常系]1034_jobnetのoptionに不正な値が指定されている_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1034_unexpected_option_for_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E8  #{value} is invalid option.
    ならば "Tengineコアプロセス"の標準出力に"hoge is invalid option."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること
  

  # ./usecases/job/dsl/1035_unexpected_option_for_job.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1035", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :hoge => "hoge")
  # end
  #  -------------------
  @1035
  シナリオ: [正常系]1035_jobのoptionに不正な値が指定されている_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1035_unexpected_option_for_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E8  #{value} is invalid option.
    ならば "Tengineコアプロセス"の標準出力に"hoge is invalid option."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること

  # ./usecases/job/dsl/1036_unexpected_option_for_hadoop_job_run.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1036", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "import_hdfs.sh")
  #   hadoop_job_run("hadoop_job_run1","hadoop_job_run.sh", :hoge => "hoge") do
  #     hadoop_job("hadoop_job1")
  #     hadoop_job("hadoop_job2")
  #   end
  #   job("job2", "export_hdfs.sh")
  # end
  #  -------------------
  @1036
  シナリオ: [正常系]1036_hadoop_job_runのoptionに不正な値が指定されている_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1036_unexpected_option_for_hadoop_job_run.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E8  #{value} is invalid option.
    ならば "Tengineコアプロセス"の標準出力に"hoge is invalid option."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること

  # ./usecases/job/dsl/1037_unexpected_option_for_expansion.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1037", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   expansion("jobnet1006_2", :to => "job3", :hoge=> "hoge")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job2")
  # end
  # jobnet("jobnet1006_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job2")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  # end
  #  -------------------
  @1037
  シナリオ: [正常系]1037_expansionのoptionに不正な値が指定されている_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1037_unexpected_option_for_expansion.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E8  #{value} is invalid option.
    ならば "Tengineコアプロセス"の標準出力に"hoge is invalid option."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/1038_not_refrenced_job_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1038", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "job2")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @1038
  シナリオ: [正常系]1038_どこからも参照されないジョブがある_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1038_not_refrenced_job_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1038"を実行する
    かつ ジョブネット"jobnet1038"が完了することを確認する
    
    ならば ジョブネット"/jobnet1038" のステータスが正常終了であること
    かつ ジョブ"/jobnet1038/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1038/job2" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/1039_set_boot_jobs_future_job.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1039", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1","job3")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1" , :to => "job2")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2" , :to => "job3")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @failure
  @1039
  シナリオ: [正常系]1039_boot_jobsでジョブネットの途中のジョブを指定する_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1039_set_boot_jobs_future_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1039"を実行する
    かつ ジョブネット"jobnet1039"が完了することを確認する
    
    ならば ジョブネット"/jobnet1039" のステータスが正常終了であること
    かつ ジョブ"/jobnet1039/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1039/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1039/job3" のステータスが正常終了であること
    
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/1040_set_to_future_job.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1040", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1" , :to => ["job2","job3"])
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2" , :to => "job3")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @success
  @1040
  シナリオ: [正常系]1040_toでジョブネットの途中のジョブを指定する_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1040_set_to_future_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1040"を実行する
    かつ ジョブネット"jobnet1040"が完了することを確認する
    
    ならば ジョブネット"/jobnet1040" のステータスが正常終了であること
    かつ ジョブ"/jobnet1040/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1040/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1040/job3" のステータスが正常終了であること
    
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/1041_duplicated_jobname_on_same_layer.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1041", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job3")
  # end
  #  -------------------
  @1041
  シナリオ: [正常系]1041_同一階層内に同一名のジョブネットが含まれる_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1041_duplicated_jobname_on_same_layer.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E9  #{job_name} is duplicated.
    ならば "Tengineコアプロセス"の標準出力に"job1 is duplicated."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること

  
  # ./usecases/job/dsl/1042_duplicated_jobname_on_diff_layer.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1042", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1-1")
  #   jobnet("jobnet1042_2") do
  #     auto_sequence
  #     job("job1", "$HOME/tengine_job_test.sh 0 job1-2")
  #   end
  # end
  #  -------------------
  @success
  @1042
  シナリオ: [正常系]1042_別の階層に同一名のジョブネットが含まれる_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1042_duplicated_jobname_on_diff_layer.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1042"を実行する
    かつ ジョブネット"jobnet1042"が完了することを確認する
    
    ならば ジョブネット"/jobnet1042" のステータスが正常終了であること
    かつ ジョブ"/jobnet1042/job1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1042/jobnet1042_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1042/jobnet1042_2/job1" のステータスが正常終了であること
    
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1-1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1-1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1-1 start"と"tengine_job_test job1-2 start"の間であること
    かつ "tengine_job_test job1-2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1-1 finish"と"tengine_job_test job1-2 finish"の間であること
    かつ "tengine_job_test job1-2 finish"と"スクリプトログ"の末尾に出力されていること 

  # ./usecases/job/dsl/1043_not_registered_instance_name.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1043", :instance_name => "not_registered", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
  #  -------------------
  @1043
  シナリオ: [正常系]1043_:instance_nameが登録されていない_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1043_not_registered_instance_name.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # W1  instance_name(#{instance_name}) is not registered.
    ならば "Tengineコアプロセス"の標準出力に"instance_name(not_registered) is not registered."と出力されていること
    かつ "Tengineコアプロセス"の状態が"稼働中"であること
    
  
  # ./usecases/job/dsl/1044_not_registered_credential_name.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1044", :instance_name => "test_server1", :credential_name => "not_registered") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
  #  -------------------
  @1044
  シナリオ: [正常系]1044_:credential_nameが登録されていない_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1043_not_registered_instance_name.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する
    
    # W2 credential_name(#{credential_name}) is not registered.
    ならば "Tengineコアプロセス"の標準出力に"credential_name(not_registered) is not registered."と出力されていること
    かつ "Tengineコアプロセス"の状態が"稼働中"であること

  # ./usecases/job/dsl/1045_long_time_job.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1045", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 3600 job1"
  # end
  #  -------------------
  # シナリオ: [正常系]1045_とても時間がかかるジョブ_を試してみる
  #
  # 時間がかかるため、「アプリケーション開発者がとても時間がかかるジョブネット定義を試してみる.feature」 で実施します。



  # ./usecases/job/dsl/1046_permission_denied_script.rb
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
  @1046
  シナリオ: [異常系]1046_スクリプトに実行権限がない_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1046_permission_denied_script.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1046"を実行する
    かつ ジョブネット"jobnet1046"が完了することを確認する
    
    ならば ジョブネット"/jobnet1046" のステータスが異常終了であること
    かつ ジョブ"/jobnet1046/job1" のステータスが異常終了であること


  # ./usecases/job/dsl/1047_no_such_script.rb
  #  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1047", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   # このジョブネット定義では、tengine_job_no_such_script_test.sh は、存在しないことを想定しています。
  #   job("job1", "$HOME/tengine_job_no_such_script_test.sh 0 job1")
  # end
  #  -------------------
  @1047
  シナリオ: [異常系]1047_スクリプトが存在しない_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/./usecases/job/dsl/1047_no_such_script.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1047"を実行する
    かつ ジョブネット"jobnet1047"が完了することを確認する
    
    ならば ジョブネット"/jobnet1047" のステータスが異常終了であること
    かつ ジョブ"/jobnet1047/job1" のステータスが異常終了であること


  # ./usecases/job/dsl/1048_jobnet_script_env.rb
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
  @1048
  @manual
  シナリオ: [正常系]1048_シェルスクリプトに環境変数が渡される_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1048_jobnet_script_env.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
    ならば "job1"の"MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1048/jobnet1048_2/job1"であること
    かつ "job1"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "job1"の"MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "job1"の"MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "job1"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "job1"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "job1"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値が";"で区切られていること

    かつ "jobnet1048_finally"の"MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1048/finally/jobnet1048_finally"であること
    かつ "jobnet1048_finally"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "jobnet1048_finally"の"MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "jobnet1048_finally"の"MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "jobnet1048_finally"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値が";"で区切られていること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|操作|
    |jobnet1048のテンプレートID|jobnet1048|説明jobnet1048|表示 実行|

    もし "jobnet1048"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|名称|表示名|実行するスクリプト|接続サーバ名|認証情報名|次のジョブ|
    |jobnet1048_2のテンプレートID|jobnet1048_2|jobnet1048_2||test_server1|test_credential1|
    |job1のテンプレートID|job1|job1|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1||
    |finallyのテンプレートID|finally|finally||test_server1|test_credential1||
    |jobnet1048_finallyのテンプレートID|finally|finally|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1||
   
   
    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|ステータス|操作|
    |jobnet1048の実行時ID|jobnet1048|jobnet1048|完了|監視 再実行|

    もし "jobnet1048"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|ステータス|次のジョブ|操作|
    |jobnet1048_2の実行時ID|jobnet1048_2|jobnet1048_2||test_server1|test_credential1|完了||再実行|
    |job1の実行時ID|job1|job1|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1|完了||再実行|
    |finallyの実行時ID|finally|finally||test_server1|test_credential1|完了||再実行|
    |jobnet1048_finallyの実行時ID|finally|finally|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1|完了||再実行|

    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1048"の"表示"リンクをクリックする
    ならば URLのexecuteのIDとログのexecuteのIDが一緒であること

  # ./usecases/job/dsl/1048_jobnet_script_env_failure.rb
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
  @1048_1
  @manual
  シナリオ: [正常系]1048_シェルスクリプトに環境変数が渡される_を試してみる_ジョブが失敗した場合
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1048_jobnet_script_env_failure.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし 予定実行時間を10分に設定して、ジョブネット"jobnet1048_failure"を実行する
    かつ ジョブネット"jobnet1048_failure"が完了することを確認する
    
    ならば ジョブネット"/jobnet1048_failure" のステータスがエラー終了であること
    かつ ジョブネット"/jobnet1048_failure/jobnet1048_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1048_failure/jobnet1048_2/job1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1048_failure/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1048_failure/finally/jobnet1048_finally" のステータスが正常終了であること

    ########################################
    # シェルスクリプトに渡された環境変数をログファイルから確認
    ########################################
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
  
    ならば "jobnet1048_finally"の"MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1048_failure/finally/jobnet1048_finally"であること
    かつ "jobnet1048_finally"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "jobnet1048_finally"の"MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "jobnet1048_finally"の"MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "jobnet1048_finally"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値が";"で区切られていること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|操作|
    |jobnet1048_failureのテンプレートID|jobnet1048_failure|説明jobnet1048_failure|表示 実行|

    もし "jobnet1048_failure"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|名称|表示名|実行するスクリプト|接続サーバ名|認証情報名|次のジョブ|
    |jobnet1048_2のテンプレートID|jobnet1048_2|jobnet1048_2||test_server1|test_credential1|
    |job1のテンプレートID|job1|job1|exit 1|test_server1|test_credential1||
    |finallyのテンプレートID|finally|finally||test_server1|test_credential1||
    |jobnet1048_finallyのテンプレートID|finally|finally|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1||
   
   
    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|ステータス|操作|
    |jobnet1048_failureの実行時ID|jobnet1048_failure|jobnet1048_failure|完了|監視 再実行|

    もし "jobnet1048"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|ステータス|次のジョブ|操作|
    |jobnet1048_2の実行時ID|jobnet1048_2|jobnet1048_2||test_server1|test_credential1|完了||再実行|
    |job1の実行時ID|job1|job1|exit 1|test_server1|test_credential1|完了||再実行|
    |finallyの実行時ID|finally|finally||test_server1|test_credential1|完了||再実行|
    |jobnet1048_finallyの実行時ID|finally|finally|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1|完了||再実行|

    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1048_failure"の"表示"リンクをクリックする
    ならば URLのexecuteのIDとログのexecuteのIDが一緒であること


  # ./usecases/job/dsl/1048_jobnet_script_env_failure.rb
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
  @1048_2
  @manual
  シナリオ: [正常系]1048_シェルスクリプトに環境変数が渡される_を試してみる_finallyのジョブが失敗した場合
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1048_jobnet_script_env_finally_failure.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
    ならば "jobnet1048_finally_in_finally"の"MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1048_finally_failure/finally/jobnet1048_2_finally_jobnet/finally/jobnet1048_finally_in_finally"であること
    かつ "jobnet1048_finally_in_finally"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "jobnet1048_finally_in_finally"の"MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "jobnet1048_finally_in_finally"の"MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "jobnet1048_finally_in_finally"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally_in_finally"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1048_finally_in_finally"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値が";"で区切られていること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|操作|
    |jobnet1048_finally_failureのテンプレートID|jobnet1048_finally_failure|説明jobnet1048_finally_failure|表示 実行|

    もし "jobnet1048_finally_failure"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|名称|表示名|実行するスクリプト|接続サーバ名|認証情報名|次のジョブ|
    |jobnet1048_2のテンプレートID|jobnet1048_2|jobnet1048_2||test_server1|test_credential1|
    |job1のテンプレートID|job1|job1|exit 1|test_server1|test_credential1||
    |jobnet1048_finally_failure/finallyのテンプレートID|finally|finally||test_server1|test_credential1||
    |jobnet1048_2_finally_jobnetのテンプレートID|jobnet1048_2_finally_jobnet|jobnet1048_2_finally_jobnet||test_server1|test_credential1||
    |jobnet1048_finallyのテンプレートID|jobnet1048_finally|jobnet1048_finally|exit 1|test_server1|test_credential1||
    |jobnet1048_2_finally_jobnet/finallyのテンプレートID|finally|finally||test_server1|test_credential1||
    |jobnet1048_finally_in_finallyのテンプレートID|jobnet1048_finally_in_finally|jobnet1048_finally_in_finally|$HOME/tengine_job_env_test.sh 0 jobnet1048_finally_in_finally|test_server1|test_credential1||

    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|ステータス|操作|
    |jobnet1048_finally_failureの実行時ID|jobnet1048_finally_failure|jobnet1048_finally_failure|完了|監視 再実行|

    もし "jobnet1048_finally_failure"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|ステータス|次のジョブ|操作|
    |jobnet1048_2の実行時ID|jobnet1048_2|jobnet1048_2||test_server1|test_credential1|完了||再実行|
    |job1の実行時ID|job1|job1|exit 1|test_server1|test_credential1|完了||再実行|
    |jobnet1048_finally_failure/finallyの実行時ID|finally|finally||test_server1|test_credential1|完了||再実行|
    |jobnet1048_2_finally_jobnetの実行時ID|jobnet1048_2_finally_jobnet|jobnet1048_2_finally_jobnet||test_server1|test_credential1|完了||再実行|
    |jobnet1048_finallyの実行時ID|jobnet1048_finally|jobnet1048_finally|exit 1|test_server1|test_credential1|完了||再実行|
    |jobnet1048_2_finally_jobnet/finallyの実行時ID|finally|finally||test_server1|test_credential1|完了||再実行|
    |jobnet1048_finally_in_finallyの実行時ID|jobnet1048_finally_in_finally|jobnet1048_finally_in_finally|$HOME/tengine_job_env_test.sh 0 jobnet1048_finally_in_finally|test_server1|test_credential1|完了||再実行|


    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1048_finally_failure"の"表示"リンクをクリックする
    ならば URLのexecuteのIDとログのexecuteのIDが一緒であること


  # ./usecases/job/dsl/1049_expantion_script_env.rb
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
  @1049
  @manual
  シナリオ: [正常系]1049_expantionを利用したシェルスクリプトに環境変数が渡される_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1049_expantion_script_env.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
    ならば "job1"の"MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1049/jobnet1049_2/job1"であること
    かつ "job1"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "job1"の"MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "job1"の"MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "job1"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "job1"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "job1"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値が";"で区切られていること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|操作|
    |jobnet1049のテンプレートID|jobnet1049|説明jobnet1049|表示 実行|

    もし "jobnet1049"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|名称|表示名|実行するスクリプト|接続サーバ名|認証情報名|次のジョブ|
    |jobnet1049_2のテンプレートID|jobnet1049_2|jobnet1049_2||test_server1|test_credential1|
    |job1のテンプレートID|job1|job1|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1||
    
   
    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|ステータス|操作|
    |jobnet1049の実行時ID|jobnet1049|jobnet1049|完了|監視 再実行|

    もし "jobnet1049"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|ステータス|次のジョブ|操作|
    |jobnet1049_2の実行時ID|jobnet1049_2|jobnet1049_2||test_server1|test_credential1|完了||再実行|
    |job1の実行時ID|job1|job1|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1|完了||再実行|

    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1049"の"表示"リンクをクリックする
    ならば URLのexecuteのIDとログのexecuteのIDが一緒であること


  # ./usecases/job/dsl/1049_expantion_script_env_failure.rb
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
  @1049_2
  @manual
  シナリオ: [正常系]1049_expantion_failureを利用したシェルスクリプトに環境変数が渡される_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1049_expantion_script_env_failure.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし 予定実行時間を10分に設定して、ジョブネット"jobnet1049"を実行する
    かつ ジョブネット"jobnet1049"が完了することを確認する
    
    ならば ジョブネット"/jobnet1049_failure" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1049_failure/jobnet1049_2" のステータスがエラー終了であること
    かつ ジョブ"/jobnet1049_failure/jobnet1049_2/job1" のステータスがエラー終了であること
    かつ ジョブ"/jobnet1049_failure/finally/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1049_failure/finally/jobnet1049_finally" のステータスが正常終了であること

    ########################################
    # シェルスクリプトに渡された環境変数をログファイルから確認
    ########################################
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
    ならば "jobnet1049_finally"の"MM_ACTUAL_JOB_NAME_PATH"の値が"/jobnet1049_failure/jobnet1049_2/finally/jobnet1049_finally"であること
    かつ "jobnet1049_finally"の"MM_ACTUAL_JOB_SECURITY_TOKEN"の値が""であること
    かつ "jobnet1049_finally"の"MM_SCHEDULE_ESTIMATED_TIME"の値が""であること
    かつ "jobnet1049_finally"の"MM_SCHEDULE_ESTIMATED_END"の値が""であること
    かつ "jobnet1049_finally"の"MM_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1049_finally"の"MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"の値が";"で区切られていること
    かつ "jobnet1049_finally"の"MM_TEMPLATE_JOB_ANCESTOR_IDS"の値が";"で区切られていること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|操作|
    |jobnet1049_failureのテンプレートID|jobnet1049_failure|説明jobnet1049_failure|表示 実行|

    もし "jobnet1049_failure"の"表示"リンクをクリックする
    ならば "テンプレートジョブ画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|名称|表示名|実行するスクリプト|接続サーバ名|認証情報名|次のジョブ|
    |jobnet1049_2のテンプレートID|jobnet1049_2|jobnet1049_2||test_server1|test_credential1|
    |job1のテンプレートID|job1|job1|exit 1|test_server1|test_credential1||
    |finallyのテンプレートID|finally|finally||test_server1|test_credential1||
    |jobnet1049_finallyのテンプレートID|jobnet1049_finally|jobnet1049_finally|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1||

    もし "実行中のジョブ一覧画面"を表示する
    ならば "実行ジョブ一覧画面"が表示されていること
    かつ "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブネット名|説明|ステータス|操作|
    |jobnet1049_failureの実行時ID|jobnet1049_failure|jobnet1049_failure|エラー終了|監視 再実行|

    もし "jobnet1049_failure"の"監視"リンクをクリックする
    ならば "スクリプトログ"と同じ内容の以下の行が表示されること
    |ID|ジョブ名|説明|実行スクリプト|接続サーバ名|認証情報名|ステータス|次のジョブ|操作|
    |jobnet1049_2の実行時ID|jobnet1049_2|jobnet1049_2||test_server1|test_credential1|完了||再実行|
    |job1の実行時ID|job1|job1|exit 1|test_server1|test_credential1|完了||再実行|
    |jobnet1049_failure/finallyのテンプレートID|finally|finally||test_server1|test_credential1||
    |jobnet1049_finallyのテンプレートID|jobnet1049_finally|jobnet1049_finally|$HOME/tengine_job_env_test.sh 0 job1|test_server1|test_credential1||
    もし "ジョブ実行一覧画面"を表示する
    ならば "ジョブ実行一覧画面"が表示されること

    もし "jobnet1049_failure"の"表示"リンクをクリックする
    ならば URLのexecuteのIDとログのexecuteのIDが一緒であること


  # ./usecases/job/dsl/1050_dsl_version_in_dsl.rb
  #  -------------------
  # require 'tengine_job'
  # 
  # dsl_version("0.9.7")
  # 
  # jobnet("jobnet1050", :server_name => "test_server1", :credential_name => "test_credential1") do
  #   auto_sequence
  #   job("job1", "$HOME/tengine_job_test.sh 1 job1")
  # end
  # -------------------
  #
  @1050
  シナリオ: [正常系]1002_複数のジョブ(直列)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1050_dsl_version_in_dsl.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1050"を実行する
    かつ ジョブネット"jobnet1050"が完了することを確認する
    
    ならば ジョブネット"/jobnet1050" のステータスが正常終了であること
    かつ ジョブ"/jobnet1050/job1" のステータスが正常終了であること

    # -----------------------------
    # tengine_job_test job1 start
    # tengine_job_test job1 finish
    # -----------------------------
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"の末尾に出力されていること



  # ./usecases/job/dsl/1060_jobnet_directory
  #
	@manual
  @1060
  シナリオ: [正常系]1060_ディレクトリ構成の読込_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1060_jobnet_directory -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    ならば ルートのカテゴリの子に"1060_jobnet_directory"というカテゴリが存在すること
    かつ "1060_jobnet_directory"のカテゴリの子に"jobnetgroup_x"というカテゴリが存在すること
    かつ "1060_jobnet_directory"のカテゴリの子に"jobnetgroup_y"というカテゴリが存在すること
    かつ "1060_jobnet_directory"のカテゴリの子に"jobnetgroup_z"というカテゴリが存在すること

    もし "全体"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1060_a|jobnet1060_a|
    |jobnet1060_b|jobnet1060_b|
    |jobnet1060_c|jobnet1060_c|
    |jobnet1060_d|jobnet1060_d|
    |jobnet1060_e|jobnet1060_e|
    |jobnet1060_f|jobnet1060_f|
    |jobnet1060_g|jobnet1060_g|
    |jobnet1060_h|jobnet1060_h|
    |jobnet1060_i|jobnet1060_i|

    もし "1060_jobnet_directory"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1060_a|jobnet1060_a|
    |jobnet1060_b|jobnet1060_b|
    |jobnet1060_c|jobnet1060_c|
    |jobnet1060_d|jobnet1060_d|
    |jobnet1060_e|jobnet1060_e|
    |jobnet1060_f|jobnet1060_f|
    |jobnet1060_g|jobnet1060_g|
    |jobnet1060_h|jobnet1060_h|
    |jobnet1060_i|jobnet1060_i|

    もし "jobnetgroup_x"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1060_d|jobnet1060_d|
    |jobnet1060_e|jobnet1060_e|
    |jobnet1060_f|jobnet1060_f|

    もし "jobnetgroup_y"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1060_g|jobnet1060_g|
    |jobnet1060_h|jobnet1060_h|
    |jobnet1060_i|jobnet1060_i|

    もし "jobnetgroup_z"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|

  
  # ./usecases/job/dsl/1061_dictionary_yml
  @manual
  @1061
  シナリオ: [正常系]1061_dictionary.ymlの内容が正しく表示される_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1061_dictionary_yml -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    ならば ルートのカテゴリの子に"1061_dictionary_yml"というカテゴリが存在すること
    かつ "ジョブネットグループ1061"のカテゴリの子に"ジョブネットグループX"というカテゴリが存在すること
    かつ "ジョブネットグループ1061"のカテゴリの子に"ジョブネットグループY"というカテゴリが存在すること

    もし "全体"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_a|jobnet1061_a|
    |jobnet1061_b|jobnet1061_b|
    |jobnet1061_c|jobnet1061_c|
    |jobnet1061_d|jobnet1061_d|
    |jobnet1061_e|jobnet1061_e|
    |jobnet1061_f|jobnet1061_f|
    |jobnet1061_g|jobnet1061_g|
    |jobnet1061_h|jobnet1061_h|
    |jobnet1061_i|jobnet1061_i|

    もし "1061_dictionary_yml"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_a|jobnet1061_a|
    |jobnet1061_b|jobnet1061_b|
    |jobnet1061_c|jobnet1061_c|
    |jobnet1061_d|jobnet1061_d|
    |jobnet1061_e|jobnet1061_e|
    |jobnet1061_f|jobnet1061_f|
    |jobnet1061_g|jobnet1061_g|
    |jobnet1061_h|jobnet1061_h|
    |jobnet1061_i|jobnet1061_i|

    もし "ジョブネットグループX"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_d|jobnet1061_d|
    |jobnet1061_e|jobnet1061_e|
    |jobnet1061_f|jobnet1061_f|

    もし "ジョブネットグループY"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_g|jobnet1061_g|
    |jobnet1061_h|jobnet1061_h|
    |jobnet1061_i|jobnet1061_i|

  # ./usecases/job/dsl/1061_2_dictionary_yml
  @manual
  @1061_2
  シナリオ: [正常系]dictionary.ymlの内容が正しく表示される_を試してみる_読み込むディレクトリー自体がdictionary.ymlでカテゴリー名が指定されている
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1061_2_dictionary_yml -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    ならば ルートのカテゴリの子に"ジョブネットグループ1061"というカテゴリが存在すること
    かつ "ジョブネットグループ1061"のカテゴリの子に"ジョブネットグループX"というカテゴリが存在すること
    かつ "ジョブネットグループ1061"のカテゴリの子に"ジョブネットグループY"というカテゴリが存在すること

    もし "全体"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_a|jobnet1061_a|
    |jobnet1061_b|jobnet1061_b|
    |jobnet1061_c|jobnet1061_c|
    |jobnet1061_d|jobnet1061_d|
    |jobnet1061_e|jobnet1061_e|
    |jobnet1061_f|jobnet1061_f|
    |jobnet1061_g|jobnet1061_g|
    |jobnet1061_h|jobnet1061_h|
    |jobnet1061_i|jobnet1061_i|

    もし "ジョブネットグループ1061"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_a|jobnet1061_a|
    |jobnet1061_b|jobnet1061_b|
    |jobnet1061_c|jobnet1061_c|
    |jobnet1061_d|jobnet1061_d|
    |jobnet1061_e|jobnet1061_e|
    |jobnet1061_f|jobnet1061_f|
    |jobnet1061_g|jobnet1061_g|
    |jobnet1061_h|jobnet1061_h|
    |jobnet1061_i|jobnet1061_i|

    もし "ジョブネットグループX"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_d|jobnet1061_d|
    |jobnet1061_e|jobnet1061_e|
    |jobnet1061_f|jobnet1061_f|

    もし "ジョブネットグループY"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_g|jobnet1061_g|
    |jobnet1061_h|jobnet1061_h|
    |jobnet1061_i|jobnet1061_i|

  # ./usecases/job/dsl/1062_incorrect_dictionary_yml
  @manual
  @1062
  シナリオ: [正常系]1062_dictionary.ymlの内容が間違っている_を試してみる
  
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1062_incorrect_dictionary_yml -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    ならば ルートのカテゴリの子に"1062_incorrect_dictionary_yml"というカテゴリが存在すること
    かつ "1062_incorrect_dictionary_yml"のカテゴリの子に"ジョブネットグループX"というカテゴリが存在すること
    かつ "1062_incorrect_dictionary_yml"のカテゴリの子に"ジョブネットグループY"というカテゴリが存在すること
    かつ "1062_incorrect_dictionary_yml"のカテゴリの子に"jobnetgroup_y"というカテゴリが存在すること
 
    もし "全体"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_a|jobnet1061_a|
    |jobnet1061_b|jobnet1061_b|
    |jobnet1061_c|jobnet1061_c|
    |jobnet1061_d|jobnet1061_d|
    |jobnet1061_e|jobnet1061_e|
    |jobnet1061_f|jobnet1061_f|
    |jobnet1061_g|jobnet1061_g|
    |jobnet1061_h|jobnet1061_h|
    |jobnet1061_i|jobnet1061_i|
    |jobnet1061_j|jobnet1061_j|
    |jobnet1061_k|jobnet1061_k|

   もし "1062_incorrect_dictionary_yml"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_a|jobnet1061_a|
    |jobnet1061_b|jobnet1061_b|
    |jobnet1061_c|jobnet1061_c|
    |jobnet1061_d|jobnet1061_d|
    |jobnet1061_e|jobnet1061_e|
    |jobnet1061_f|jobnet1061_f|
    |jobnet1061_g|jobnet1061_g|
    |jobnet1061_h|jobnet1061_h|
    |jobnet1061_i|jobnet1061_i|
    |jobnet1061_j|jobnet1061_j|
    |jobnet1061_k|jobnet1061_k|

   もし "ジョブネットグループX"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_d|jobnet1061_d|
    |jobnet1061_e|jobnet1061_e|
    |jobnet1061_f|jobnet1061_f|

   もし "jobnetgroup_y"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_g|jobnet1061_g|
    |jobnet1061_h|jobnet1061_h|
    |jobnet1061_i|jobnet1061_i|

   もし "ジョブネットグループY"のカテゴリを選択すると以下の行が表示されること
    |ジョブネット名|説明|
    |jobnet1061_j|jobnet1061_j|
    |jobnet1061_k|jobnet1061_k|


  # ./usecases/job/dsl/1071_rootjobnet_includes_parallel_jobs.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1071 ルートジョブネットが複数のジョブ(並列)を含むジョブネット
  # # [jobnet1071]
  # #
  # #        |-->[job1]-->|
  # #        |            |
  # # [S1]-->|            |-->[E1]
  # #        |            |
  # #        |-->[job2]-->|
  # #
  # #                     ______________finally_____________
  # #                    {                                  }
  # #                    {[S2]-->[jobnet1071_finally]-->[E2]}
  # #                    {__________________________________}
  # 
  # jobnet("jobnet1071", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1","job2")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  #   finally do
  #     job("jobnet1071_finally","$HOME/tengine_job_test.sh 0 jobnet1071_finally")
  #   end
  # end
  #  -------------------
  @success
  @1071
  シナリオ: [正常系]1071_ルートジョブネットが複数のジョブ(並列)を含むジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1071_rootjobnet_includes_parallel_jobs.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1071"を実行する
    かつ ジョブネット"jobnet1071"が完了することを確認する
    
    ならば ジョブネット"/jobnet1071" のステータスが正常終了であること
    かつ ジョブ"/jobnet1071/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1071/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1071/finally/jobnet1071_finally" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"の後であること

    かつ "tengine_job_test jobnet1071_finally start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"の後であること
    かつ "tengine_job_test jobnet1071_finally start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"の後であること
    かつ "tengine_job_test jobnet1071_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1071_finally start"の後であること


  # ./usecases/job/dsl/1072_rootjobnet_includes_one_jobnet_having_finally.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1072 ルートジョブネットがFinally付きのジョブネット１つ
  # # [jobnet1072]
  # #
  # #        {-[jobnet1072-1]-------------------------}
  # #        {                                        }
  # # [S1]-->{        [S2]-->[job1]-->[E2]            }-->[E1]
  # #        {                                        }
  # #        {____________finally_____________________}
  # #        {                                        }
  # #        { [S3]-->[jobnet1072-1_finally]-->[E3]   }
  # #        {                                        }
  # #        {----------------------------------------}
  # #
  # #                     ______________finally_____________
  # #                    {                                  }
  # #                    {[S4]-->[jobnet1072_finally]-->[E4]}
  # #                    {__________________________________}
  # 
  # jobnet("jobnet1072", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   jobnet("jobnet1072-1") do 
  #     boot_jobs("job1")
  #     job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #     finally do 
  #       boot_jobs("jobnet1072-1_finally")
  #       job("jobnet1072-1_finally", "$HOME/tengine_job_test.sh 0 jobnet1072-1_finally")
  #     end
  #   end
  #   finally do
  #     job("jobnet1072_finally","$HOME/tengine_job_test.sh 0 jobnet1072_finally")
  #   end
  # end
  #  -------------------
  @success
  @1072
  シナリオ: [正常系]1072_ルートジョブネットがFinally付きのジョブネット１つ_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1072_rootjobnet_includes_one_jobnet_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1072"を実行する
    かつ ジョブネット"jobnet1072"が完了することを確認する
    
    ならば ジョブネット"/jobnet1072" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1072/jobnet1072-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1072/jobnet1072-1/job1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1072/jobnet1072-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1072/jobnet1072-1/finally/jobnet1072-1_finally" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1072/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1072/finally/jobnet1072_finally" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること

    かつ "tengine_job_test jobnet1072-1_finally start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"の後であること
    かつ "tengine_job_test jobnet1072-1_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1072-1_finally start"の後であること

    かつ "tengine_job_test jobnet1072_finally start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1072-1_finally finish"の後であること
    かつ "tengine_job_test jobnet1072_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1072_finally start"の後であること

  

  # ./usecases/job/dsl/1073_rootjobnet_includes_serial_jobnets_having_finally.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1073 ルートジョブネットがFinally付きのジョブネット(直列)
  # # [jobnet1073]
  # #
  # #
  # #        {-[jobnet1073-1]-------}   {-[jobnet1073-2]-------}
  # #        {                      }   {                      }
  # # [S1]-->{  [S2]-->[j1]-->[E2]  }-->{  [S4]-->[j2]-->[E4]  }-->[E1]
  # #        {                      }   {                      }
  # #        {________finally_______}   {________finally_______}
  # #        {                      }   {                      }
  # #        { [S3]-->[jf1]-->[E3]  }   { [S5]-->[jf2]-->[E5]  }
  # #        {                      }   {                      }
  # #        {----------------------}   {----------------------}
  # #
  # #                     ______________finally_____________
  # #                    {                                  }
  # #                    {[S4]-->[jobnet1073_finally]-->[E4]}
  # #                    {__________________________________}
  # 
  # jobnet("jobnet1073", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("jobnet1073-1")
  #   jobnet("jobnet1073-1", :to => "jobnet1073-2") do 
  #     boot_jobs("j1")
  #     job("j1", "$HOME/tengine_job_test.sh 0 j1")
  #     finally do 
  #       boot_jobs("jf1")
  #       job("jf1", "$HOME/tengine_job_test.sh 0 jf1")
  #     end
  #   end
  #   jobnet("jobnet1073-2") do 
  #     boot_jobs("j2")
  #     job("j2", "$HOME/tengine_job_test.sh 0 j2")
  #     finally do 
  #       boot_jobs("jf2")
  #       job("jf2", "$HOME/tengine_job_test.sh 0 jf2")
  #     end
  #   end
  #   finally do
  #     job("jobnet1073_finally","$HOME/tengine_job_test.sh 0 jobnet1073_finally")
  #   end
  # end
  #  ------------------
  @success
  @1073
  シナリオ: [正常系]1073_ルートジョブネットがFinally付きのジョブネット(直列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1073_rootjobnet_includes_serial_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1073"を実行する
    かつ ジョブネット"jobnet1073"が完了することを確認する
    
    ならば ジョブネット"/jobnet1073" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1073/jobnet1073-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1073/jobnet1073-1/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1073/jobnet1073-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1073/jobnet1073-1/finally/jf1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1073/jobnet1073-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1073/jobnet1073-2/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1073/jobnet1073-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1073/jobnet1073-2/finally/jf2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1073/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1073/finally/jobnet1073_finally" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること
    かつ "tengine_job_test jf1 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test jf1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jf1 start"の後であること

    かつ "tengine_job_test j2 start"と"スクリプトログ"に出力されており、"tengine_job_test jf1 finish"の後であること
    かつ "tengine_job_test j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test j2 start"の後であること
    かつ "tengine_job_test jf2 start"と"スクリプトログ"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test jf2 finish"と"スクリプトログ"に出力されており、"tengine_job_test jf2 start"の後であること
    
    かつ "tengine_job_test jobnet1073_finally start"と"スクリプトログ"に出力されており、"tengine_job_test jf2 finish"の後であること
    かつ "tengine_job_test jobnet1073_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1073_finally start"の後であること

  # ./usecases/job/dsl/1074_rootjobnet_includes_parallel_jobnets_having_finally.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1074 ルートジョブネットがFinally付きのジョブネット(並列)
  # # [jobnet1074]
  # #
  # #            {-[jobnet1074-1]-------}
  # #            {                      }
  # #        |-->{  [S2]-->[j1]-->[E2]  }-->|
  # #        |   {                      }   |
  # #        |   {________finally_______}   |
  # #        |   {                      }   |
  # #        |   { [S3]-->[jf1]-->[E3]  }   |
  # #        |   {                      }   |
  # #        |   {----------------------}   |
  # #        |                              |
  # # [S1]-->F                              J-->[E1]
  # #        |                              |
  # #        |   {-[jobnet1074-2]-------}   |
  # #        |   {                      }   |
  # #        |-->{  [S4]-->[j2]-->[E4]  }-->|
  # #            {                      }
  # #            {________finally_______}
  # #            {                      }
  # #            { [S5]-->[jf2]-->[E5]  }
  # #            {                      }
  # #            {----------------------}
  # #
  # #                     ______________finally_____________
  # #                    {                                  }
  # #                    {[S4]-->[jobnet1074_finally]-->[E4]}
  # #                    {__________________________________}
  # 
  # jobnet("jobnet1074", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("jobnet1074-1","jobnet1074-2")
  #   jobnet("jobnet1074-1") do 
  #     boot_jobs("j1")
  #     job("j1", "$HOME/tengine_job_test.sh 0 j1")
  #     finally do 
  #       boot_jobs("jf1")
  #       job("jf1", "$HOME/tengine_job_test.sh 0 jf1")
  #     end
  #   end
  #   jobnet("jobnet1074-2") do 
  #     boot_jobs("j2")
  #     job("j2", "$HOME/tengine_job_test.sh 0 j2")
  #     finally do 
  #       boot_jobs("jf2")
  #       job("jf2", "$HOME/tengine_job_test.sh 0 jf2")
  #     end
  #   end
  #   finally do
  #     job("jobnet1074_finally","$HOME/tengine_job_test.sh 0 jobnet1074_finally")
  #   end
  # end
  #  -------------------
  @success
  @1074
  シナリオ: [正常系]1074_ルートジョブネットがFinally付きのジョブネット(並列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1074_rootjobnet_includes_parallel_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1074"を実行する
    かつ ジョブネット"jobnet1074"が完了することを確認する
    
    ならば ジョブネット"/jobnet1074" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1074/jobnet1074-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1074/jobnet1074-1/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1074/jobnet1074-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1074/jobnet1074-1/finally/jf1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1074/jobnet1074-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1074/jobnet1074-2/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1074/jobnet1074-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1074/jobnet1074-2/finally/jf2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1074/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1074/finally/jobnet1074_finally" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること
    かつ "tengine_job_test jf1 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test jf1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jf1 start"の後であること

    かつ "tengine_job_test j2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test j2 start"の後であること
    かつ "tengine_job_test jf2 start"と"スクリプトログ"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test jf2 finish"と"スクリプトログ"に出力されており、"tengine_job_test jf2 start"の後であること

    かつ "tengine_job_test jobnet1074_finally start"と"スクリプトログ"に出力されており、"tengine_job_test jf1 finish"の後であること
    かつ "tengine_job_test jobnet1074_finally start"と"スクリプトログ"に出力されており、"tengine_job_test jf2 finish"の後であること
    かつ "tengine_job_test jobnet1074_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1074_finally start"の後であること


  
  # ./usecases/job/dsl/1075_rootjobnet_includes_3_layers_jobnets_having_finally.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1075 ルートジョブネットがFinally付きのジョブネット入れ子3層
  # # [jobnet1075]
  # #
  # #          {-[jobnet1075-1]------------------------------------------}
  # #          {                                                         }
  # #          {        {-[jobnet1075-2]------------------------}        }
  # #          {        {                                       }        }
  # #          {        {        {-[jobnet1075-3]------}        }        }
  # #          {        {        {                     }        }        }
  # #   [S1]-->{ [S2]-->{ [S4]-->{ [S6]-->[j3]-->[E6]  }-->[E4] }-->[E2] }-->[E1]
  # #          {        {        {                     }        }        }
  # #          {        {        {_______finally_______}        }        }
  # #          {        {        {                     }        }        }
  # #          {        {        { [S7]-->[jf3]-->[E7] }        }        }
  # #          {        {        {_____________________}        }        }
  # #          {        {                                       }        }
  # #          {        {________________finally________________}        }
  # #          {        {                                       }        }
  # #          {        {          [S5]-->[jf2]-->[E5]          }        }
  # #          {        {_______________________________________}        }
  # #          {                                                         }
  # #          {_________________________finally_________________________}
  # #          {                                                         }
  # #          {                   [S3]-->[jf1]-->[E3]                   }
  # #          {---------------------------------------------------------}
  # #
  # #                      ______________finally_____________
  # #                     {                                  }
  # #                     {[S4]-->[jobnet1075_finally]-->[E4]}
  # #                     {__________________________________}
  # 
  # jobnet("jobnet1075", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("jobnet1075-1")
  #   jobnet("jobnet1075-1") do 
  #     boot_jobs("jobnet1075-2")
  #     jobnet("jobnet1075-2") do 
  #       boot_jobs("jobnet1075-3")
  #       jobnet("jobnet1075-3") do 
  #         boot_jobs("j3")
  #         job("j3","$HOME/tengine_job_test.sh 0 j3")
  #         finally do 
  #           boot_jobs("jf3")
  #           job("jf3", "$HOME/tengine_job_test.sh 0 jf3")
  #         end
  #       end
  #       finally do 
  #         boot_jobs("jf2")
  #         job("jf2", "$HOME/tengine_job_test.sh 0 jf2")
  #       end
  #     end
  #     finally do 
  #       boot_jobs("jf1")
  #       job("jf1", "$HOME/tengine_job_test.sh 0 jf1")
  #     end
  #   end
  #   finally do
  #     job("jobnet1075_finally","$HOME/tengine_job_test.sh 0 jobnet1075_finally")
  #   end
  # end
  #  -------------------
  @success
  @1075
  シナリオ: [正常系]1075_ルートジョブネットがFinally付きのジョブネット入れ子3層_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1075_rootjobnet_includes_3_layers_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1075"を実行する
    かつ ジョブネット"jobnet1075"が完了することを確認する
    
    ならば ジョブネット"/jobnet1075" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1075/jobnet1075-1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1075/jobnet1075-1/jobnet1075-2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1075/jobnet1075-1/jobnet1075-2/jobnet1075-3" のステータスが正常終了であること
    かつ ジョブ"/jobnet1075/jobnet1075-1/jobnet1075-2/jobnet1075-3/j3" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1075/jobnet1075-1/jobnet1075-2/jobnet1075-3/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1075/jobnet1075-1/jobnet1075-2/jobnet1075-3/finally/jf3" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1075/jobnet1075-1/jobnet1075-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1075/jobnet1075-1/jobnet1075-2/finally/jf2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1075/jobnet1075-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1075/jobnet1075-1/finally/jf1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1075/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1075/finally/jobnet1075_finally" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j3 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j3 finish"と"スクリプトログ"に出力されており、"tengine_job_test j3 start"の後であること
    かつ "tengine_job_test jf3 start"と"スクリプトログ"に出力されており、"tengine_job_test j3 finish"の後であること
    かつ "tengine_job_test jf3 finish"と"スクリプトログ"に出力されており、"tengine_job_test jf3 start"の後であること

    かつ "tengine_job_test jf2 start"と"スクリプトログ"に出力されており、"tengine_job_test jf3 finish"の後であること
    かつ "tengine_job_test jf2 finish"と"スクリプトログ"に出力されており、"tengine_job_test jf2 start"の後であること

    かつ "tengine_job_test jf1 start"と"スクリプトログ"に出力されており、"tengine_job_test jf2 finish"の後であること
    かつ "tengine_job_test jf1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jf1 start"の後であること

    かつ "tengine_job_test jobnet1075_finally start"と"スクリプトログ"に出力されており、"tengine_job_test jf1 finish"の後であること
    かつ "tengine_job_test jobnet1075_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1075_finally start"の後であること

  
  # ./usecases/job/dsl/1076_rootjobnet_includes_parallel_jobnets_having_finally_and_different_credentials.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1076 ルートジョブネットがクレデンシャルが違うジョブネット(並列)
  # # [jobnet1076]
  # #
  # #            {-[jobnet1076-1]-------}
  # #            {                      }
  # #        |-->{  [S2]-->[j1]-->[E2]  }-->|
  # #        |   {                      }   |
  # #        |   {________finally_______}   |
  # #        |   {                      }   |
  # #        |   { [S3]-->[jf1]-->[E3]  }   |
  # #        |   {                      }   |
  # #        |   {----------------------}   |
  # #        |                              |
  # # [S1]-->F                              J-->[E1]
  # #        |                              |
  # #        |   {-[jobnet1076-2]-------}   |
  # #        |   {                      }   |
  # #        |-->{  [S4]-->[j2]-->[E4]  }-->|
  # #            {                      }
  # #            {________finally_______}
  # #            {                      }
  # #            { [S5]-->[jf2]-->[E5]  }
  # #            {                      }
  # #            {----------------------}
  # #
  # #                     ______________finally_____________
  # #                    {                                  }
  # #                    {[S4]-->[jobnet1076_finally]-->[E4]}
  # #                    {__________________________________}
  # 
  # jobnet("jobnet1076", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("jobnet1076-1","jobnet1076-2")
  #   jobnet("jobnet1076-1", :credential_name => "test_credential1-1") do 
  #     boot_jobs("j1")
  #     job("j1", "$HOME/tengine_job_test.sh 0 j1")
  #     finally do 
  #       boot_jobs("jf1")
  #       job("jf1", "$HOME/tengine_job_test.sh 0 jf1")
  #     end
  #   end
  #   jobnet("jobnet1076-2") do 
  #     boot_jobs("j2")
  #     job("j2", "$HOME/tengine_job_test.sh 0 j2")
  #     finally do 
  #       boot_jobs("jf2")
  #       job("jf2", "$HOME/tengine_job_test.sh 0 jf2")
  #     end
  #   end
  #   finally do
  #     job("jobnet1076_finally","$HOME/tengine_job_test.sh 0 jobnet1076_finally")
  #   end
  # end
  #  -------------------
  @success
  @1076
  シナリオ: [正常系]1076_ルートジョブネットがクレデンシャルが違うジョブネット(並列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 認証情報が名称:"test_credential1-1"で登録されている
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1076_rootjobnet_includes_parallel_jobnets_having_finally_and_different_credentials.rb  -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1076"を実行する
    かつ ジョブネット"jobnet1076"が完了することを確認する
    
    ならば ジョブネット"/jobnet1076" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1076/jobnet1076-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1076/jobnet1076-1/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1076/jobnet1076-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1076/jobnet1076-1/finally/jf1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1076/jobnet1076-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1076/jobnet1076-2/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1076/jobnet1076-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1076/jobnet1076-2/finally/jf2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1076/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1076/finally/jobnet1076_finally" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること
    かつ "tengine_job_test jf1 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test jf1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jf1 start"の後であること

    かつ "tengine_job_test j2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test j2 start"の後であること
    かつ "tengine_job_test jf2 start"と"スクリプトログ"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test jf2 finish"と"スクリプトログ"に出力されており、"tengine_job_test jf2 start"の後であること

    かつ "tengine_job_test jobnet1076_finally start"と"スクリプトログ"に出力されており、"tengine_job_test jf1 finish"の後であること
    かつ "tengine_job_test jobnet1076_finally start"と"スクリプトログ"に出力されており、"tengine_job_test jf2 finish"の後であること
    かつ "tengine_job_test jobnet1076_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1076_finally start"の後であること

  
  # ./usecases/job/dsl/1077_rootjbonet_includes_parallel_jobnets_having_finally_and_different_server.rb
  #  ------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1077 ルートジョブネットが仮想サーバが違うジョブネット(並列)
  # # [jobnet1077]
  # #
  # #            {-[jobnet1077-1]-------}
  # #            {                      }
  # #        |-->{  [S2]-->[j1]-->[E2]  }-->|
  # #        |   {                      }   |
  # #        |   {________finally_______}   |
  # #        |   {                      }   |
  # #        |   { [S3]-->[jf1]-->[E3]  }   |
  # #        |   {                      }   |
  # #        |   {----------------------}   |
  # #        |                              |
  # # [S1]-->F                              J-->[E1]
  # #        |                              |
  # #        |   {-[jobnet1077-2]-------}   |
  # #        |   {                      }   |
  # #        |-->{  [S4]-->[j2]-->[E4]  }-->|
  # #            {                      }
  # #            {________finally_______}
  # #            {                      }
  # #            { [S5]-->[jf2]-->[E5]  }
  # #            {                      }
  # #            {----------------------}
  # #
  # #                     ______________finally_____________
  # #                    {                                  }
  # #                    {[S4]-->[jobnet1077_finally]-->[E4]}
  # #                    {__________________________________}
  # 
  # jobnet("jobnet1077", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("jobnet1077-1","jobnet1077-2")
  #   jobnet("jobnet1077-1", :instance_name => "test_server2", :credential_name => "test_credential2") do 
  #     boot_jobs("j1")
  #     job("j1", "$HOME/tengine_job_test.sh 0 j1")
  #     finally do 
  #       boot_jobs("jf1")
  #       job("jf1", "$HOME/tengine_job_test.sh 0 jf1")
  #     end
  #   end
  #   jobnet("jobnet1077-2", :instance_name => "test_server3", :credential_name => "test_credential3") do 
  #     boot_jobs("j2")
  #     job("j2", "$HOME/tengine_job_test.sh 0 j2")
  #     finally do 
  #       boot_jobs("jf2")
  #       job("jf2", "$HOME/tengine_job_test.sh 0 jf2")
  #     end
  #   end
  #   finally do
  #     job("jobnet1077_finally","$HOME/tengine_job_test.sh 0 jobnet1077_finally")
  #   end
  # end
  #  -------------------
  @success
  @1077
  シナリオ: [正常系]1077_ルートジョブネットが仮想サーバが違うジョブネット(並列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1077_rootjbonet_includes_parallel_jobnets_having_finally_and_different_server.rb  -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1077"を実行する
    かつ ジョブネット"jobnet1077"が完了することを確認する
    
    ならば ジョブネット"/jobnet1077" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1077/jobnet1077-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1077/jobnet1077-1/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1077/jobnet1077-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1077/jobnet1077-1/finally/jf1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1077/jobnet1077-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1077/jobnet1077-2/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1077/jobnet1077-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1077/jobnet1077-2/finally/jf2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1077/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1077/finally/jobnet1077_finally" のステータスが正常終了であること


    もし 仮想サーバ"test_server2"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test j1 start"の後であること
    かつ "tengine_job_test jf1 start"と"スクリプトログ2"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test jf1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test jf1 start"の後であること

    もし 仮想サーバ"test_server3"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    かつ "tengine_job_test j2 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test j2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test j2 start"の後であること
    かつ "tengine_job_test jf2 start"と"スクリプトログ3"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test jf2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test jf2 start"の後であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    かつ "tengine_job_test jobnet1077_finally start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test jobnet1077_finally finish"と"スクリプトログ1"に出力されており、"tengine_job_test jobnet1077_finally start"の後であること

    
  # ./usecases/job/dsl/1078_finally_includes_parallel_jobs.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1078 Finallyに複数のジョブ(並列)を含むジョブネット
  # # [jobnet1078]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     __________finally___________
  # #                    {                            }
  # #                    {       |-->[fj1]-->|        }
  # #                    {       |           |        }
  # #                    {[S4]-->F           J-->[E4] }
  # #                    {       |           |        }
  # #                    {       |-->[fj2]-->|        }
  # #                    {____________________________}
  # 
  # jobnet("jobnet1078", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     boot_jobs("fj1","fj2")
  #     job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #     job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  #   end
  # end
  #  -------------------
  @success
  @1078
  シナリオ: [正常系]1078_Finallyに複数のジョブ(並列)を含むジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1078_finally_includes_parallel_jobs.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1078"を実行する
    かつ ジョブネット"jobnet1078"が完了することを確認する
    
    ならば ジョブネット"/jobnet1078" のステータスが正常終了であること
    かつ ジョブ"/jobnet1078/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1078/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1078/finally/fj1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1078/finally/fj2" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること
    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること


  # ./usecases/job/dsl/1079_finally_includes_one_jobnet_having_finally.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1079 FinallyにFinally付きのジョブネット１つ
  # # [jobnet1079]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     _______________finally_________________
  # #                    {                                       }
  # #                    {         _[jobnet1079]________         }
  # #                    {        {                     }        }
  # #                    {        {                     }        }
  # #                    { [S2]-->{ [S3]-->[j2]-->[E3]  }-->[E2] }
  # #                    {        {                     }        }
  # #                    {        {______finally________}        }
  # #                    {        {                     }        }
  # #                    {        { [S4]-->[fj1]-->[E4] }        }
  # #                    {        {_____________________}        }
  # #                    {                                       }
  # #                    {_______________________________________}
  # 
  # jobnet("jobnet1079", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     boot_jobs("jobnet1079-1")
  #     jobnet("jobnet1079-1") do 
  #       boot_jobs("j2")
  #       job("j2","$HOME/tengine_job_test.sh 0 j2")
  #       finally do 
  #         boot_jobs("fj1")
  #         job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1079
  シナリオ: [正常系]1079_FinallyにFinally付きのジョブネット１つ_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1079_finally_includes_one_jobnet_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1079"を実行する
    かつ ジョブネット"jobnet1079"が完了することを確認する
    
    ならば ジョブネット"/jobnet1079" のステータスが正常終了であること
    かつ ジョブ"/jobnet1079/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1079/finally" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1079/finally/jobnet1079-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1079/finally/jobnet1079-1/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1079/finally/jobnet1079-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1079/finally/jobnet1079-1/finally/fj1" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test j2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test j2 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること


  
  # ./usecases/job/dsl/1080_finally_includes_serial_jobnets_having_finally.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1080 FinallyにFinally付きのジョブネット(直列)
  # # [jobnet1080]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     _______________finally___________________________________________
  # #                    {                                                                 }
  # #                    {         _[jobnet1080-1]______     _[jobnet1080-2_______         }
  # #                    {        {                     }   {                     }        }
  # #                    {        {                     }   {                     }        }
  # #                    { [S2]-->{ [S3]-->[j2]-->[E3]  }-->{ [S5]-->[j3]-->[E5]  }-->[E2] }
  # #                    {        {                     }   {                     }        }
  # #                    {        {______finally________}   {______finally________}        }
  # #                    {        {                     }   {                     }        }
  # #                    {        { [S4]-->[fj1]-->[E4] }   { [S6]-->[fj2]-->[E6] }        }
  # #                    {        {_____________________}   {_____________________}        }
  # #                    {                                                                 }
  # #                    {_________________________________________________________________}
  # 
  # jobnet("jobnet1080", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     boot_jobs("jobnet1080-1")
  #     jobnet("jobnet1080-1", :to => "jobnet1080-2") do 
  #       boot_jobs("j2")
  #       job("j2","$HOME/tengine_job_test.sh 0 j2")
  #       finally do 
  #         boot_jobs("fj1")
  #         job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #       end
  #     end
  #     jobnet("jobnet1080-2") do 
  #       boot_jobs("j3")
  #       job("j3","$HOME/tengine_job_test.sh 0 j3")
  #       finally do 
  #         boot_jobs("fj2")
  #         job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1080
  シナリオ: [正常系]1080_FinallyにFinally付きのジョブネット(直列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1080_finally_includes_serial_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1080"を実行する
    かつ ジョブネット"jobnet1080"が完了することを確認する
    
    ならば ジョブネット"/jobnet1080" のステータスが正常終了であること
    かつ ジョブ"/jobnet1080/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1080/finally" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1080/finally/jobnet1080-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1080/finally/jobnet1080-1/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1080/finally/jobnet1080-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1080/finally/jobnet1080-1/finally/fj1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1080/finally/jobnet1080-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1080/finally/jobnet1080-2/j3" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1080/finally/jobnet1080-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1080/finally/jobnet1080-2/finally/fj2" のステータスが正常終了であること
    
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test j2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test j2 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ "tengine_job_test j3 start"と"スクリプトログ"に出力されており、"tengine_job_test fj1 finish"の後であること
    かつ "tengine_job_test j3 finish"と"スクリプトログ"に出力されており、"tengine_job_test j3 start"の後であること

    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test j3 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること
    
  
  # ./usecases/job/dsl/1081_finally_includes_parallel_jobnets_having_finally.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1081 FinallyにFinally付きのジョブネット(並列)
  # # [jobnet1081]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     _______________finally________________________
  # #                    {                                               }
  # #                    {             _[jobnet1081-1]______             }
  # #                    {            {                     }            }
  # #                    {            {                     }            }
  # #                    {        |-->{ [S3]-->[j2]-->[E3]  }-->|        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {______finally________}   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   { [S4]-->[fj1]-->[E4] }   |        }
  # #                    {        |   {_____________________}   |        }
  # #                    {        |                             |        }
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {        |    _[jobnet1081-2]______    |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |-->{ [S5]-->[j3]-->[E5]  }-->|        }
  # #                    {            {                     }            }
  # #                    {            {______finally________}            }
  # #                    {            {                     }            }
  # #                    {            { [S6]-->[fj2]-->[E6] }            }
  # #                    {            {_____________________}            }
  # #                    {                                               }
  # #                    {_______________________________________________}
  # 
  # jobnet("jobnet1081", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     boot_jobs("jobnet1081-1","jobnet1081-2")
  #     jobnet("jobnet1081-1") do 
  #       boot_jobs("j2")
  #       job("j2","$HOME/tengine_job_test.sh 0 j2")
  #       finally do 
  #         boot_jobs("fj1")
  #         job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #       end
  #     end
  #     jobnet("jobnet1081-2") do 
  #       boot_jobs("j3")
  #       job("j3","$HOME/tengine_job_test.sh 0 j3")
  #       finally do 
  #         boot_jobs("fj2")
  #         job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1081
  シナリオ: [正常系]1081_FinallyにFinally付きのジョブネット(並列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1081_finally_includes_parallel_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1081"を実行する
    かつ ジョブネット"jobnet1081"が完了することを確認する
    
    ならば ジョブネット"/jobnet1081" のステータスが正常終了であること
    かつ ジョブ"/jobnet1081/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1081/finally" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1081/finally/jobnet1081-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1081/finally/jobnet1081-1/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1081/finally/jobnet1081-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1081/finally/jobnet1081-1/finally/fj1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1081/finally/jobnet1081-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1081/finally/jobnet1081-2/j3" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1081/finally/jobnet1081-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1081/finally/jobnet1081-2/finally/fj2" のステータスが正常終了であること
    
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test j2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test j2 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ "tengine_job_test j3 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test j3 finish"と"スクリプトログ"に出力されており、"tengine_job_test j3 start"の後であること

    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test j3 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること

  
  # ./usecases/job/dsl/1082_finally_includes_parallel_jobnets_having_finally_and_different_credentials.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1082 Finallyにクレデンシャルが違うジョブネット(並列)
  # # [jobnet1082]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     _______________finally________________________
  # #                    {                                               }
  # #                    {             _[jobnet1082-1]______             }
  # #                    {            {                     }            }
  # #                    {            {                     }            }
  # #                    {        |-->{ [S3]-->[j2]-->[E3]  }-->|        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {______finally________}   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   { [S4]-->[fj1]-->[E4] }   |        }
  # #                    {        |   {_____________________}   |        }
  # #                    {        |                             |        }
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {        |    _[jobnet1082-2]______    |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |-->{ [S5]-->[j3]-->[E5]  }-->|        }
  # #                    {            {                     }            }
  # #                    {            {______finally________}            }
  # #                    {            {                     }            }
  # #                    {            { [S6]-->[fj2]-->[E6] }            }
  # #                    {            {_____________________}            }
  # #                    {                                               }
  # #                    {_______________________________________________}
  # 
  # jobnet("jobnet1082", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     boot_jobs("jobnet1082-1","jobnet1082-2")
  #     jobnet("jobnet1082-1", :credential_name => "test_credential1-1") do 
  #       boot_jobs("j2")
  #       job("j2","$HOME/tengine_job_test.sh 0 j2")
  #       finally do 
  #         boot_jobs("fj1")
  #         job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #       end
  #     end
  #     jobnet("jobnet1082-2", :credential_name => "test_credential1-2") do 
  #       boot_jobs("j3")
  #       job("j3","$HOME/tengine_job_test.sh 0 j3")
  #       finally do 
  #         boot_jobs("fj2")
  #         job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1082
  シナリオ: [正常系]1082_Finallyにクレデンシャルが違うジョブネット(並列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 認証情報が名称:"test_credential1-1"で登録されている
    かつ 認証情報が名称:"test_credential1-2"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1082_finally_includes_parallel_jobnets_having_finally_and_different_credentials.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1082"を実行する
    かつ ジョブネット"jobnet1082"が完了することを確認する
    
    ならば ジョブネット"/jobnet1082" のステータスが正常終了であること
    かつ ジョブ"/jobnet1082/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1082/finally" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1082/finally/jobnet1082-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1082/finally/jobnet1082-1/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1082/finally/jobnet1082-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1082/finally/jobnet1082-1/finally/fj1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1082/finally/jobnet1082-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1082/finally/jobnet1082-2/j3" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1082/finally/jobnet1082-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1082/finally/jobnet1082-2/finally/fj2" のステータスが正常終了であること
    
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test j2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test j2 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ "tengine_job_test j3 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test j3 finish"と"スクリプトログ"に出力されており、"tengine_job_test j3 start"の後であること

    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test j3 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること

  
  # ./usecases/job/dsl/1083_finally_includes_parallel_jobnets_having_finally_and_different_server.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1083 Finallyに仮想サーバが違うジョブネット(並列)
  # # [jobnet1083]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     _______________finally________________________
  # #                    {                                               }
  # #                    {             _[jobnet1083-1]______             }
  # #                    {            {                     }            }
  # #                    {            {                     }            }
  # #                    {        |-->{ [S3]-->[j2]-->[E3]  }-->|        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {______finally________}   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   { [S4]-->[fj1]-->[E4] }   |        }
  # #                    {        |   {_____________________}   |        }
  # #                    {        |                             |        }
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {        |    _[jobnet1083-2]______    |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |-->{ [S5]-->[j3]-->[E5]  }-->|        }
  # #                    {            {                     }            }
  # #                    {            {______finally________}            }
  # #                    {            {                     }            }
  # #                    {            { [S6]-->[fj2]-->[E6] }            }
  # #                    {            {_____________________}            }
  # #                    {                                               }
  # #                    {_______________________________________________}
  # 
  # jobnet("jobnet1083", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     boot_jobs("jobnet1083-1","jobnet1083-2")
  #     jobnet("jobnet1083-1", :instance_name => "test_server2", :credential_name => "test_credential2") do 
  #       boot_jobs("j2")
  #       job("j2","$HOME/tengine_job_test.sh 0 j2")
  #       finally do 
  #         boot_jobs("fj1")
  #         job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #       end
  #     end
  #     jobnet("jobnet1083-2", :instance_name => "test_server3", :credential_name => "test_credential3") do 
  #       boot_jobs("j3")
  #       job("j3","$HOME/tengine_job_test.sh 0 j3")
  #       finally do 
  #         boot_jobs("fj2")
  #         job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1083
  シナリオ: [正常系]1083_Finallyに仮想サーバが違うジョブネット(並列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1083_finally_includes_parallel_jobnets_having_finally_and_different_server.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1083"を実行する
    かつ ジョブネット"jobnet1083"が完了することを確認する
    
    ならば ジョブネット"/jobnet1083" のステータスが正常終了であること
    かつ ジョブ"/jobnet1083/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1083/finally" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1083/finally/jobnet1083-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1083/finally/jobnet1083-1/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1083/finally/jobnet1083-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1083/finally/jobnet1083-1/finally/fj1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1083/finally/jobnet1083-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1083/finally/jobnet1083-2/j3" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1083/finally/jobnet1083-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1083/finally/jobnet1083-2/finally/fj2" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ1"に出力されており、"tengine_job_test j1 start"の後であること

    かつ 仮想サーバ"test_server2"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    かつ "tengine_job_test j2 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test j2 finish"と"スクリプトログ2"に出力されており、"tengine_job_test j2 start"の後であること
    かつ "tengine_job_test fj1 start"と"スクリプトログ2"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ 仮想サーバ"test_server2"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    かつ "tengine_job_test j3 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test j3 finish"と"スクリプトログ3"に出力されており、"tengine_job_test j3 start"の後であること
    かつ "tengine_job_test fj2 start"と"スクリプトログ3"に出力されており、"tengine_job_test j3 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test fj2 start"の後であること

    
  
  # ./usecases/job/dsl/1084_finally_includes_auto_sequence.rb
  #  ------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1084 Finallyにauto_sequenceを使用する
  # # [jobnet1084]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     __________finally___________
  # #                    {                            }
  # #                    {[S4]-->[fj1]-->[fj2]-->[E4] }
  # #                    {____________________________}
  # 
  # jobnet("jobnet1084", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     auto_sequence
  #     job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #     job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  #   end
  # end
  #  -------------------
  @success
  @1084
  シナリオ: [正常系]1084_Finallyにauto_sequenceを使用する_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1084_finally_includes_auto_sequence.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1084"を実行する
    かつ ジョブネット"jobnet1084"が完了することを確認する
    
    ならば ジョブネット"/jobnet1084" のステータスが正常終了であること
    かつ ジョブ"/jobnet1084/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1084/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1084/finally/fj1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1084/finally/fj2" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test fj1 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること

  
  # ./usecases/job/dsl/1085_finally_includes_boot_jobs.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1085 Finallyにboot_jobsを使用する
  # # [jobnet1085]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     __________finally___________
  # #                    {                            }
  # #                    {       |-->[fj1]-->|        }
  # #                    {       |           |        }
  # #                    {[S4]-->F           J-->[E4] }
  # #                    {       |           |        }
  # #                    {       |-->[fj2]-->|        }
  # #                    {____________________________}
  # 
  # jobnet("jobnet1085", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     boot_jobs("fj1","fj2")
  #     job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #     job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  #   end
  # end
  #  -------------------
  @success
  @1085
  シナリオ: [正常系]1085_Finallyにboot_jobsを使用する_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1085_finally_includes_boot_jobs.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1085"を実行する
    かつ ジョブネット"jobnet1085"が完了することを確認する
    
    ならば ジョブネット"/jobnet1085" のステータスが正常終了であること
    かつ ジョブ"/jobnet1085/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1085/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1085/finally/fj1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1085/finally/fj2" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること

  
  # ./usecases/job/dsl/1086_finally_includes_expansion.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1086 Finallyにexpansionを使用する
  # # [jobnet1086]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     _______________finally________________________
  # #                    {                                               }
  # #                    {             _[jobnet1086]________             }
  # #                    {            {                     }            }
  # #                    {            {                     }            }
  # #                    {        |-->{ [S3]-->[j2]-->[E3]  }-->|        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {______finally________}   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   { [S4]-->[fj1]-->[E4] }   |        }
  # #                    {        |   {_____________________}   |        }
  # #                    {        |                             |        }
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {        |    _[jobnet1086]________    |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |-->{ [S3]-->[j2]-->[E3]  }-->|        }
  # #                    {            {                     }            }
  # #                    {            {______finally________}            }
  # #                    {            {                     }            }
  # #                    {            { [S4]-->[fj1]-->[E4] }            }
  # #                    {            {_____________________}            }
  # #                    {                                               }
  # #                    {_______________________________________________}
  # 
  # jobnet("jobnet1086", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     auto_sequence
  #     expansion("jobnet1086-1")
  #     expansion("jobnet1086-2")
  #   end
  # end
  # 
  # jobnet("jobnet1086-1", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j2")
  #   job("j2","$HOME/tengine_job_test.sh 0 j2")
  #   finally do 
  #     boot_jobs("fj1")
  #     job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #   end
  # end
  # 
  # jobnet("jobnet1086-2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j3")
  #   job("j3","$HOME/tengine_job_test.sh 0 j3")
  #   finally do 
  #     boot_jobs("fj2")
  #     job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  #   end
  # end
  #  -------------------
  @success
  @1086
  シナリオ: [正常系]1086_Finallyにexpansionを使用する_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1086_finally_includes_expansion.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1086"を実行する
    かつ ジョブネット"jobnet1086"が完了することを確認する
    
    ならば ジョブネット"/jobnet1086" のステータスが正常終了であること
    かつ ジョブ"/jobnet1086/j1" のステータスが正常終了であること
    
    かつ ジョブネット"/jobnet1086/finally" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1086/finally/jobnet1086-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1086/finally/jobnet1086-1/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1086/finally/jobnet1086-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1086/finally/jobnet1086-1/finally/fj1" のステータスが正常終了であること

    かつ ジョブネット"/jobnet1086/finally/jobnet1086-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1086/finally/jobnet1086-2/j3" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1086/finally/jobnet1086-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1086/finally/jobnet1086-2/finally/fj2" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test j2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test j2 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ "tengine_job_test j3 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test j3 finish"と"スクリプトログ"に出力されており、"tengine_job_test j3 start"の後であること

    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test j3 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること


  # ./usecases/job/dsl/1087_finally_includes_invalid_option_value_in_jobnet.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1087 Finallyにjobnetのoptionに不正な値
  # # [jobnet1087]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     _______________finally_________________
  # #                    {                                       }
  # #                    {         _[jobnet1087]________         }
  # #                    {        {                     }        }
  # #                    {        {                     }        }
  # #                    { [S2]-->{ [S3]-->[j2]-->[E3]  }-->[E2] }
  # #                    {        {                     }        }
  # #                    {        {______finally________}        }
  # #                    {        {                     }        }
  # #                    {        { [S4]-->[fj1]-->[E4] }        }
  # #                    {        {_____________________}        }
  # #                    {                                       }
  # #                    {_______________________________________}
  # 
  # jobnet("jobnet1087", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     boot_jobs("jobnet1087")
  #     jobnet("jobnet1087", :hoge => "hoge") do 
  #       boot_jobs("j2")
  #       job("j2","$HOME/tengine_job_test.sh 0 j2")
  #       finally do 
  #         boot_jobs("fj1")
  #         job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @1087
  シナリオ: [正常系]1087_Finallyにjobnetのoptionに不正な値_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1087_finally_includes_invalid_option_value_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E8  #{value} is invalid option.
    ならば "Tengineコアプロセス"の標準出力に"hoge is invalid option."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること

  
  # ./usecases/job/dsl/1088_finally_includes_invalid_option_value_in_job.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1088 Finallyにjobのoptionに不正な値
  # # [jobnet1088]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     __________finally___________
  # #                    {                            }
  # #                    {       |-->[fj1]-->|        }
  # #                    {       |           |        }
  # #                    {[S4]-->F           J-->[E4] }
  # #                    {       |           |        }
  # #                    {       |-->[fj2]-->|        }
  # #                    {____________________________}
  # 
  # jobnet("jobnet1088", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     boot_jobs("fj1","fj2")
  #     job("fj1","$HOME/tengine_job_test.sh 0 fj1", :hoge => "hoge")
  #     job("fj2","$HOME/tengine_job_test.sh 0 fj2", :fuga => "fuga")
  #   end
  # end
  #  -------------------
  @1088
  シナリオ: [正常系]1088_Finallyにjobのoptionに不正な値_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1088_finally_includes_invalid_option_value_in_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E8  #{value} is invalid option.
    ならば "Tengineコアプロセス"の標準出力に"hoge is invalid option."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること

  
  # ./usecases/job/dsl/1089_finally_includes_invalid_option_value_in_expansion.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1089 Finallyにexpansionのoptionに不正な値
  # # [jobnet1089]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     _______________finally________________________
  # #                    {                                               }
  # #                    {             _[jobnet1089]________             }
  # #                    {            {                     }            }
  # #                    {            {                     }            }
  # #                    {        |-->{ [S3]-->[j2]-->[E3]  }-->|        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {______finally________}   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   { [S4]-->[fj1]-->[E4] }   |        }
  # #                    {        |   {_____________________}   |        }
  # #                    {        |                             |        }
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {        |    _[jobnet1089]________    |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |-->{ [S3]-->[j2]-->[E3]  }-->|        }
  # #                    {            {                     }            }
  # #                    {            {______finally________}            }
  # #                    {            {                     }            }
  # #                    {            { [S4]-->[fj1]-->[E4] }            }
  # #                    {            {_____________________}            }
  # #                    {                                               }
  # #                    {_______________________________________________}
  # 
  # jobnet("jobnet1089", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #     auto_sequence
  #     expansion("jobnet1089-1", :hoge => "hoge")
  #     expansion("jobnet1089-2", :fuga => "fuga")
  #   end
  # end
  # 
  # jobnet("jobnet1089-1", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j2")
  #   job("j2","$HOME/tengine_job_test.sh 0 j2")
  #   finally do 
  #     boot_jobs("fj1")
  #     job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  #   end
  # end
  # 
  # jobnet("jobnet1089-2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j3")
  #   job("j3","$HOME/tengine_job_test.sh 0 j3")
  #   finally do 
  #     boot_jobs("fj2")
  #     job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  #   end
  # end
  #  -------------------
  @1089
  シナリオ: [正常系]1089_Finallyにexpansionのoptionに不正な値_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1089_finally_includes_invalid_option_value_in_expansion.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E8  #{value} is invalid option.
    ならば "Tengineコアプロセス"の標準出力に"hoge is invalid option."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること

  
  # ./usecases/job/dsl/1090_finally_includes_no_job.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1090 Finallyにブロック内にコードがない
  # # [jobnet1090]
  # #
  # # [S1]-->[j1]-->[E1]
  # #                     __________finally___________
  # #                    {                            }
  # #                    {____________________________}
  # 
  # jobnet("jobnet1090", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1","$HOME/tengine_job_test.sh 0 j1")
  #   finally do
  #   end
  # end
  #  -------------------
  @1090
  シナリオ: [正常系]1090_Finallyにブロック内にコードがない_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1090_finally_includes_no_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1090"を実行する
    かつ ジョブネット"jobnet1090"が完了することを確認する
    
    ならば ジョブネット"/jobnet1090" のステータスが正常終了であること
    かつ ジョブ"/jobnet1090/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1090/finally" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

  
  # ./usecases/job/dsl/1091_rootjobnet_and_finally_include_parallel_jobnets_having_finally.rb
  #  -------------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # 1091 Finally付きのジョブネット(並列)を組み合わせた複雑なパターン
  # # [jobnet1091]
  # #
  # #            {-[jobnet1091-1]-------}
  # #            {                      }
  # #        |-->{  [S2]-->[j1]-->[E2]  }-->|
  # #        |   {                      }   |
  # #        |   {________finally_______}   |
  # #        |   {                      }   |
  # #        |   { [S3]-->[jf1]-->[E3]  }   |
  # #        |   {                      }   |
  # #        |   {----------------------}   |
  # #        |                              |
  # # [S1]-->F                              J-->[E1]
  # #        |                              |
  # #        |   {-[jobnet1091-2]-------}   |
  # #        |   {                      }   |
  # #        |-->{  [S4]-->[j2]-->[E4]  }-->|
  # #            {                      }
  # #            {________finally_______}
  # #            {                      }
  # #            { [S5]-->[jf2]-->[E5]  }
  # #            {                      }
  # #            {----------------------}
  # #
  # #                     _______________finally________________________
  # #                    {                                               }
  # #                    {             _[jobnet1091-3]______             }
  # #                    {            {                     }            }
  # #                    {            {                     }            }
  # #                    {        |-->{ [S7]-->[j3]-->[E7]  }-->|        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {______finally________}   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   { [S8]-->[fj3]-->[E8] }   |        }
  # #                    {        |   {_____________________}   |        }
  # #                    {        |                             |        }
  # #                    { [S6]-->F                             J-->[E6] }
  # #                    {        |    _[jobnet1091-4]______    |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |   {                     }   |        }
  # #                    {        |-->{ [S9]-->[j4]-->[E9]  }-->|        }
  # #                    {            {                     }            }
  # #                    {            {______finally________}            }
  # #                    {            {                     }            }
  # #                    {            {[S10]-->[fj4]-->[E10]}            }
  # #                    {            {_____________________}            }
  # #                    {                                               }
  # #                    {_______________________________________________}
  # 
  # jobnet("jobnet1091", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("jobnet1091-1","jobnet1091-2")
  #   jobnet("jobnet1091-1", :instance_name => "test_server2", :credential_name => "test_credential2") do 
  #     boot_jobs("j1")
  #     job("j1", "$HOME/tengine_job_test.sh 0 j1")
  #     finally do 
  #       boot_jobs("fj1")
  #       job("fj1", "$HOME/tengine_job_test.sh 0 fj1")
  #     end
  #   end
  #   jobnet("jobnet1091-2", :instance_name => "test_server3", :credential_name => "test_credential3") do 
  #     boot_jobs("j2")
  #     job("j2", "$HOME/tengine_job_test.sh 0 j2")
  #     finally do 
  #       boot_jobs("fj2")
  #       job("fj2", "$HOME/tengine_job_test.sh 0 fj2")
  #     end
  #   end
  #   finally do
  #     boot_jobs("jobnet1091-3","jobnet1091-4")
  #     jobnet("jobnet1091-3") do 
  #       boot_jobs("j3")
  #       job("j3","$HOME/tengine_job_test.sh 0 j3")
  #       finally do 
  #         boot_jobs("fj3")
  #         job("fj3","$HOME/tengine_job_test.sh 0 fj3")
  #       end
  #     end
  #     jobnet("jobnet1091-4") do 
  #       boot_jobs("j4")
  #       job("j4","$HOME/tengine_job_test.sh 0 j4")
  #       finally do 
  #         boot_jobs("fj4")
  #         job("fj4","$HOME/tengine_job_test.sh 0 fj4")
  #       end
  #     end
  #   end
  # end
  #  -------------------
  @success
  @1091
  シナリオ: [正常系]1091_Finally付きのジョブネット(並列)を組み合わせた複雑なパターン_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1091_rootjobnet_and_finally_include_parallel_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1091"を実行する
    かつ ジョブネット"jobnet1091"が完了することを確認する
    
    ならば ジョブネット"/jobnet1091" のステータスが正常終了であること
    
    かつ ジョブネット"/jobnet1091/jobnet1091-1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1091/jobnet1091-1/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1091/jobnet1091-1/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1091/jobnet1091-1/finally/fj1" のステータスが正常終了であること

    ならば ジョブネット"/jobnet1091" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1091/jobnet1091-2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1091/jobnet1091-2/j2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1091/jobnet1091-2/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1091/jobnet1091-2/finally/fj2" のステータスが正常終了であること

    かつ ジョブネット"/jobnet1091/finally" のステータスが正常終了であること
    
    かつ ジョブネット"/jobnet1091/finally/jobnet1091-3" のステータスが正常終了であること
    かつ ジョブ"/jobnet1091/finally/jobnet1091-3/j3" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1091/finally/jobnet1091-3/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1091/finally/jobnet1091-3/finally/fj3" のステータスが正常終了であること

    かつ ジョブネット"/jobnet1091/finally/jobnet1091-4" のステータスが正常終了であること
    かつ ジョブ"/jobnet1091/finally/jobnet1091-4/j4" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1091/finally/jobnet1091-4/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1091/finally/jobnet1091-4/finally/fj4" のステータスが正常終了であること

    かつ 仮想サーバ"test_server2"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    かつ "tengine_job_test j1 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test j1 start"の後であること
    かつ "tengine_job_test fj1 start"と"スクリプトログ2"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ 仮想サーバ"test_server3"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    かつ "tengine_job_test j2 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test j2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test j2 start"の後であること
    かつ "tengine_job_test fj2 start"と"スクリプトログ3"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test fj2 start"の後であること

    
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    かつ "tengine_job_test j3 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test j3 finish"と"スクリプトログ1"に出力されており、"tengine_job_test j3 start"の後であること
    かつ "tengine_job_test fj3 start"と"スクリプトログ1"に出力されており、"tengine_job_test j3 finish"の後であること
    かつ "tengine_job_test fj3 finish"と"スクリプトログ1"に出力されており、"tengine_job_test fj3 start"の後であること
    
    かつ "tengine_job_test j4 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test j4 finish"と"スクリプトログ1"に出力されており、"tengine_job_test j4 start"の後であること
    かつ "tengine_job_test fj4 start"と"スクリプトログ1"に出力されており、"tengine_job_test j4 finish"の後であること
    かつ "tengine_job_test fj4 finish"と"スクリプトログ1"に出力されており、"tengine_job_test fj4 start"の後であること


#------ failure ------


  @1101
  シナリオ: [正常系]1つのジョブが含まれるジョブネットが失敗
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1101_one_job_in_jobnet_failure.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"jobnet1101"を実行する
    かつ ジョブネット"jobnet1101"が完了することを確認する
    
    ならば ジョブネット"/jobnet1101" のステータスがエラー終了であること

    もし ジョブ"/jobnet1101/job1"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーメッセージ"に"Job process failed. STDOUT and STDERR were redirected to files. You can see them at #{標準出力のファイルパス} and #{標準エラー出力のファイルパス} on the server #{サーバ名}"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    かつ "tengine_job_failure_test job1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_failure_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_failure_test job1 start"の後であること


  # ../tengine_job/examples/0004_retry_one_layer.rb
  #  -------------------
  #  # -*- coding: utf-8 -*-
  #
  #require 'tengine_job'
  #
  ## [jn0004]
  ##               |-->[j2]-->
  ##               |         |
  ## [S1]-->[j1]-->          |-->[j4]-->[E1]
  ##               |-->[j3]-->
  ##                     _________finally________
  ##                    {                        }
  ##                    {[S2]-->[jn0004_f]-->[E2]}
  ##                    {________________________}
  ##                     
  # jobnet("jn0004", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1", "$HOME/0004_retry_one_layer.sh", :to => ["j2", "j3"])
  #   job("j2", "$HOME/0004_retry_one_layer.sh", :to => "j4")
  #   job("j3", "$HOME/0004_retry_one_layer.sh", :to => "j4")
  #   job("j4", "$HOME/0004_retry_one_layer.sh")
  #   finally do
  #     job("jn0004_f", "$HOME/0004_retry_one_layer.sh")
  #   end
  # end

  @1102
  シナリオ: [正常系]finally付きのジョブネットを試してみる_fork前で失敗
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0004"を事前実行コマンド"export J1_FAIL='true'"で実行する
    かつ ジョブネット"jn0004"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0004" のステータスがエラー終了であること
    かつ ジョブ"/jn0004/j1" のステータスがエラー終了であること
    かつ ジョブネット"/jn0004/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0004/finally/jn0004_f" のステータスが正常終了であること

    もし ジョブ"/jn0004/j1"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0004/j1 finish"と"スクリプトログ"に出力されていないこと

    かつ "tengine_job_test /jn0004/jn0004_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 start"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/jn0004_f start"の後であること


  @1103
  シナリオ: [正常系]finally付きのジョブネットを試してみる_fork後で片方が失敗
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0004"を事前実行コマンド"export J3_FAIL='true'"で実行する
    かつ ジョブネット"jn0004"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0004" のステータスがエラー終了であること
    かつ ジョブ"/jn0004/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0004/j2" のステータスが正常終了であること
    かつ ジョブ"/jn0004/j3" のステータスがエラー終了であること
    かつ ジョブネット"/jn0004/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0004/finally/jn0004_f" のステータスが正常終了であること

    もし ジョブ"/jn0004/j3"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0004/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 start"の後であること
    かつ "tengine_job_test /jn0004/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 finish"の後であること
    かつ "tengine_job_test /jn0004/j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j2 start"の後であること
    かつ "tengine_job_test /jn0004/j3 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 finish"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0004/j3 start"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0004/jn0004_f start"の後であること


  @1104
  シナリオ: [正常系]finally付きのジョブネットを試してみる_fork後で両方が失敗
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0004"を事前実行コマンド"export J2_FAIL='true' && export J3_FAIL='true'"で実行する
    かつ ジョブネット"jn0004"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0004" のステータスがエラー終了であること
    かつ ジョブ"/jn0004/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0004/j2" のステータスがエラー終了であること
    かつ ジョブ"/jn0004/j3" のステータスがエラー終了であること
    かつ ジョブネット"/jn0004/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0004/finally/jn0004_f" のステータスが正常終了であること

    もし ジョブ"/jn0004/j2"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること

    もし ジョブ"/jn0004/j3"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0004/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 start"の後であること
    かつ "tengine_job_test /jn0004/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 finish"の後であること
    かつ "tengine_job_test /jn0004/j3 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 finish"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0004/j2 start"と"tengine_job_test /jn0004/j3 start"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0004/jn0004_f start"の後であること



  # ../tengine_job/examples/0005_retry_two_layer.rb
  #  -------------------
  # -*- coding: utf-8 -*-
  #
  #require 'tengine_job'
  #
  # [jn0005]
  #                     ________________[jn4]________________
  #                   {                                          }
  #                   {               |-->[j42]-->               }
  #                   {               |          |               }
  # [S1]-->[j1]-->F-->{ [S2]-->[j41]-->          |-->[j44]-->[E2]}-->J--[j4]-->[E1]
  #               |   {               |-->[j43]-->               }   |
  #               |   {         __________finally__________      }   |
  #               |   {        { [S3]-->[jn4_f]-->[E3] }     }   |
  #               |   { _________________________________________}   |
  #                 |-------------------->[j2]------------------------>|
  #
  #   ________________________________finally________________________________
  #  {         _____________________jn0005_fjn__________                     }
  #  {        {                                         }                    }
  #  {        { [S5]-->[jn0005_f1]-->[jn0005_f2]-->[E5] }                    }
  #  { [S4]-->{                                         }-->[jn0005_f]-->[E4]}
  #  {        {      ____________finally________        }                    }
  #  {        {      {[S6]-->[jn0005_fif]-->[E6]}       }                    }
  #  {        {_________________________________________}                    }
  #  { ______________________________________________________________________}
  # jobnet("jn0005", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1", "$HOME/0005_retry_two_layer.sh", :to => ["j2", "jn4"])
  #   job("j2", "$HOME/0005_retry_two_layer.sh", :to => "j4")
  #   jobnet("jn4", :to => "j4") do
  #     boot_jobs("j41")
  #     job("j41", "$HOME/0005_retry_two_layer.sh", :to => ["j42", "j43"])
  #     job("j42", "$HOME/0005_retry_two_layer.sh", :to => "j44")
  #     job("j43", "$HOME/0005_retry_two_layer.sh", :to => "j44")
  #     job("j44", "$HOME/0005_retry_two_layer.sh")
  #     finally do
  #       job("jn4_f", "$HOME/0005_retry_two_layer.sh")
  #     end
  #   end
  #   job("j4", "$HOME/0005_retry_two_layer.sh")
  #   finally do
  #     boot_jobs("jn0005_fjn")
  #     jobnet("jn0005_fjn", :to => "jn0005_f") do
  #       boot_jobs("jn0005_f1")
  #       job("jn0005_f1", "$HOME/0005_retry_two_layer.sh", :to => ["jn0005_f2"])
  #       job("jn0005_f2", "$HOME/0005_retry_two_layer.sh")
  #       finally do
  #         job("jn0005_fif","$HOME/0005_retry_two_layer.sh")
  #       end 
  #     end
  #     job("jn0005_f", "$HOME/0005_retry_two_layer.sh")
  #   end
  # end
  #  -------------------
  @1105
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する
  
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export J41_FAIL='true'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f" のステータスが正常終了であること

    もし ジョブ"/jn0005/jn4/j41"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j2 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/j41 start"後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/finally/jn0004_f start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 finish"と"tengine_job_test  /jn0005/jn4/finally/jn4_f finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test  /jn0005/finally/jn0005_fjn/jn0005_f2 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"の後であること


  @1106
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する_fork後片方

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export J43_FAIL='true'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j42" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j43" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f" のステータスが正常終了であること

    もし ジョブ"/jn0005/jn4/j43"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j2 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j43 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j43 start"後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/finally/jn0004_f start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 finish"と"tengine_job_test /jn0005/jn4/finally/jn4_f finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test  /jn0005/finally/jn0005_fjn/jn0005_f2 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"の後であること

  @1107
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する_fork後片方_ジョブネット外のfork後片方

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export J2_FAIL='true' && export J43_FAIL='true' && export J2_SLEEP='5' && export JN4_F_SLEEP='10'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j42" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j43" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f" のステータスが正常終了であること

    もし ジョブ"/jn0005/j2"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること

    もし ジョブ"/jn0005/jn4/j43"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/j2 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j43 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j43 start"後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/finally/jn0004_f start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 start"と"tengine_job_test /jn0005/jn4/finally/jn4_f finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test  /jn0005/finally/jn0005_fjn/jn0005_f2 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"の後であること


  @1108
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する_finallyがエラー終了

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export JN4_F_FAIL='true'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j42" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j43" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j44" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f" のステータスが正常終了であること

    もし ジョブ"/jn0005/jn4/finally/jn4_f"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j43 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j44 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j42 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j44 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j44 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j44 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 finish"と"tengine_job_test /jn0005/jn4/finally/jn4_f start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test  /jn0005/finally/jn0005_fjn/jn0005_f2 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"の後であること



  @1109
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する_finally内のfinallyを持つジョブネット内のジョブがエラー終了

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export JN0005_F1_FAIL='true'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j42" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j43" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j44" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが初期化済であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f"のステータスが初期化済であること

    もし ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j43 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j44 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j42 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j44 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j44 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j44 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/jn4_f start"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j43 start"後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/finally/jn0004_f start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 finish"と"tengine_job_test /jn0005/jn4/finally/jn4_f finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されていないこと


  # ------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # finallyを追加する
  # # [jn0006]
  # #          __________________________[jn1]____________________________        ______________[jn2]_____________________________________
  # #         {          __________[jn11]_______________                  }     {                 _____________[jn22]____________         }
  # #         {         {                               }                 }     {                {                              }         } 
  # #  [S1]-->{ [S2]--> { [S3]-->[j111]-->[j112]-->[E3] } -->[j12]-->[E2] } --> { [S6]-->[j21]-->{ [S7]-->[j221]-->[j222]-->[E7]} -->[E6] } -->[E1] 
  # #         {         {                               }                 }     {                {                              }         }
  # #         {         {   _______finally_______       }                 }     {                {  _________finally_______     }         }
  # #         {         {  {[S4]-->[jn11_f]-->[E4]}     }                 }     {                {  {[S8]-->[jn22_f]-->[E8]}    }         }
  # #         {         {_______________________________}                 }     {                {______________________________}         }
  # #         {                                                           }     {                                                         }
  # #         {                                   _______finally_______   }     {                               _______finally_______     }
  # #         {                                  {[S5]-->[jn1_f]-->[E5]}  }     {                             {[S9]-->[jn2_f]-->[E9]}     }
  # #         {___________________________________________________________}     {_________________________________________________________}
  # #
  # #                                                                                           _______finally_______
  # #                                                                                          {[S10]-->[jn_f]-->[E10]}
  # #
  # jobnet("jn0006", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("jn1")
  #   jobnet("jn1", :to => "jn2") do
  #    boot_jobs("j11")
  #    jobnet("j11", :to => "j12") do
  #      boot_jobs("j111")
  #      job("j111", "$HOME/0006_retry_three_layer.sh",:to => "j112")
  #      job("j112", "$HOME/0006_retry_three_layer.sh" )
  #      finally do
  #        job("jn11_f","$HOME/0006_retry_three_layer.sh")
  #      end
  #    end
  #    job("j12", "$HOME/0006_retry_three_layer.sh")    
  #    finally do
  #      job("jn1_f","$HOME/0006_retry_three_layer.sh")
  #    end
  #   end
  #   jobnet("jn2") do
  #    boot_jobs("j21")
  #    job("j21", "$HOME/0006_retry_three_layer.sh", :to => "j22")    
  #    jobnet("j22") do
  #      boot_jobs("j221")
  #      job("j221", "$HOME/0006_retry_three_layer.sh",:to => "j222")
  #      job("j222", "$HOME/0006_retry_three_layer.sh" )
  #      finally do
  #        job("jn22_f","$HOME/0006_retry_three_layer.sh")
  #      end
  #    end
  #    finally do
  #      job("jn2_f","0006_retry_three_layer.sh")
  #    end
  #   end
  #   finally do 
  #     job("jn_f","$HOME/0006_retry_three_layer.sh")
  #   end
  # end
  @1110
  シナリオ: [正常系]ジョブネット内ジョブネット内のジョブが失敗する

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0006_retry_three_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0006"を事前実行コマンド"export J111_FAIL='true'"で実行する
    かつ ジョブネット"jn0006"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0006" のステータスがエラー終了であること
    かつ ジョブネット"/jn0006/jn1/" のステータスがエラー終了であること
    かつ ジョブネット"/jn0006/jn1/jn11" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/jn11/j111" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/jn11/j112" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn1/jn11/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/jn11/finally/jn11_f" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/j12" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn1/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/finally/jn1_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0006/jn2/" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/j21" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn2/jn22" のステータスが初期化済終了であること
    かつ ジョブ"/jn0006/jn2/jn22/j221" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22/j222" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22//finally/jn22_f" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/finally/jn2_f" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/finally/jn_f" のステータスが正常終了であること

    もし ジョブ"/jn0006/jn1/jn11/j111"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test /jn0006/jn1/jn11/j111 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0006/jn1/jn11/j111 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn1/jn11/j112 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn1/jn11/finally/jn11_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j111 start"の後であること
    かつ "tengine_job_test /jn0006/jn1/jn11/finally/jn11_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/j1/jn11/finally/jn11_f start"の後であること
    かつ "tengine_job_test /jn0006/jn1/j12 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn1/finally/jn1_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/finally/jn11_f finish"の後であること
    かつ "tengine_job_test /jn0006/jn1/finally/jn1_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/finally/jn1_f start"の後であること
    かつ "tengine_job_test /jn0006/jn2/j21 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/j221 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/jn222 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/finally/jn22_f start"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/finally/jn2_f finish"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0006/finally/jn_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0006/jn1/finally/jn1_f finish"の後であること
    かつ "tengine_job_test /jn0006/finally/jn_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0006/finally/jn_f start"の後であること


  @1111
  シナリオ: [正常系]jn0006_ジョブネット内ジョブネット内のfinally内のジョブが失敗する

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0006_retry_three_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0006"を事前実行コマンド"export JN11_F_FAIL='true'"で実行する
    かつ ジョブネット"jn0006"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0006" のステータスがエラー終了であること
    かつ ジョブネット"/jn0006/jn1/" のステータスがエラー終了であること
    かつ ジョブネット"/jn0006/jn1/jn11" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/jn11/j111" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/jn11/j112" のステータスが正常終了であること
    かつ ジョブネット"/jn0006/jn1/jn11/finally" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/jn11/finally/jn11_f" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/j12" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn1/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/finally/jn1_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0006/jn2/" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/j21" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn2/jn22" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22/j221" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22/j222" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22/finally/jn22_f" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/finally/jn2_f" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/finally/jn_f" のステータスが正常終了であること

    もし ジョブ"/jn0006/jn1/jn11/j111"の"ジョブ詳細"リンクをクリックする
    ならば "ジョブ詳細画面"が表示していること
    かつ "エラーの原因"に"スクリプトが異常終了した"と表示されていること
  
    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test /jn0006/jn1/jn11/j111 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0006/jn1/jn11/j111 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j111 start"の後であること
    かつ "tengine_job_test /jn0006/jn1/jn11/j112 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j111 finish"の後であること
    かつ "tengine_job_test /jn0006/jn1/jn11/j112 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j112 start"の後であること
    かつ "tengine_job_test /jn0006/jn1/jn11/finally/jn11_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j112 start"の後であること
    かつ "tengine_job_test /jn0006/jn1/j12 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn1/finally/jn1_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/finally/jn11_f finish"の後であること
    かつ "tengine_job_test /jn0006/jn1/finally/jn1_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/finally/jn1_f start"の後であること
    かつ "tengine_job_test /jn0006/jn2/j21 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/j221 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/jn222 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/finally/jn22_f start"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/finally/jn2_f finish"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0006/finally/jn_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0006/jn1/finally/jn1_f finish"の後であること
    かつ "tengine_job_test /jn0006/finally/jn_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0006/finally/jn_f start"の後であること
