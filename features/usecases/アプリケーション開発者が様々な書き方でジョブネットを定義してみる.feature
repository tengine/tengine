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

  # ./usecases/job/dsl/01_03_01_finally_not_last_of_jobnet.rb
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
  @01_03_01
  シナリオ: [正常系]1024_finallyがjobnetの途中に書かれている_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_03_01_finally_not_last_of_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1024"を実行する
    かつ ジョブネット"jobnet1024"が完了することを確認する
    
    ならば ジョブネット"/jobnet1024" のステータスが正常終了であること
    かつ ジョブ"/jobnet1024/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1024/finally/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1024/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"に出力されており、"tengine_job_test job3 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job3 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/01_03_02_boot_jobs_not_first_of_jobnet.rb
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
  @01_03_02
  シナリオ: [正常系]1025_boot_jobsがjobnetの途中に書かれている_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_03_02_boot_jobs_not_first_of_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1025"を実行する
    かつ ジョブネット"jobnet1025"が完了することを確認する
    
    ならば ジョブネット"/jobnet1025" のステータスが正常終了であること
    かつ ジョブ"/jobnet1025/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1025/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1025/finally/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  # ./usecases/job/dsl/01_03_03_auto_sequence_not_first_of_jobnet.rb
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
  @01_03_03
  シナリオ: [正常系]1026_auto_sequenceがjobnetの途中に書かれている_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_03_03_auto_sequence_not_first_of_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1026"を実行する
    かつ ジョブネット"jobnet1026"が完了することを確認する
    
    ならば ジョブネット"/jobnet1026" のステータスが正常終了であること
    かつ ジョブ"/jobnet1026/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1026/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1026/job3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"と"tengine_job_test job2 start"の間であること
    かつ "tengine_job_test job2 start"と"スクリプトログ"に出力されており、"tengine_job_test job1 finish"と"tengine_job_test job2 finish"の間であること
    かつ "tengine_job_test job2 finish"と"スクリプトログ"に出力されており、"tengine_job_test job2 start"と"tengine_job_test job3 start"の間であること
    かつ "tengine_job_test job3 start"と"スクリプトログ"に出力されており、"tengine_job_test job2 finish"と"tengine_job_test job3 finish"の間であること
    かつ "tengine_job_test job3 finish"と"スクリプトログ"の末尾に出力されていること


  
  # ./usecases/job/dsl/01_03_04_twice_finally_in_jobnet.rb  
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
  @01_03_04
  シナリオ: [正常系]1027_finallyが2回書かれている_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_03_04_twice_finally_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E5  finally is duplicated.
    ならば "Tengineコアプロセス"の標準出力に"finally is duplicated."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること

  

  # ./usecases/job/dsl/01_03_05_twice_auto_sequence_in_jobnet.rb
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
  @01_03_05
  シナリオ: [正常系]1028_auto_sequenceが2回書かれている_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_03_05_twice_auto_sequence_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E6  auto_sequence is duplicated.
    ならば "Tengineコアプロセス"の標準出力に"auto_sequence is duplicated."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること


  # ./usecases/job/dsl/01_03_06_boot_jobs_after_auto_sequence.rb
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
  @01_03_06
  シナリオ: [正常系]1029_auto_sequenceのあとにboot_jobsが定義されている_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_03_06_boot_jobs_after_auto_sequence.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
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
  @01_03_07
  シナリオ: [正常系]1030_jobnetが1つもない_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_03_07_no_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する

    ならば "Tengineコアプロセス"の状態が"稼働中"であること


    
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
  @01_03_08
  シナリオ: [正常系]1032_DSLにシンタックスエラーがある_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1032_error_on_execute.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E7  syntax error. #(e.message}¥n#{e.backtrace.join("\n")}
    ならば "Tengineコアプロセス"の標準出力に"syntax error, unexpected '}', expecting keyword_end (SyntaxError)."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること
    
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
  @01_03_09
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
  @01_03_10
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
  @01_03_11
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
  @01_03_12
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
  @01_03_13
  シナリオ: [正常系]1038_どこからも参照されないジョブがある_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1038_not_refrenced_job_in_jobnet.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1038"を実行する
    かつ ジョブネット"jobnet1038"が完了することを確認する
    
    ならば ジョブネット"/jobnet1038" のステータスが正常終了であること
    かつ ジョブ"/jobnet1038/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1038/job2" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
  @01_03_14
  シナリオ: [正常系]1039_boot_jobsでジョブネットの途中のジョブを指定する_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1039_set_boot_jobs_future_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1039"を実行する
    かつ ジョブネット"jobnet1039"が完了することを確認する
    
    ならば ジョブネット"/jobnet1039" のステータスが正常終了であること
    かつ ジョブ"/jobnet1039/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1039/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1039/job3" のステータスが正常終了であること
    
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
  @01_03_15
  シナリオ: [正常系]1040_toでジョブネットの途中のジョブを指定する_を試してみる

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1040_set_to_future_job.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1040"を実行する
    かつ ジョブネット"jobnet1040"が完了することを確認する
    
    ならば ジョブネット"/jobnet1040" のステータスが正常終了であること
    かつ ジョブ"/jobnet1040/job1" のステータスが正常終了であること
    かつ ジョブ"/jobnet1040/job2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1040/job3" のステータスが正常終了であること
    
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
  @01_03_16
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
  @01_03_17
  シナリオ: [正常系]1042_別の階層に同一名のジョブネットが含まれる_を試してみる
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1042_duplicated_jobname_on_diff_layer.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jobnet1042"を実行する
    かつ ジョブネット"jobnet1042"が完了することを確認する
    
    ならば ジョブネット"/jobnet1042" のステータスが正常終了であること
    かつ ジョブ"/jobnet1042/job1" のステータスが正常終了であること
    かつ ジョブネット"/jobnet1042/jobnet1042_2" のステータスが正常終了であること
    かつ ジョブ"/jobnet1042/jobnet1042_2/job1" のステータスが正常終了であること
    
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
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
  @01_03_18
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
  @01_03_19
  シナリオ: [正常系]1044_:credential_nameが登録されていない_を試してみる

    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1043_not_registered_instance_name.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する
    
    # W2 credential_name(#{credential_name}) is not registered.
    ならば "Tengineコアプロセス"の標準出力に"credential_name(not_registered) is not registered."と出力されていること
    かつ "Tengineコアプロセス"の状態が"稼働中"であること

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
  @01_03_20
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
  # #                    {|-->[fj1]-->|        }|
  # #                    {|           |        }|
  # #                    {[S4]-->F           J-->[E4] }
  # #                    {|           |        }|
  # #                    {|-->[fj2]-->|        }|
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
  @01_03_21
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
  # #                    {|-->{ [S3]-->[j2]-->[E3]  }-->|        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   {______finally________}   |        }|
  # #                    {|   {                     }   |        }|
  # #                    {|   { [S4]-->[fj1]-->[E4] }   |        }|
  # #                    {|   {_____________________}   |        }|
  # #                    {|                             |        }|
  # #                    { [S2]-->F                             J-->[E2] }
  # #                    {|    _[jobnet1089]________    |        }|
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
  @01_03_22
  シナリオ: [正常系]1089_Finallyにexpansionのoptionに不正な値_を試してみる
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1089_finally_includes_invalid_option_value_in_expansion.rb -f ./features/config/tengined.yml.erb"というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する

    # E8  #{value} is invalid option.
    ならば "Tengineコアプロセス"の標準出力に"hoge is invalid option."と出力されていること
    かつ "Tengineコアプロセス"の状態が"停止済"であること