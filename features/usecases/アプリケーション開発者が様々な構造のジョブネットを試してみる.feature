#language:ja
機能: アプリケーション開発者が様々な構造のジョブネットを試してみる

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

  # ./usecases/job/dsl/01_01_01_one_job_in_jobnet.rb
  # -------------------
  # require 'tengine_job'
  #
  # jobnet("jobnet1001", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "~/tengine_job_test.sh 0 'job1'")
  # end
  # -------------------
  #
  @01_01_01
  シナリオ: [正常系]1つのジョブが含まれるジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_01_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
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
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
    
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"tengine_job_runログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"tengine_job_runログ"に出力されていること
    かつ "tengine_job_test job1 finish"と"tengine_job_runログ"に出力されており、"tengine_job_test job1 start"の後であること

  # ./usecases/job/dsl/01_01_02_series_jobs_in_jobnet.rb
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
  
  @01_01_02
  シナリオ: [正常系]複数のジョブ(直列)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_02_series_jobs_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/01_01_03_parallel_jobs_in_jobnet.rb
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
  
  @01_01_03
  シナリオ: [正常系]複数のジョブ(並列)が含まれるジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_03_parallel_jobs_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1003"を実行する
    かつ ジョブネット"jobnet1003"が完了することを確認する
    
    ならば ジョブネット"/jobnet1003" のステータスが正常終了であること
    かつ ジョブ"/jobnet1003/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1003/job2" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること
    ならば "tengine_job_test job2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"の後であること

  
  # ./usecases/job/dsl/01_01_04_hadoop_job_in_jobnet.rb
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
  
  @01_01_04
  シナリオ: [正常系]hadoopジョブが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_04_hadoop_job_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1004"を実行する
    かつ ジョブネット"jobnet1004"が完了することを確認する
    
    ならば ジョブネット"/jobnet1004" のステータスが正常終了であること
    かつ ジョブ"/jobnet1004/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1004/hadoop_job_run1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1004/job2" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test import_hdfs start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test import_hdfs finish"と"スクリプトログ"に出力されており、"tengine_job_test import_hdfs start"と"tengine_job_test hadoop_job_run start"の間であること
    かつ "tengine_job_test hadoop_job_run start"と"スクリプトログ"に出力されており、"tengine_job_test import_hdfs start"と"tengine_job_test hadoop_job_run finish"の間であること
    かつ "tengine_job_test hadoop_job_run finish"と"スクリプトログ"に出力されており、"tengine_job_test hadoop_job_run start"と"tengine_job_test export_hdfs start"の間であること
    かつ "tengine_job_test export_hdfs start"と"スクリプトログ"に出力されており、"tengine_job_test hadoop_job_run finish"と"tengine_job_test export_hdfs finish"の間であること
    かつ "tengine_job_test export_hdfs finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/01_01_05_finally_in_jobnet.rb
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
  
  @01_01_05
  シナリオ: [正常系]finallyが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_05_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1005"を実行する
    かつ ジョブネット"jobnet1005"が完了することを確認する
    
    ならば ジョブネット"/jobnet1005" のステータスが正常終了であること
    かつ ジョブ"/jobnet1005/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1005/finally/jobnet1005_finally" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test jobnet1005_finally start"の間であること
    かつ "tengine_job_test jobnet1005_finally start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test jobnet1005_finally finish"の間であること
    かつ "tengine_job_test jobnet1005_finally finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/01_01_06_expansion_in_jobnet.rb
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
  
  @01_01_06
  シナリオ: [正常系]expansionが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_06_expansion_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006"を実行する
    かつ ジョブネット"jobnet1006"が完了することを確認する
    
    ならば ジョブネット"/jobnet1006" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job3" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/01_01_07_expansion_in_jobnet_x2.rb
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
  
  @01_01_07
  シナリオ: [正常系]expansionされたジョブネット内で更にexpansionされているジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_07_expansion_in_jobnet_x2.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006_2"を実行する
    かつ ジョブネット"jobnet1006_2"が完了することを確認する
    
    ならば ジョブネット"/jobnet1006_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2_2/jobnet1006_2_3/job3" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job4" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"に出力されており、"tengine_job_test job3 start"と"tengine_job_test job4 start"の間であること
    かつ "tengine_job_test job4 start"と"スクリプトログ"に出力されており、"tengine_job_test job3 finish"と"tengine_job_test job4 finish"の間であること
    かつ "tengine_job_test job4 finish"と"スクリプトログ"の末尾に出力されていること

  # ./usecases/job/dsl/01_01_08_expansion_in_jobnet_2.rb
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
  @01_01_08
  シナリオ: [正常系]expansionで指定するジョブネット名が、以前のtengined起動時に読み込んでいたジョブネット名と被っている場合でも同じバージョンのジョブネットが利用される
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_06_expansion_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_08_expansion_in_jobnet_2.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006"を実行する
    かつ ジョブネット"jobnet1006"がエラー終了することを確認する
    かつ job2の実行スクリプトが"exit 1"になっていること

  @manual
  @01_01_09
  シナリオ: [正常系]expansionで指定するジョブネット名が、以前のtengined起動時に読み込んでいたジョブネット名と被っている場合でも同じバージョンのジョブネットが利用される_パターン2
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_07_expansion_in_jobnet_x2.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006_2"を実行する
    かつ ジョブネット"jobnet1006_2"が完了することを確認する
    かつ ジョブネット"/jobnet1006_2/jobnet1006_2_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006_2/jobnet1006_2_2/job2" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1006_2/jobnet1006_2_2/jobnet1006_2_3" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006_2/jobnet1006_2_2/jobnet1006_2_3/job3" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006_2/job4" のステータスが正常終了であること

    もし "Tengineコアプロセス"の停止を行うために"tengined -k stop"というコマンドを実行する
    ならば "Tengineコアプロセス"が停止していることをPIDを用いて"ps -o pid -o stat | grep PID"というコマンドで確認できること
   
    もし テストを行うために"mv ./usecases/job/dsl/01_01_07_expansion_in_jobnet_x2.rb ./usecases/job/dsl/01_01_07_expansion_in_jobnet_x2.rb_tmp"というコマンドを実行する 
   
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_08_expansion_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1006"を実行する
    かつ ジョブネット"jobnet1006"が完了することを確認する
    かつ ジョブ"/jobnet1006/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/jobnet1006_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1006/job3" のステータスが正常終了であること

    もし 後始末を行うために"mv ./usecases/job/dsl/01＿01＿07_expansion_in_jobnet_x2.rb_tmp ./usecases/job/dsl/01_01_07_expansion_in_jobnet_x2.rb"というコマンドを実行する 


  # ./usecases/job/dsl/01_01_10_boot_jobs_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1007", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
  #  -------------------
  
  @01_01_10
  シナリオ: [正常系]boot_jobsが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_10_boot_jobs_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1007"を実行する
    かつ ジョブネット"jobnet1007"が完了することを確認する
    
    ならば ジョブネット"/jobnet1007" のステータスが正常終了であること
    かつ ジョブ"/jobnet1007/job1" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"の末尾に出力されていること
  
  # ./usecases/job/dsl/01_01_11_auto_sequence_in_jobnet.rb
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
  
  @01_01_11
  シナリオ: [正常系]auto_sequenceが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_11_auto_sequence_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1008"を実行する
    かつ ジョブネット"jobnet1008"が完了することを確認する
    
    ならば ジョブネット"/jobnet1008" のステータスが正常終了であること
    かつ ジョブ"/jobnet1008/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1008/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1008/job3" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/01_01_12_2_layer_in_jobnet.rb
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
  
  @01_01_12
  シナリオ: [正常系]入れ子(2階層)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_12_2_layer_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1009"を実行する
    かつ ジョブネット"jobnet1009"が完了することを確認する
    
    ならば ジョブネット"/jobnet1009" のステータスが正常終了であること
    かつ ジョブ"/jobnet1009/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1009/jobnet1009_2/job2" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/01_01_13_3_layer_in_jobnet.rb
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
  
  @01_01_13
  シナリオ: [正常系]入れ子(3階層)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_13_3_layer_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1010"を実行する
    かつ ジョブネット"jobnet1010"が完了することを確認する
    
    ならば ジョブネット"/jobnet1010" のステータスが正常終了であること
    かつ ジョブ"/jobnet1010/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1010/jobnet1010_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1010/jobnet1010_2/jobnet1010_3/job3" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/01_01_14_2_layer_finally_in_jobnet.rb
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
  
  @01_01_14
  シナリオ: [正常系]入れ子(2階層)のfinallyが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_14_2_layer_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1011"を実行する
    かつ ジョブネット"jobnet1011"が完了することを確認する
    
    ならば ジョブネット"/jobnet1011" のステータスが正常終了であること
    かつ ジョブ"/jobnet1011/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1011/finally/jobnet1011_2/job2" のステータスが正常終了であること
                                   
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"の末尾に出力されていること

  
  # ./usecases/job/dsl/01_01_15_3_layer_finally_in_jobnet.rb
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
  
  @01_01_15
  シナリオ: [正常系]入れ子(3階層)のfinallyが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_15_3_layer_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1012"を実行する
    かつ ジョブネット"jobnet1012"が完了することを確認する
    
    ならば ジョブネット"/jobnet1012" のステータスが正常終了であること
    かつ ジョブ"/jobnet1012/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1012/finally/jobnet1012_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1012/finally/jobnet1012_2/jobnet1012_3/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること

  

  # ./usecases/job/dsl/01_01_16_3_rayer_complicated_in_jobnet.rb
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
  
  @01_01_16
  シナリオ: [正常系]入れ子の中でinstanceとcredential_nameが違うジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_16_3_rayer_complicated_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する
    かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    かつ ジョブネット"jobnet1013"を実行する
    かつ ジョブネット"jobnet1013"が完了することを確認する
    
    ならば ジョブネット"/jobnet1013" のステータスが正常終了であること
    かつ ジョブ"/jobnet1013/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1013/jobnet1013_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1013/jobnet1013_2/jobnet1013_3/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ1"に出力されており、"tengine_job_test job1 start"の後であること
    
    もし 仮想サーバ"test_server2"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    ならば "tengine_job_test job2 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test job2 finish"と"スクリプトログ2"に出力されており、"tengine_job_test job2 start"の後であること

    もし 仮想サーバ"test_server3"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    ならば "tengine_job_test job3 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test job3 finish"と"スクリプトログ3"に出力されており、"tengine_job_test job3 start"の後であること

  
  # ./usecases/job/dsl/01_01_17_3_layer_complicated_finally_in_jobnet.rb
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
  
  @01_01_17
  シナリオ: [正常系]finallyの入れ子の中でinstanceとcredential_nameが違うジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_17_3_layer_complicated_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する
    かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    かつ ジョブネット"jobnet1014"を実行する
    かつ ジョブネット"jobnet1014"が完了することを確認する
    
    ならば ジョブネット"/jobnet1014" のステータスが正常終了であること
    かつ ジョブ"/jobnet1014/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1014/finally/jobnet1014_2/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1014/finally/jobnet1014_2/jobnet1014_3/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ1"に出力されており、"tengine_job_test job1 start"の後であること
    
    もし 仮想サーバ"test_server2"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    ならば "tengine_job_test job2 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test job2 finish"と"スクリプトログ2"に出力されており、"tengine_job_test job2 start"の後であること

    もし 仮想サーバ"test_server3"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    ならば "tengine_job_test job3 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test job3 finish"と"スクリプトログ3"に出力されており、"tengine_job_test job3 start"の後であること


  

  # ./usecases/job/dsl/01_01_18_complicated_jobnet_1.rb
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
  
  @01_01_18
  シナリオ: [正常系]複雑なジョブネット１_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_18_complicated_jobnet_1.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。

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
  

  @01_01_19
  シナリオ: [正常系]Asakusaが出力したジョブネットを試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1016_large_and_complicated_jobnet_asakusa -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"expand_root_jobnet.001"を実行する
    かつ ジョブネット"expand_root_jobnet.001"が完了することを確認する。およそ1800秒間は待つ。

    ならば ジョブを実行してから、最初のジョブが実行されるまでの時間が1分以内であること
    ならば ジョブネット"/expand_root_jobnet.001" のステータスが正常終了であること


  # ./usecases/job/dsl/01_01_20_hadoop_job_in_jobnet.rb
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
  @01_01_20
  シナリオ: [正常系]jobnetにhadoop_jobが含まれる_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_20_hadoop_job_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E1  jobnet block contains unexpected method(hadoop_job).
    ならば "Tengineコアプロセス"の標準出力に"jobnet block contains unexpected method(hadoop_job)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/01_01_21_job_in_hadoop_job_run.rb
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
  @01_01_21
  シナリオ: [正常系]hadoop_job_run にjobが含まれる_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_21_job_in_hadoop_job_run.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E2  hadoop_job_run block contains unexpected method(job).
    ならば "Tengineコアプロセス"の標準出力に"hadoop_job_run block contains unexpected method(job)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/01_01_22_hadoop_job_in_finally.rb
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
  @01_01_22
  シナリオ: [正常系]finally にhadoop_jobが含まれる_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_22_hadoop_job_in_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E3  finally block contains unexpected method(hadoop_job).
    ならば "Tengineコアプロセス"の標準出力に"finally block contains unexpected method(hadoop_job)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/01_01_23_finally_in_finally.rb
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
  @01_01_23
  シナリオ: [正常系]finally にfinallyが含まれる_を試してみる
  
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_23_finally_in_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E4  finally block contains unexpected method(finally).
    ならば "Tengineコアプロセス"の標準出力に"finally block contains unexpected method(finally)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること

  # ./usecases/job/dsl/01_01_24_no_job_or_hadoop_job_run_in_jobnet.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1031", :instance_name => "test_server1", :credential_name => "test_credential1") do
  # end
  #  -------------------
  @01_01_24
  シナリオ: [正常系]job/hadoop_job_runが1つもない_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_24_no_job_or_hadoop_job_run_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1031"を実行する
    かつ ジョブネット"jobnet1031"が完了することを確認する
    
    ならば ジョブネット"/jobnet1031" のステータスが正常終了であること


  # ./usecases/job/dsl/01_01_25_dsl_version_in_dsl.rb
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
  @01_01_25
  シナリオ: [正常系]ジョブネット定義内でdsl_versionを利用する
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_25_dsl_version_in_dsl.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/01_01_26_loop_job.rb
  #  -------------------
  # require 'tengine_job'
  #
  # jobnet("jobnet1051", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "job2")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2", :to => "job1")
  # end
  # -------------------
  #
  @01_01_26
  シナリオ: [正常系]循環参照するジョブを読み込ませてみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_26_loop_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力に"circular dependency"と表示されていること
    かつ "Tengineコアプロセス"の標準出力に"Tengine::Job::DslError"と表示されていること
 

  # ./usecases/job/dsl/01_01_27_loop_expansion_job.rb
  #  -------------------
  #
  # jobnet("jobnet1052", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "jobnet1052_2")
  #   expansion("jobnet1052_2", :to => "jobnet1052_3")
  #   expansion("jobnet1052_3", :to => "jobnet1052_2")
  # end
  # jobnet("jobnet1052_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job2")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  # end
  # jobnet("jobnet1052_3", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job3")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job2")
  # end
  # -------------------
  #
  @01_01_27
  シナリオ: [正常系]循環参照するexpansionのジョブを読み込ませてみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_27_loop_expansion_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    ならば "Tengineコアプロセス"の標準出力に"circular dependency"と表示されていること
    かつ "Tengineコアプロセス"の標準出力に"Tengine::Job::DslError"と表示されていること

  # ./usecases/job/dsl/01_01_28_loop_expansion_job_to_expansion_job.rb
  #  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1053", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "jobnet1053_2")
  #   expansion("jobnet1053_2", :to => "job3")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  # jobnet("jobnet1053_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job2")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2", :to => "jobnet1053")
  #   expansion("jobnet1053")
  # end
  # -------------------
  #
  @01_01_28
  シナリオ: [正常系]expansionされるジョブネット内で、expansion元のジョブネットをexpansionで指定して循環したジョブを読み込ませてみる
    #MM1の頃の仕様と合わせるべきだが、TengineでどのようにMM1の頃の仕様を表現するかは未決定。対応時期も未定のため、featureは作成していません


  # ./usecases/job/dsl/01_01_29_rootjobnet_includes_parallel_jobs.rb
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
  # # [S1]-->|            |-->[E1]|
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
  
  @01_01_29
  シナリオ: [正常系]ルートジョブネットが複数のジョブ(並列)を含むジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_29_rootjobnet_includes_parallel_jobs.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1071"を実行する
    かつ ジョブネット"jobnet1071"が完了することを確認する
    
    ならば ジョブネット"/jobnet1071" のステータスが正常終了であること
    かつ ジョブ"/jobnet1071/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1071/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1071/finally/jobnet1071_finally" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"の後であること

    かつ "tengine_job_test jobnet1071_finally start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"の後であること
    かつ "tengine_job_test jobnet1071_finally start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"の後であること
    かつ "tengine_job_test jobnet1071_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1071_finally start"の後であること


  # ./usecases/job/dsl/01_01_30_rootjobnet_includes_one_jobnet_having_finally.rb
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
  
  @01_01_30
  シナリオ: [正常系]ルートジョブネットがFinally付きのジョブネット１つ_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_30_rootjobnet_includes_one_jobnet_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること

    かつ "tengine_job_test jobnet1072-1_finally start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"の後であること
    かつ "tengine_job_test jobnet1072-1_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1072-1_finally start"の後であること

    かつ "tengine_job_test jobnet1072_finally start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1072-1_finally finish"の後であること
    かつ "tengine_job_test jobnet1072_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1072_finally start"の後であること

  

  # ./usecases/job/dsl/01_01_31_rootjobnet_includes_serial_jobnets_having_finally.rb
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
  
  @01_01_31
  シナリオ: [正常系]ルートジョブネットがFinally付きのジョブネット(直列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_31_rootjobnet_includes_serial_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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

  # ./usecases/job/dsl/01_01_32_rootjobnet_includes_parallel_jobnets_having_finally.rb
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
  # #|-->{  [S2]-->[j1]-->[E2]  }-->|
  # #|   {                      }   |
  # #|   {________finally_______}   |
  # #|   {                      }   |
  # #|   { [S3]-->[jf1]-->[E3]  }   |
  # #|   {                      }   |
  # #|   {----------------------}   |
  # #|                              |
  # # [S1]-->F                              J-->[E1]
  # #|                              |
  # #|   {-[jobnet1074-2]-------}   |
  # #|   {                      }   |
  # #|-->{  [S4]-->[j2]-->[E4]  }-->|
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
  
  @01_01_32
  シナリオ: [正常系]ルートジョブネットがFinally付きのジョブネット(並列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_32_rootjobnet_includes_parallel_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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


  
  # ./usecases/job/dsl/01_01_33_rootjobnet_includes_3_layers_jobnets_having_finally.rb
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
  
  @01_01_33
  シナリオ: [正常系]ルートジョブネットがFinally付きのジョブネット入れ子3層_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_33_rootjobnet_includes_3_layers_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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

  
  # ./usecases/job/dsl/01_01_34_rootjobnet_includes_parallel_jobnets_having_finally_and_different_credentials.rb
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
  # #|-->{  [S2]-->[j1]-->[E2]  }-->|
  # #|   {                      }   |
  # #|   {________finally_______}   |
  # #|   {                      }   |
  # #|   { [S3]-->[jf1]-->[E3]  }   |
  # #|   {                      }   |
  # #|   {----------------------}   |
  # #|                              |
  # # [S1]-->F                              J-->[E1]
  # #|                              |
  # #|   {-[jobnet1076-2]-------}   |
  # #|   {                      }   |
  # #|-->{  [S4]-->[j2]-->[E4]  }-->|
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
  
  @01_01_34
  シナリオ: [正常系]ルートジョブネットがクレデンシャルが違うジョブネット(並列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 認証情報が名称:"test_credential1-1"で登録されている
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_34_rootjobnet_includes_parallel_jobnets_having_finally_and_different_credentials.rb  -f ./features/config/tengined.yml.erb"というコマンドを実行する
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

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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

  
  # ./usecases/job/dsl/01_01_35_rootjbonet_includes_parallel_jobnets_having_finally_and_different_server.rb
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
  # #|-->{  [S2]-->[j1]-->[E2]  }-->|
  # #|   {                      }   |
  # #|   {________finally_______}   |
  # #|   {                      }   |
  # #|   { [S3]-->[jf1]-->[E3]  }   |
  # #|   {                      }   |
  # #|   {----------------------}   |
  # #|                              |
  # # [S1]-->F                              J-->[E1]
  # #|                              |
  # #|   {-[jobnet1077-2]-------}   |
  # #|   {                      }   |
  # #|-->{  [S4]-->[j2]-->[E4]  }-->|
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
  
  @01_01_35
  シナリオ: [正常系]ルートジョブネットが仮想サーバが違うジョブネット(並列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_35_rootjbonet_includes_parallel_jobnets_having_finally_and_different_server.rb  -f ./features/config/tengined.yml.erb"というコマンドを実行する
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


    もし 仮想サーバ"test_server2"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test j1 start"の後であること
    かつ "tengine_job_test jf1 start"と"スクリプトログ2"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test jf1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test jf1 start"の後であること

    もし 仮想サーバ"test_server3"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    かつ "tengine_job_test j2 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test j2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test j2 start"の後であること
    かつ "tengine_job_test jf2 start"と"スクリプトログ3"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test jf2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test jf2 start"の後であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    かつ "tengine_job_test jobnet1077_finally start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test jobnet1077_finally finish"と"スクリプトログ1"に出力されており、"tengine_job_test jobnet1077_finally start"の後であること

    
  # ./usecases/job/dsl/01_01_36_finally_includes_parallel_jobs.rb
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
  # #                    {|-->[fj1]-->|        }|
  # #                    {|           |        }|
  # #                    {[S4]-->F           J-->[E4] }
  # #                    {|           |        }|
  # #                    {|-->[fj2]-->|        }|
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
  
  @01_01_36
  シナリオ: [正常系]Finallyに複数のジョブ(並列)を含むジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_36_finally_includes_parallel_jobs.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1078"を実行する
    かつ ジョブネット"jobnet1078"が完了することを確認する
    
    ならば ジョブネット"/jobnet1078" のステータスが正常終了であること
    かつ ジョブ"/jobnet1078/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1078/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1078/finally/fj1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1078/finally/fj2" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること
    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること


  # ./usecases/job/dsl/01_01_37_finally_includes_one_jobnet_having_finally.rb
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
  
  @01_01_37
  シナリオ: [正常系]FinallyにFinally付きのジョブネット１つ_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_37_finally_includes_one_jobnet_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test j2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test j2 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること


  
  # ./usecases/job/dsl/01_01_38_finally_includes_serial_jobnets_having_finally.rb
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
  
  @01_01_38
  シナリオ: [正常系]FinallyにFinally付きのジョブネット(直列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_38_finally_includes_serial_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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
    
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
    
  
  # ./usecases/job/dsl/01_01_39_finally_includes_parallel_jobnets_having_finally.rb
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
  # #                    {|-->{ [S3]-->[j2]-->[E3]  }-->|        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {______finally________}   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   { [S4]-->[fj1]-->[E4] }   |        }|
  # #                    {|   {_____________________}   |        }|
  # #                    {|                             |        }|
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {|    _[jobnet1081-2]______    |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|-->{ [S5]-->[j3]-->[E5]  }-->|        }|
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
  
  @01_01_39
  シナリオ: [正常系]FinallyにFinally付きのジョブネット(並列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_39_finally_includes_parallel_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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
    
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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

  
  # ./usecases/job/dsl/01_01_40_finally_includes_parallel_jobnets_having_finally_and_different_credentials.rb
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
  # #                    {|-->{ [S3]-->[j2]-->[E3]  }-->|        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {______finally________}   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   { [S4]-->[fj1]-->[E4] }   |        }|
  # #                    {|   {_____________________}   |        }|
  # #                    {|                             |        }|
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {|    _[jobnet1082-2]______    |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|-->{ [S5]-->[j3]-->[E5]  }-->|        }|
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
  
  @01_01_40
  シナリオ: [正常系]Finallyにクレデンシャルが違うジョブネット(並列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 認証情報が名称:"test_credential1-1"で登録されている
    かつ 認証情報が名称:"test_credential1-2"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_40_finally_includes_parallel_jobnets_having_finally_and_different_credentials.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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
    
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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

  
  # ./usecases/job/dsl/01_01_41_finally_includes_parallel_jobnets_having_finally_and_different_server.rb
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
  # #                    {|-->{ [S3]-->[j2]-->[E3]  }-->|        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {______finally________}   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   { [S4]-->[fj1]-->[E4] }   |        }|
  # #                    {|   {_____________________}   |        }|
  # #                    {|                             |        }|
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {|    _[jobnet1083-2]______    |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|-->{ [S5]-->[j3]-->[E5]  }-->|        }|
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
  
  @01_01_41
  シナリオ: [正常系]Finallyに仮想サーバが違うジョブネット(並列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_41_finally_includes_parallel_jobnets_having_finally_and_different_server.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ1"に出力されており、"tengine_job_test j1 start"の後であること

    かつ 仮想サーバ"test_server2"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    かつ "tengine_job_test j2 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test j2 finish"と"スクリプトログ2"に出力されており、"tengine_job_test j2 start"の後であること
    かつ "tengine_job_test fj1 start"と"スクリプトログ2"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ 仮想サーバ"test_server3"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    かつ "tengine_job_test j3 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test j3 finish"と"スクリプトログ3"に出力されており、"tengine_job_test j3 start"の後であること
    かつ "tengine_job_test fj2 start"と"スクリプトログ3"に出力されており、"tengine_job_test j3 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test fj2 start"の後であること

    
  
  # ./usecases/job/dsl/01_01_42_finally_includes_auto_sequence.rb
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
  
  @01_01_42
  シナリオ: [正常系]Finallyにauto_sequenceを使用する_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_42_finally_includes_auto_sequence.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1084"を実行する
    かつ ジョブネット"jobnet1084"が完了することを確認する
    
    ならば ジョブネット"/jobnet1084" のステータスが正常終了であること
    かつ ジョブ"/jobnet1084/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1084/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1084/finally/fj1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1084/finally/fj2" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test fj1 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること

  
  # ./usecases/job/dsl/01_01_43_finally_includes_boot_jobs.rb
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
  # #                    {|-->[fj1]-->|        }|
  # #                    {|           |        }|
  # #                    {[S4]-->F           J-->[E4] }
  # #                    {|           |        }|
  # #                    {|-->[fj2]-->|        }|
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
  
  @01_01_43
  シナリオ: [正常系]Finallyにboot_jobsを使用する_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_43_finally_includes_boot_jobs.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1085"を実行する
    かつ ジョブネット"jobnet1085"が完了することを確認する
    
    ならば ジョブネット"/jobnet1085" のステータスが正常終了であること
    かつ ジョブ"/jobnet1085/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1085/finally" のステータスが正常終了であること
    かつ ジョブ"/jobnet1085/finally/fj1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1085/finally/fj2" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

    かつ "tengine_job_test fj1 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ "tengine_job_test fj2 start"と"スクリプトログ"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ"に出力されており、"tengine_job_test fj2 start"の後であること

  
  # ./usecases/job/dsl/01_01_44_finally_includes_expansion.rb
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
  # #                    {|-->{ [S3]-->[j2]-->[E3]  }-->|        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {______finally________}   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   { [S4]-->[fj1]-->[E4] }   |        }|
  # #                    {|   {_____________________}   |        }|
  # #                    {|                             |        }|
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {|    _[jobnet1086]________    |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|-->{ [S3]-->[j2]-->[E3]  }-->|        }|
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
  
  @01_01_44
  シナリオ: [正常系]Finallyにexpansionを使用する_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_44_finally_includes_expansion.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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


  # ./usecases/job/dsl/01_01_45_finally_includes_no_job.rb
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
  @01_01_45
  シナリオ: [正常系]Finallyにブロック内にコードがない_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_45_finally_includes_no_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1090"を実行する
    かつ ジョブネット"jobnet1090"が完了することを確認する
    
    ならば ジョブネット"/jobnet1090" のステータスが正常終了であること
    かつ ジョブ"/jobnet1090/j1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1090/finally" のステータスが正常終了であること
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test j1 start"の後であること

  
  # ./usecases/job/dsl/01_01_46_rootjobnet_and_finally_include_parallel_jobnets_having_finally.rb
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
  # #|-->{  [S2]-->[j1]-->[E2]  }-->|
  # #|   {                      }   |
  # #|   {________finally_______}   |
  # #|   {                      }   |
  # #|   { [S3]-->[jf1]-->[E3]  }   |
  # #|   {                      }   |
  # #|   {----------------------}   |
  # #|                              |
  # # [S1]-->F                              J-->[E1]
  # #|                              |
  # #|   {-[jobnet1091-2]-------}   |
  # #|   {                      }   |
  # #|-->{  [S4]-->[j2]-->[E4]  }-->|
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
  # #                    {|-->{ [S7]-->[j3]-->[E7]  }-->|        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {______finally________}   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   { [S8]-->[fj3]-->[E8] }   |        }|
  # #                    {|   {_____________________}   |        }|
  # #                    {|                             |        }|
  # #                    { [S6]-->F                             J-->[E6] }
  # #                    {|    _[jobnet1091-4]______    |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|-->{ [S9]-->[j4]-->[E9]  }-->|        }|
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
  @01_01_46
  シナリオ: [正常系]Finally付きのジョブネット(並列)を組み合わせた複雑なパターン_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_01_46_rootjobnet_and_finally_include_parallel_jobnets_having_finally.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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

    かつ 仮想サーバ"test_server2"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ2"と呼ぶこととする。
    かつ "tengine_job_test j1 start"と"スクリプトログ2"に出力されていること
    かつ "tengine_job_test j1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test j1 start"の後であること
    かつ "tengine_job_test fj1 start"と"スクリプトログ2"に出力されており、"tengine_job_test j1 finish"の後であること
    かつ "tengine_job_test fj1 finish"と"スクリプトログ2"に出力されており、"tengine_job_test fj1 start"の後であること

    かつ 仮想サーバ"test_server3"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ3"と呼ぶこととする。
    かつ "tengine_job_test j2 start"と"スクリプトログ3"に出力されていること
    かつ "tengine_job_test j2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test j2 start"の後であること
    かつ "tengine_job_test fj2 start"と"スクリプトログ3"に出力されており、"tengine_job_test j2 finish"の後であること
    かつ "tengine_job_test fj2 finish"と"スクリプトログ3"に出力されており、"tengine_job_test fj2 start"の後であること

    
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ1"と呼ぶこととする。
    かつ "tengine_job_test j3 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test j3 finish"と"スクリプトログ1"に出力されており、"tengine_job_test j3 start"の後であること
    かつ "tengine_job_test fj3 start"と"スクリプトログ1"に出力されており、"tengine_job_test j3 finish"の後であること
    かつ "tengine_job_test fj3 finish"と"スクリプトログ1"に出力されており、"tengine_job_test fj3 start"の後であること
    
    かつ "tengine_job_test j4 start"と"スクリプトログ1"に出力されていること
    かつ "tengine_job_test j4 finish"と"スクリプトログ1"に出力されており、"tengine_job_test j4 start"の後であること
    かつ "tengine_job_test fj4 start"と"スクリプトログ1"に出力されており、"tengine_job_test j4 finish"の後であること
    かつ "tengine_job_test fj4 finish"と"スクリプトログ1"に出力されており、"tengine_job_test fj4 start"の後であること


