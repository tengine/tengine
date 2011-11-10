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
  @1001
  シナリオ: [正常系]1001_1つのジョブが含まれるジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    かつ "tengine_job_test job1 finish"と"スクリプトログ"の末尾に出力されていること


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
  @1002
  シナリオ: [正常系]1002_複数のジョブ(直列)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1002_series_jobs_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1003
  シナリオ: [正常系]1003_複数のジョブ(並列)が含まれるジョブネット
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1003_parallel_jobs_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1004
  シナリオ: [正常系]1004_hadoopジョブが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1004_hadoop_job_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1005
  シナリオ: [正常系]1005_finallyが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1005_finally_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1006
  シナリオ: [正常系]1006_expansionが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1006_expansion_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1007
  シナリオ: [正常系]1007_boot_jobsが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1007_boot_jobs_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1008
  シナリオ: [正常系]1008_auto_sequenceが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1008_auto_sequence_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1009
  シナリオ: [正常系]1009_入れ子(2階層)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1009_2_layer_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1010
  シナリオ: [正常系]1010_入れ子(3階層)が含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1010_3_layer_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1011
  シナリオ: [正常系]1011_入れ子(2階層)のfinallyが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1011_2_layer_finally_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1012
  シナリオ: [正常系]1012_入れ子(3階層)のfinallyが含まれるジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1012_3_layer_finally_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1013
  シナリオ: [正常系]1013_入れ子の中でinstanceとcredential_nameが違うジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1013_3_rayer_complicated_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1014
  シナリオ: [正常系]1014_finallyの入れ子の中でinstanceとcredential_nameが違うジョブネット_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1014_3_layer_complicated_finally_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1015
  シナリオ: [正常系]1015_複雑なジョブネット１_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1015_complicated_jobnet_1.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"complicated_jobnet"を実行する
    かつ ジョブネット"complicated_jobnet"が完了することを確認する
    
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

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1020_hadoop_job_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1021_job_in_hadoop_job_run.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1022_hadoop_job_in_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1023_finally_in_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1024
  @TODO
  シナリオ: [正常系]1024_finallyがjobnetの途中に書かれている_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1024_finally_not_last_of_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1025
  シナリオ: [正常系]1025_boot_jobsがjobnetの途中に書かれている_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1025_boot_jobs_not_first_of_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1026
  シナリオ: [正常系]1026_auto_sequenceがjobnetの途中に書かれている_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1026_auto_sequence_not_first_of_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1027_twice_finally_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1028_twice_auto_sequence_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1029_boot_jobs_after_auto_sequence.rb -f ./features/config/tengine.yml"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E10 boot_jobs or auto_sequence is duplicated.
    ならば "Tengineコアプロセス"の標準出力に"boot_jobs or auto_sequence is duplicated."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/1030_no_jobnet.rb
  #  -------------------
  # require 'tengine_job'
  # 
  #  -------------------
  @1030
  シナリオ: [正常系]1030_jobnetが1つもない_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1030_no_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1031_no_job_or_hadoop_job_run_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1032_error_on_execute.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1033_execute_on_error.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1034_unexpected_option_for_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1035_unexpected_option_for_job.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1036_unexpected_option_for_hadoop_job_run.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1037_unexpected_option_for_expansion.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1038_not_refrenced_job_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1039
  シナリオ: [正常系]1039_boot_jobsでジョブネットの途中のジョブを指定する_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1039_set_boot_jobs_future_job.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1040
  シナリオ: [正常系]1040_toでジョブネットの途中のジョブを指定する_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1040_set_to_future_job.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1041_duplicated_jobname_on_same_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1042
  シナリオ: [正常系]1042_別の階層に同一名のジョブネットが含まれる_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1042_duplicated_jobname_on_diff_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1043_not_registered_instance_name.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1043_not_registered_instance_name.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

  
  # ./usecases/job/dsl/1060_jobnet_directory
  #
  @1060
  シナリオ: [正常系]1060_ディレクトリ構成の読込_を試してみる
    
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1060_jobnet_directory -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1060_a"を実行する
    かつ ジョブネット"jobnet1060_a"が完了することを確認する   
    ならば ジョブネット"/jobnet1060_a" のステータスが正常終了であること
    かつ ジョブ"/jobnet1060_a/job1" のステータスが正常終了であること

    もし ジョブネット"jobnet1060_b"を実行する
    かつ ジョブネット"jobnet1060_b"が完了することを確認する   
    ならば ジョブネット"/jobnet1060_b" のステータスが正常終了であること
    かつ ジョブ"/jobnet1060_b/job1" のステータスが正常終了であること

    もし ジョブネット"jobnet1060_c"を実行する
    かつ ジョブネット"jobnet1060_c"が完了することを確認する   
    ならば ジョブネット"/jobnet1060_c" のステータスが正常終了であること
    かつ ジョブ"/jobnet1060_c/job1" のステータスが正常終了であること

    もし ジョブネット"jobnet1060_d"を実行する
    かつ ジョブネット"jobnet1060_d"が完了することを確認する   
    ならば ジョブネット"/jobnet1060_d" のステータスが正常終了であること
    かつ ジョブ"/jobnet1060_d/job1" のステータスが正常終了であること

    もし ジョブネット"jobnet1060_e"を実行する
    かつ ジョブネット"jobnet1060_e"が完了することを確認する   
    ならば ジョブネット"/jobnet1060_e" のステータスが正常終了であること
    かつ ジョブ"/jobnet1060_e/job1" のステータスが正常終了であること

    もし ジョブネット"jobnet1060_f"を実行する
    かつ ジョブネット"jobnet1060_f"が完了することを確認する   
    ならば ジョブネット"/jobnet1060_f" のステータスが正常終了であること
    かつ ジョブ"/jobnet1060_f/job1" のステータスが正常終了であること

    もし ジョブネット"jobnet1060_g"を実行する
    かつ ジョブネット"jobnet1060_g"が完了することを確認する   
    ならば ジョブネット"/jobnet1060_g" のステータスが正常終了であること
    かつ ジョブ"/jobnet1060_g/job1" のステータスが正常終了であること

    もし ジョブネット"jobnet1060_h"を実行する
    かつ ジョブネット"jobnet1060_h"が完了することを確認する   
    ならば ジョブネット"/jobnet1060_h" のステータスが正常終了であること
    かつ ジョブ"/jobnet1060_h/job1" のステータスが正常終了であること

    もし ジョブネット"jobnet1060_i"を実行する
    かつ ジョブネット"jobnet1060_i"が完了することを確認する   
    ならば ジョブネット"/jobnet1060_i" のステータスが正常終了であること
    かつ ジョブ"/jobnet1060_i/job1" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test jobnet1060_a-job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test jobnet1060_a-job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_a-job1 start"と"tengine_job_test jobnet1060_b-job1 start"の間であること
    かつ "tengine_job_test jobnet1060_b-job1 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_a-job1 finish"と"tengine_job_test jobnet1060_b-job1 finish"の間であること
    かつ "tengine_job_test jobnet1060_b-job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_b-job1 start"と"tengine_job_test jobnet1060_c-job1 start"の間であること
    かつ "tengine_job_test jobnet1060_c-job1 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_b-job1 finish"と"tengine_job_test jobnet1060_c-job1 finish"の間であること
    かつ "tengine_job_test jobnet1060_c-job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_c-job1 start"と"tengine_job_test jobnet1060_d-job1 start"の間であること
    かつ "tengine_job_test jobnet1060_d-job1 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_c-job1 finish"と"tengine_job_test jobnet1060_d-job1 finish"の間であること
    かつ "tengine_job_test jobnet1060_d-job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_d-job1 start"と"tengine_job_test jobnet1060_e-job1 start"の間であること
    かつ "tengine_job_test jobnet1060_e-job1 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_d-job1 finish"と"tengine_job_test jobnet1060_e-job1 finish"の間であること
    かつ "tengine_job_test jobnet1060_e-job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_e-job1 start"と"tengine_job_test jobnet1060_f-job1 start"の間であること
    かつ "tengine_job_test jobnet1060_f-job1 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_e-job1 finish"と"tengine_job_test jobnet1060_f-job1 finish"の間であること
    かつ "tengine_job_test jobnet1060_f-job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_f-job1 start"と"tengine_job_test jobnet1060_g-job1 start"の間であること
    かつ "tengine_job_test jobnet1060_g-job1 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_f-job1 finish"と"tengine_job_test jobnet1060_g-job1 finish"の間であること
    かつ "tengine_job_test jobnet1060_g-job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_g-job1 start"と"tengine_job_test jobnet1060_h-job1 start"の間であること
    かつ "tengine_job_test jobnet1060_h-job1 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_g-job1 finish"と"tengine_job_test jobnet1060_h-job1 finish"の間であること
    かつ "tengine_job_test jobnet1060_h-job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_h-job1 start"と"tengine_job_test jobnet1060_i-job1 start"の間であること
    かつ "tengine_job_test jobnet1060_i-job1 start"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_h-job1 finish"と"tengine_job_test jobnet1060_i-job1 finish"の間であること
    かつ "tengine_job_test jobnet1060_i-job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test jobnet1060_i-job1 start"の後であること

  
  # ./usecases/job/dsl/1061_dictionary_yml
  @manual
  @1061
  シナリオ: [正常系]1061_dictionary.ymlの内容が正しく表示される_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1061_dictionary_yml -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    ならば ルートのカテゴリの下に物理名"jobnet_a.rb"、論理名"ジョブネットA"というカテゴリが存在すること
    かつ ルートのカテゴリの子に物理名"jobnet_b.rb"、論理名"ジョブネットB"というカテゴリが存在すること
    かつ ルートのカテゴリの子に物理名"jobnet_c.rb"、論理名"ジョブネットC"というカテゴリが存在すること
    かつ ルートのカテゴリの子に物理名"jobnetgroup_x"、論理名"ジョブネットグループX"というカテゴリが存在すること
    かつ ルートのカテゴリの子に物理名"jobnetgroup_y"、論理名"ジョブネットグループY"というカテゴリが存在すること

    かつ 物理名"jobnetgroup_x"のカテゴリの子に物理名"jobnet_d.rb"、論理名"ジョブネットD"というカテゴリが存在すること
    かつ 物理名"jobnetgroup_x"のカテゴリの子に物理名"jobnet_e.rb"、論理名"ジョブネットE"というカテゴリが存在すること
    かつ 物理名"jobnetgroup_x"のカテゴリの子に物理名"jobnet_f.rb"、論理名"ジョブネットF"というカテゴリが存在すること

    かつ 物理名"jobnetgroup_y"のカテゴリの子に物理名"jobnet_g.rb"、論理名"ジョブネットG"というカテゴリが存在すること
    かつ 物理名"jobnetgroup_y"のカテゴリの子に物理名"jobnet_h.rb"、論理名"ジョブネットH"というカテゴリが存在すること
    かつ 物理名"jobnetgroup_y"のカテゴリの子に物理名"jobnet_i.rb"、論理名"ジョブネットI"というカテゴリが存在すること

    
    かつ ジョブネット"jobnet1061_a" のカテゴリは物理名"jobnet_a.rb"、論理名"ジョブネットA"であること
    かつ ジョブネット"jobnet1061_b" のカテゴリは物理名"jobnet_b.rb"、論理名"ジョブネットB"であること
    かつ ジョブネット"jobnet1061_c" のカテゴリは物理名"jobnet_c.rb"、論理名"ジョブネットC"であること
    かつ ジョブネット"jobnet1061_d" のカテゴリは物理名"jobnet_d.rb"、論理名"ジョブネットD"であること
    かつ ジョブネット"jobnet1061_e" のカテゴリは物理名"jobnet_e.rb"、論理名"ジョブネットE"であること
    かつ ジョブネット"jobnet1061_f" のカテゴリは物理名"jobnet_f.rb"、論理名"ジョブネットF"であること
    かつ ジョブネット"jobnet1061_g" のカテゴリは物理名"jobnet_g.rb"、論理名"ジョブネットG"であること
    かつ ジョブネット"jobnet1061_h" のカテゴリは物理名"jobnet_h.rb"、論理名"ジョブネットH"であること
    かつ ジョブネット"jobnet1061_i" のカテゴリは物理名"jobnet_i.rb"、論理名"ジョブネットI"であること

  # ./usecases/job/dsl/1062_incorrect_dictionary_yml
  #  -------------------
  # 
  #  -------------------
  @manual
  @1062
  シナリオ: [正常系]1062_dictionary.ymlの内容が間違っている_を試してみる
  
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1062_incorrect_dictionary_yml -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    # jobnet_b.rb は定義がない
    # jobnet_c.rb は空が指定されている
    # jobnetgroup_z の定義がない
    ならば ルートのカテゴリの下に物理名"jobnet_a.rb"、論理名"ジョブネットA"というカテゴリが存在すること
    かつ ルートのカテゴリの子に物理名"jobnet_b.rb"、論理名"jobnet_b.rb"というカテゴリが存在すること
    かつ ルートのカテゴリの子に物理名"jobnet_c.rb"、論理名"jobnet_c.rb"というカテゴリが存在すること
    かつ ルートのカテゴリの子に物理名"jobnetgroup_x"、論理名"ジョブネットグループX"というカテゴリが存在すること
    かつ ルートのカテゴリの子に物理名"jobnetgroup_y"、論理名"ジョブネットグループY"というカテゴリが存在すること
    かつ ルートのカテゴリの子に物理名"jobnetgroup_z"、論理名"jobnetgroup_z"というカテゴリが存在すること

    # dictionary.yml がない
    かつ 物理名"jobnetgroup_x"のカテゴリの子に物理名"jobnet_d.rb"、論理名"jobnet_d.rb"というカテゴリが存在すること
    かつ 物理名"jobnetgroup_x"のカテゴリの子に物理名"jobnet_e.rb"、論理名"jobnet_e.rb"というカテゴリが存在すること
    かつ 物理名"jobnetgroup_x"のカテゴリの子に物理名"jobnet_f.rb"、論理名"jobnet_f.rb"というカテゴリが存在すること

    # jobnet_j.rb: ジョブネットJ という不要な定義がある。
    かつ 物理名"jobnetgroup_y"のカテゴリの子に物理名"jobnet_g.rb"、論理名"ジョブネットG"というカテゴリが存在すること
    かつ 物理名"jobnetgroup_y"のカテゴリの子に物理名"jobnet_h.rb"、論理名"ジョブネットH"というカテゴリが存在すること
    かつ 物理名"jobnetgroup_y"のカテゴリの子に物理名"jobnet_i.rb"、論理名"ジョブネットI"というカテゴリが存在すること

    # dictionary.yml が不正でパースエラーになる
    かつ 物理名"jobnetgroup_z"のカテゴリの子に物理名"jobnet_j.rb"、論理名"jobnet_j.rb"というカテゴリが存在すること
    かつ 物理名"jobnetgroup_z"のカテゴリの子に物理名"jobnet_k.rb"、論理名"jobnet_k.rb"というカテゴリが存在すること

    かつ ジョブネット"jobnet1062_a" のカテゴリは物理名"jobnet_a.rb"、論理名"ジョブネットA"であること
    かつ ジョブネット"jobnet1062_b" のカテゴリは物理名"jobnet_b.rb"、論理名"jobnet_b.rb"であること
    かつ ジョブネット"jobnet1062_c" のカテゴリは物理名"jobnet_c.rb"、論理名"jobnet_c.rb"であること
    かつ ジョブネット"jobnet1062_d" のカテゴリは物理名"jobnet_d.rb"、論理名"jobnet_d.rb"であること
    かつ ジョブネット"jobnet1062_e" のカテゴリは物理名"jobnet_e.rb"、論理名"jobnet_e.rb"であること
    かつ ジョブネット"jobnet1062_f" のカテゴリは物理名"jobnet_f.rb"、論理名"jobnet_f.rb"であること
    かつ ジョブネット"jobnet1062_g" のカテゴリは物理名"jobnet_g.rb"、論理名"ジョブネットG"であること
    かつ ジョブネット"jobnet1062_h" のカテゴリは物理名"jobnet_h.rb"、論理名"ジョブネットH"であること
    かつ ジョブネット"jobnet1062_i" のカテゴリは物理名"jobnet_i.rb"、論理名"ジョブネットI"であること
    かつ ジョブネット"jobnet1062_j" のカテゴリは物理名"jobnet_j.rb"、論理名"jobnet_j.rb"であること
    かつ ジョブネット"jobnet1062_k" のカテゴリは物理名"jobnet_k.rb"、論理名"jobnet_k.rb"であること


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
  @1071
  シナリオ: [正常系]1071_ルートジョブネットが複数のジョブ(並列)を含むジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1071_rootjobnet_includes_parallel_jobs.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1072
  シナリオ: [正常系]1072_ルートジョブネットがFinally付きのジョブネット１つ_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1072_rootjobnet_includes_one_jobnet_having_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  #  -------------------
  @1073
  シナリオ: [正常系]1073_ルートジョブネットがFinally付きのジョブネット(直列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1073_rootjobnet_includes_serial_jobnets_having_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1074
  シナリオ: [正常系]1074_ルートジョブネットがFinally付きのジョブネット(並列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1074_rootjobnet_includes_parallel_jobnets_having_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1075
  シナリオ: [正常系]1075_ルートジョブネットがFinally付きのジョブネット入れ子3層_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1075_rootjobnet_includes_3_layers_jobnets_having_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1076
  シナリオ: [正常系]1076_ルートジョブネットがクレデンシャルが違うジョブネット(並列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 認証情報が名称:"test_credential1-1"で登録されている
    
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1076_rootjobnet_includes_parallel_jobnets_having_finally_and_different_credentials.rb  -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1077
  シナリオ: [正常系]1077_ルートジョブネットが仮想サーバが違うジョブネット(並列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1077_rootjbonet_includes_parallel_jobnets_having_finally_and_different_server.rb  -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1078
  シナリオ: [正常系]1078_Finallyに複数のジョブ(並列)を含むジョブネット_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1078_finally_includes_parallel_jobs.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1079
  シナリオ: [正常系]1079_FinallyにFinally付きのジョブネット１つ_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1079_finally_includes_one_jobnet_having_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1080
  シナリオ: [正常系]1080_FinallyにFinally付きのジョブネット(直列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1080_finally_includes_serial_jobnets_having_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1081
  シナリオ: [正常系]1081_FinallyにFinally付きのジョブネット(並列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1081_finally_includes_parallel_jobnets_having_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1082
  シナリオ: [正常系]1082_Finallyにクレデンシャルが違うジョブネット(並列)_を試してみる
  
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 認証情報が名称:"test_credential1-1"で登録されている
    かつ 認証情報が名称:"test_credential1-2"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1082_finally_includes_parallel_jobnets_having_finally_and_different_credentials.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1083
  シナリオ: [正常系]1083_Finallyに仮想サーバが違うジョブネット(並列)_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1083_finally_includes_parallel_jobnets_having_finally_and_different_server.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1084
  シナリオ: [正常系]1084_Finallyにauto_sequenceを使用する_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1084_finally_includes_auto_sequence.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1085
  シナリオ: [正常系]1085_Finallyにboot_jobsを使用する_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1085_finally_includes_boot_jobs.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1086
  シナリオ: [正常系]1086_Finallyにexpansionを使用する_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1086_finally_includes_expansion.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1087_finally_includes_invalid_option_value_in_jobnet.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1088_finally_includes_invalid_option_value_in_job.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T 1089_finally_includes_invalid_option_value_in_expansion.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1090_finally_includes_no_job.rb -f ./features/config/tengine.yml"というコマンドを実行する
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
  @1091
  シナリオ: [正常系]1091_Finally付きのジョブネット(並列)を組み合わせた複雑なパターン_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server2"のファイル:"~/tengine_job_test.log"が存在しないこと
    かつ 仮想サーバ"test_server3"のファイル:"~/tengine_job_test.log"が存在しないこと
    
    かつ 仮想サーバがインスタンス識別子:"test_server2"で登録されていること
    かつ 認証情報が名称:"test_credential2"で登録されている
    かつ 仮想サーバがインスタンス識別子:"test_server3"で登録されていること
    かつ 認証情報が名称:"test_credential3"で登録されている

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1091_rootjobnet_and_finally_include_parallel_jobnets_having_finally.rb -f ./features/config/tengine.yml"というコマンドを実行する
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

    
