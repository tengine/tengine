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
		
    ならば ジョブネット"jobnet1001" のステータスが正常であること
    かつ ジョブ"/jobnet1001/job1" のステータスが正常であること

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
  # ./usecases/job/dsl/1004_hadoop_job_in_jobnet.rb
  # ./usecases/job/dsl/1005_finally_in_jobnet.rb
  # ./usecases/job/dsl/1006_expansion_in_jobnet.rb
  # ./usecases/job/dsl/1007_boot_jobs_in_jobnet.rb
  # ./usecases/job/dsl/1008_auto_sequence_in_jobnet.rb
  # ./usecases/job/dsl/1009_2_layer_in_jobnet.rb
  # ./usecases/job/dsl/1010_3_layer_in_jobnet.rb
  # ./usecases/job/dsl/1011_2_layer_finally_in_jobnet.rb
  # ./usecases/job/dsl/1012_3_layer_finally_in_jobnet.rb
  # ./usecases/job/dsl/1013_3_rayer_complicated_in_jobnet.rb
  # ./usecases/job/dsl/1014_3_layer_complicated_finally_in_jobnet.rb
  # ./usecases/job/dsl/1015_complicated_jobnet_1.rb
  # ./usecases/job/dsl/1020_hadoop_job_in_jobnet.rb
  # ./usecases/job/dsl/1021_job_in_hadoop_job_run.rb
  # ./usecases/job/dsl/1022_hadoop_job_in_finally.rb
  # ./usecases/job/dsl/1023_finally_in_finally.rb
  # ./usecases/job/dsl/1024_finally_not_last_of_jobnet.rb
  # ./usecases/job/dsl/1025_boot_jobs_not_first_of_jobnet.rb
  # ./usecases/job/dsl/1026_auto_sequence_not_first_of_jobnet.rb
  # ./usecases/job/dsl/1027_twice_finally_in_jobnet.rb
  # ./usecases/job/dsl/1028_twice_auto_sequence_in_jobnet.rb
  # ./usecases/job/dsl/1029_boot_jobs_after_auto_sequence.rb
  # ./usecases/job/dsl/1030_no_jobnet.rb
  # ./usecases/job/dsl/1031_no_job_or_hadoop_job_run_in_jobnet.rb
  # ./usecases/job/dsl/1032_error_on_execute.rb
  # ./usecases/job/dsl/1033_execute_on_error.rb
  # ./usecases/job/dsl/1034_unexpected_option_for_jobnet.rb
  # ./usecases/job/dsl/1035_unexpected_option_for_job.rb
  # ./usecases/job/dsl/1036_unexpected_option_for_hadoop_job_run.rb
  # ./usecases/job/dsl/1037_unexpected_option_for_expansion.rb
  # ./usecases/job/dsl/1038_not_refrenced_job_in_jobnet.rb
  # ./usecases/job/dsl/1039_set_boot_jobs_future_job.rb
  # ./usecases/job/dsl/1040_set_to_future_job.rb
  # ./usecases/job/dsl/1041_duplicated_jobname_on_same_layer.rb
  # ./usecases/job/dsl/1042_duplicated_jobname_on_diff_layer.rb
  # ./usecases/job/dsl/1043_not_registered_instance_name.rb
  # ./usecases/job/dsl/1044_not_registered_credential_name.rb
  # ./usecases/job/dsl/1045_long_time_job.rb
  # ./usecases/job/dsl/1060_jobnet_directory
  # ./usecases/job/dsl/1061_dictionary_yml
  # ./usecases/job/dsl/1062_incorrect_dictionary_yml
  # ./usecases/job/dsl/2001_large_stdout_data
  # ./usecases/job/dsl/2002_large_and_complicated_jobnet
  # ./usecases/job/dsl/2003_expansion
  # ./usecases/job/dsl/2004_environment

