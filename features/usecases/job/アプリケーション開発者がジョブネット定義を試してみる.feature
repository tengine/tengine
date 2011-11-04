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
		
    ならば ジョブネット"jobnet1001" のステータスが正常であること
    かつ ジョブ"/jobnet1001/job1" のステータスが正常であること

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
		
    ならば ジョブネット"jobnet1002" のステータスが正常であること
    かつ ジョブ"/jobnet1002/job1" のステータスが正常であること
    かつ ジョブ"/jobnet1002/job2" のステータスが正常であること

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
  シナリオ: [正常系]1003_複数のジョブ(並列)が含まれるジョブネット



	
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

  # ./usecases/job/dsl/1006_expansion_in_jobnet.rb
	#  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1006", :instance_name => "test_server1", :credential_name => "test_server1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  #   expansion("jobnet1006_2", :to => "job3")
  #   job("job3", "$HOME/tengine_job_test.sh 0 job3")
  # end
  # jobnet("jobnet1006_2", :instance_name => "test_server1", :credential_name => "test_server1") do
  #   boot_jobs("job2")
  #   job("job2", "$HOME/tengine_job_test.sh 0 job2")
  # end
  #  -------------------
	@1006
  シナリオ: [正常系]1006_expansionが含まれるジョブネット_を試してみる

	
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
  #       job("i_jobnet1-1-0", "echo 'jobnet1-1 START'")
  #       job("i_jobnet1-1-1", "sleep 5")
  #       job("i_jobnet1-1-2", "echo 'jobnet1-1 END'")
  #   end
  #   jobnet('i_jobnet1-2',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
  #       auto_sequence
  #       job("i_jobnet1-2-0", "echo 'jobnet1-2 START'")
  #       job("i_jobnet1-2-1", "sleep 10")
  #       job("i_jobnet1-2-2", "echo 'jobnet1-2 END'")
  #   end
  #   jobnet('i_jobnet1-3', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
  #       boot_jobs("i_job1-1","i_job1-2","i_job1-3","i_job2-1","i_job2-2")
  #       job("i_job1-1", "sleep 1",:to => "i_job3")
  #       job("i_job1-2", "sleep 1",:to => "i_job3")
  #       job("i_job1-3", "sleep 1",:to => "i_job3")
  #       job("i_job2-1", "sleeeeeep 1",:to => "i_job2-0")
  #       job("i_job2-2", "sleep 1",:to => "i_job2-0")
  #       job("i_job2-0", "sleep 1",:to => "i_job3")
  #       job("i_job3", "sleep 1")
  #   end
  #   jobnet('i_jobnet2-1',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet2-0") do   
  #       auto_sequence
  #       job("i_jobnet2-1-0", "echo 'jobnet2-1 START'")
  #       job("i_jobnet2-1-1", "sleep 1")
  #       job("i_jobnet2-1-2", "echo 'jobnet2-1 END'")
  #   end
  #   jobnet('i_jobnet2-2', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet2-0") do    
  #       auto_sequence
  #       job("i_jobnet2-2-0", "echo 'jobnet2-2 START'")
  #       job("i_jobnet2-2-1", "sleep 1")
  #       job("i_jobnet2-2-2", "echo 'jobnet2-2 END'")
  #   end
  #   jobnet('i_jobnet2-0',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
  #       auto_sequence
  #       job("i_jobnet2-0-0", "echo 'jobnet2-0 START'")
  #       job("i_jobnet2-0-1", "sleep 1")
  #       job("i_jobnet2-0-2", "echo 'jobnet2-0 END'")
  #   end
  #   jobnet('i_jobnet3',  :vm_instance_name => "test_server1",:credential_name => "test_credential1") do
  #       auto_sequence
  #       job("i_jobnet3-0", "echo 'jobnet3 START'")
  #       job("i_jobnet3-1", "sleep 1")
  #       job("i_jobnet3-2", "echo 'jobnet3 END'")
  #   end
  # end
  #  -------------------
	@1015
  シナリオ: [正常系]1015_複雑なジョブネット１_を試してみる

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
  シナリオ: [正常系]1020_jobnetにhadoop_jobが含まれる_を試してみる

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
  シナリオ: [正常系]1021_hadoop_job_run にjobが含まれる_を試してみる

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
  シナリオ: [正常系]1022_finally にhadoop_jobが含まれる_を試してみる

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
  シナリオ: [正常系]1023_finally にfinallyが含まれる_を試してみる

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
  シナリオ: [正常系]1024_finallyがjobnetの途中に書かれている_を試してみる

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

  # ./usecases/job/dsl/1030_no_jobnet.rb
	#  -------------------
  # require 'tengine_job'
  # 
  #  -------------------
	@1030
  シナリオ: [正常系]1030_jobnetが1つもない_を試してみる

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

  # ./usecases/job/dsl/1032_error_on_execute.rb
	#  -------------------

  #  -------------------
	@1032
  シナリオ: [正常系]1032_DSLにシンタックスエラーがある_を試してみる

  # ./usecases/job/dsl/1033_execute_on_error.rb
	#  -------------------

  #  -------------------
	@1033
  シナリオ: [正常系]1033_実行時にエラーとなる_を試してみる

  # ./usecases/job/dsl/1034_unexpected_option_for_jobnet.rb
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
	@1034
  シナリオ: [正常系]1034_jobnetのoptionに不正な値が指定されている_を試してみる

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
	@1045
  シナリオ: [正常系]1045_とても時間がかかるジョブ_を試してみる

  # ./usecases/job/dsl/1060_jobnet_directory
  #  -------------------
	#
	# ./usecases/job/dsl/1060_jobnet_directory/jobnet_a.rb
	#  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1060_a", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
  #  -------------------
	#
	# ./usecases/job/dsl/1060_jobnet_directory/jobnet_b.rb
	#  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1060_b", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
	#  -------------------
  #
	#  ./usecases/job/dsl/1060_jobnet_directory/jobnet_c.rb
	#  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1060_c", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
	#  -------------------
  #
	# ./usecases/job/dsl/1060_jobnet_directory/jobnetgroup_x/jobnet_d.rb
	#  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1060_d", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
	#  -------------------
  #
	# ./usecases/job/dsl/1060_jobnet_directory/jobnetgroup_x/jobnet_e.rb
	#  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1060_e", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
	#  -------------------
  #
	# ./usecases/job/dsl/1060_jobnet_directory/jobnetgroup_x/jobnet_f.rb
	#  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1060_f", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
	#  -------------------
  #
	# ./usecases/job/dsl/1060_jobnet_directory/jobnetgroup_y/jobnet_g.rb
	#  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1060_g", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
	#  -------------------
  #
	# ./usecases/job/dsl/1060_jobnet_directory/jobnetgroup_y/jobnet_h.rb
	#  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1060_h", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
	#  -------------------
  #
	# ./usecases/job/dsl/1060_jobnet_directory/jobnetgroup_y/jobnet_i.rb
	#  -------------------
  # require 'tengine_job'
  # 
  # jobnet("jobnet1060_i", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 0 job1")
  # end
	#  -------------------
	#
	@1060
  シナリオ: [正常系]1060_ディレクトリ構成の読込_を試してみる

  # ./usecases/job/dsl/1061_dictionary_yml
	#  -------------------
  # 
  #  -------------------
	@1061
  シナリオ: [正常系]1061_dictionary.ymlの内容が正しく表示される_を試してみる

  # ./usecases/job/dsl/1062_incorrect_dictionary_yml
	#  -------------------
  # 
  #  -------------------
	@1062
  シナリオ: [正常系]1062_dictionary.ymlの内容が間違っている_を試してみる


	@pending
	@1071
  シナリオ: [正常系]1071_ルートジョブネットが複数のジョブ(並列)を含むジョブネット_を試してみる

	@pending
	@1072
  シナリオ: [正常系]1072_ルートジョブネットがFinally付きのジョブネット１つ_を試してみる
	
	@pending
	@1073
  シナリオ: [正常系]1073_ルートジョブネットがFinally付きのジョブネット(直列)_を試してみる
	
	@pending
	@1074
  シナリオ: [正常系]1074_ルートジョブネットがFinally付きのジョブネット(並列)_を試してみる
	
	@pending
	@1075
  シナリオ: [正常系]1075_ルートジョブネットがFinally付きのジョブネット入れ子3層_を試してみる
	
	@pending
	@1076
  シナリオ: [正常系]1076_ルートジョブネットがクレデンシャルが違うジョブネット(並列)_を試してみる
	
	@pending
	@1077
  シナリオ: [正常系]1077_ルートジョブネットが仮想サーバが違うジョブネット(並列)_を試してみる
	
	@pending
	@1078
  シナリオ: [正常系]1078_Finallyに複数のジョブ(並列)を含むジョブネット_を試してみる
	
	@pending
	@1079
  シナリオ: [正常系]1079_FinallyにFinally付きのジョブネット１つ_を試してみる
	
	@pending
	@1080
  シナリオ: [正常系]1080_FinallyにFinally付きのジョブネット(直列)_を試してみる
	
	@pending
	@1081
  シナリオ: [正常系]1081_FinallyにFinally付きのジョブネット(並列)_を試してみる
	
	@pending
	@1082
  シナリオ: [正常系]1082_Finallyにクレデンシャルが違うジョブネット(並列)_を試してみる
	
	@pending
	@1083
  シナリオ: [正常系]1083_Finallyに仮想サーバが違うジョブネット(並列)_を試してみる
	
	@pending
	@1084
  シナリオ: [正常系]1084_Finallyにauto_sequenceを使用する_を試してみる
	
	@pending
	@1085
  シナリオ: [正常系]1085_Finallyにboot_jobsを使用する_を試してみる
	
	@pending
	@1086
  シナリオ: [正常系]1086_Finallyにexpansionを使用する_を試してみる
	
	@pending
	@1087
  シナリオ: [正常系]1087_Finallyにjobnetのoptionに不正な値_を試してみる
	
	@pending
	@1088
  シナリオ: [正常系]1088_Finallyにjobのoptionに不正な値_を試してみる
	
	@pending
	@1089
  シナリオ: [正常系]1089_Finallyにexpansionのoptionに不正な値_を試してみる
	
	@pending
	@1090
  シナリオ: [正常系]1090_Finallyにブロック内にコードがない_を試してみる
	
	@pending
	@1091
  シナリオ: [正常系]1091_Finally付きのジョブネット(並列)を組み合わせた複雑なパターン_を試してみる
