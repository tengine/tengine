#language:ja
機能: アプリケーション開発者がruby_jobが含まれるジョブネット定義を試してみる

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

  # ./usecases/job/dsl/01_07_01_one_ruby_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0701") do
  #   boot_jobs('rj1')
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  # end
  # ---------------------------
  #
  @01_07_01
  シナリオ: 1つのruby_jobが含まれるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_01_one_ruby_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0701"を実行する
    かつ ジョブネット"rjn0701"が完了することを確認する

    ならば ジョブネット"/rjn0701" のステータスが正常終了であること
    かつ ジョブ"/rjn0701/rj1" のステータスが正常終了であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する


  # ./usecases/job/dsl/01_07_02_sequencial_ruby_jobs.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0702") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_02
  シナリオ: 複数のruby_job(直列)が含まれるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_02_sequential_ruby_jobs.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0702"を実行する
    かつ ジョブネット"rjn0702"が完了することを確認する

    ならば ジョブネット"/rjn0702" のステータスが正常終了であること
    かつ ジョブ"/rjn0702/rj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0702/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0702/rj3" のステータスが正常終了であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_03_parallel_ruby_jobs.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0703") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  # end
  # ---------------------------
  #
  @01_07_03
  シナリオ: 複数のruby_job(並列)が含まれるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_03_parallel_ruby_jobs.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0703"を実行する
    かつ ジョブネット"rjn0703"が完了することを確認する

    ならば ジョブネット"/rjn0703" のステータスが正常終了であること
    かつ ジョブ"/rjn0703/rj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0703/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0703/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0703/rj4" のステータスが正常終了であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj2 executing...'と'rj3 executing...'の後であること


  # ./usecases/job/dsl/01_07_04_boot_multi_ruby_jobs.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0704") do
  #   boot_jobs(['rj1', 'rj2])
  #   ruby_job('rj1', :to => 'rj3'){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj3'){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'              ){ STDOUT.puts('rj4 executing...') }
  # end
  # ---------------------------
  #
  @01_07_04
  シナリオ: ジョブネット内の最初に実行するジョブが並列のルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_04_boot_multi_ruby_jobs.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0704"を実行する
    かつ ジョブネット"rjn0704"が完了することを確認する

    ならば ジョブネット"/rjn0704" のステータスが正常終了であること
    かつ ジョブ"/rjn0703/rj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0703/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0703/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0703/rj4" のステータスが正常終了であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj1 executing...'と'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj3 executing...'の後であること


  # ./usecases/job/dsl/01_07_05_sequencial_ruby_jobs_with_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0705", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_05
  シナリオ: 直列に実行されるジョブネットにジョブが含まれるルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_05_sequencial_ruby_jobs_with_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0705"を実行する
    かつ ジョブネット"rjn0705"が完了することを確認する

    ならば ジョブネット"/rjn0705" のステータスが正常終了であること
    かつ ジョブ"/rjn0705/rj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0705/j1"  のステータスが正常終了であること
    かつ ジョブ"/rjn0705/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0705/rj3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_06_parallel_ruby_jobs_with_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0706", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   ruby_job('rj1', :to => ['j1', 'rj2']){ STDOUT.puts('rj1 executing...') }
  #   job('j1', "$HOME/tengine_job_test.sh 0 job1", :to => 'rj3')
  #   ruby_job('rj2', :to => 'rj3'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3'                       ){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_06
  シナリオ: ruby_jobと並列に実行されるjobが含まれるルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_06_parallel_ruby_jobs_with_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0706"を実行する
    かつ ジョブネット"rjn0706"が完了することを確認する

    ならば ジョブネット"/rjn0706" のステータスが正常終了であること
    かつ ジョブ"/rjn0706/rj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0706/j1"  のステータスが正常終了であること
    かつ ジョブ"/rjn0706/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0706/rj3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_07_boot_ruby_job_and_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn07087", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs(['rj1', 'j1])
  #   ruby_job('rj1', :to => 'rj1'){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('j1', "$HOME/tengine_job_test.sh 0 job1", :to => 'rj2')
  #   ruby_job('rj2', :to => 'rj3'){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3'              ){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_07
  シナリオ: boot_jobsにruby_jobとjobが含まれるルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_07_boot_ruby_job_and_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0707"を実行する
    かつ ジョブネット"rjn0707"が完了することを確認する

    ならば ジョブネット"/rjn0707" のステータスが正常終了であること
    かつ ジョブ"/rjn0707/rj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0707/j1"  のステータスが正常終了であること
    かつ ジョブ"/rjn0707/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0707/rj3" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_test job1 start"の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_08_one_ruby_job_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0708") do
  #   ruby_job('rj1'){ raise RuntimeError }
  # end
  # ---------------------------
  #
  @01_07_08
  シナリオ: ruby_jobが失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_08_one_ruby_job_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0708"を実行する
    かつ ジョブネット"rjn0708"が完了することを確認する

    ならば ジョブネット"/rjn0708" のステータスがエラー終了であること
    かつ ジョブ"/rjn0708/rj1" のステータスがエラー終了であること

    もし ジョブ"/rjn0708/rj1"の"実行時PID"を"rj1_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{j1_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{j1_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0708/rj1"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_09_sequencial_ruby_jobs_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0709") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2'){ raise RuntimeError }
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_09
  シナリオ: 複数のruby_job(直列)が失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_09_sequential_ruby_jobs_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0709"を実行する
    かつ ジョブネット"rjn0709"が完了することを確認する

    ならば ジョブネット"/rjn0709" のステータスがエラー終了であること
    かつ ジョブ"/rjn0709/rj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0709/rj2" のステータスがエラー終了であること
    かつ ジョブ"/rjn0709/rj3" のステータスが初期化済であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する

    もし ジョブ"/rjn0709/rj2"の"実行時PID"を"rj1_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{j1_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{j1_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0709/rj2"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_10_parallel_ruby_jobs_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0710") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ raise RuntimeError }
  #   ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  # end
  # ---------------------------
  #
  @01_07_10
  シナリオ: 複数のruby_job(並列)が失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_10_parallel_ruby_jobs_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0710"を実行する
    かつ ジョブネット"rjn0710"が完了することを確認する

    ならば ジョブネット"/rjn0710" のステータスがエラー終了であること
    かつ ジョブ"/rjn0710/rj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0710/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0710/rj3" のステータスがエラー終了であること
    かつ ジョブ"/rjn0710/rj4" のステータスが初期化済であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること

    もし ジョブ"/rjn0710/rj3"の"実行時PID"を"rj1_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{j1_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{j1_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0710/rj3"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_11_boot_multi_ruby_jobs_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0711") do
  #   boot_jobs(['rj1', 'rj2])
  #   ruby_job('rj1', :to => 'rj3'){ raise RuntimeError }
  #   ruby_job('rj2', :to => 'rj3'){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'              ){ STDOUT.puts('rj4 executing...') }
  # end
  # ---------------------------
  #
  @01_07_11
  シナリオ: boot_jobsに複数のruby_jobが含まれるジョブネットが失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_11_boot_multi_ruby_jobs_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0711"を実行する
    かつ ジョブネット"rjn0711"が完了することを確認する

    ならば ジョブネット"/rjn0711" のステータスがエラー終了であること
    かつ ジョブ"/rjn0711/rj1" のステータスがエラー終了であること
    かつ ジョブ"/rjn0711/rj2" のステータスが初期化済であること
    かつ ジョブ"/rjn0711/rj3" のステータスが初期化済であること
    かつ ジョブ"/rjn0711/rj4" のステータスが初期化済であること

    もし ジョブ"/rjn0711/rj1"の"実行時PID"を"rj1_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{j1_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{j1_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0711/rj1"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_12_ruby_job_with_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0712") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  #   finally do
  #     ruby_job('frj1'){ STDOUT.puts('frj1 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_12
  シナリオ: finallyが含まれるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_12_ruby_job_with_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0712"を実行する
    かつ ジョブネット"rjn0712"が完了することを確認する

    ならば ジョブネット"/rjn0712"       のステータスが正常終了であること
    かつ ジョブ"/rjn0712/rj1"          のステータスが正常終了であること
    かつ ジョブ"/rjn0712/rj2"          のステータスが正常終了であること
    かつ ジョブ"/rjn0712/rj3"          のステータスが正常終了であること
    かつ ジョブ"/rjn0712/rj4"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0712/finally" のステータスが正常終了であること
    かつ ジョブ"/rjn0712/finally/frj1" のステータスが正常終了であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...' と出力されており、'rj2 executing...'と'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj4 executing...'の後であること


  # ./usecases/job/dsl/01_07_13_sequential_ruby_jobs_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0713") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  #   finally do
  #     ruby_job('frj1'){ STDOUT.puts('frj1 executing...') }
  #     ruby_job('frj2'){ STDOUT.puts('frj2 executing...') }
  #     ruby_job('frj3'){ STDOUT.puts('frj3 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_13
  シナリオ: finally内に複数のruby_job(直列)が含まれるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_13_sequential_ruby_jobs_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0713"を実行する
    かつ ジョブネット"rjn0713"が完了することを確認する

    ならば ジョブネット"/rjn0713"       のステータスが正常終了であること
    かつ ジョブ"/rjn0713/rj1"          のステータスが正常終了であること
    かつ ジョブ"/rjn0713/rj2"          のステータスが正常終了であること
    かつ ジョブ"/rjn0713/rj3"          のステータスが正常終了であること
    かつ ジョブ"/rjn0713/rj4"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0713/finally" のステータスが正常終了であること
    かつ ジョブ"/rjn0713/finally/frj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0713/finally/frj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0713/finally/frj3" のステータスが正常終了であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...' と出力されており、'rj2 executing...' と'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj4 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj2 executing...'と出力されており、'frj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj3 executing...'と出力されており、'frj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_14_parallel_ruby_jobs_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0714") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  #   finally do
  #     ruby_job('frj1', :to => ['frj2', 'frj3']){ STDOUT.puts('frj1 executing...') }
  #     ruby_job('frj2', :to => 'frj4'          ){ STDOUT.puts('frj2 executing...') }
  #     ruby_job('frj3', :to => 'frj4'          ){ STDOUT.puts('frj3 executing...') }
  #     ruby_job('frj4'                         ){ STDOUT.puts('frj4 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_14
  シナリオ: finally内に複数のruby_job(並列)が含まれるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_14_parallel_ruby_jobs_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0714"を実行する
    かつ ジョブネット"rjn0714"が完了することを確認する

    ならば ジョブネット"/rjn0714"       のステータスが正常終了であること
    かつ ジョブ"/rjn0714/rj1"          のステータスが正常終了であること
    かつ ジョブ"/rjn0714/rj2"          のステータスが正常終了であること
    かつ ジョブ"/rjn0714/rj3"          のステータスが正常終了であること
    かつ ジョブ"/rjn0714/rj4"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0714/finally" のステータスが正常終了であること
    かつ ジョブ"/rjn0714/finally/frj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0714/finally/frj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0714/finally/frj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0714/finally/frj4" のステータスが正常終了であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...' と出力されており、'rj2 executing...' と'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj4 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj2 executing...'と出力されており、'frj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj3 executing...'と出力されており、'frj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj4 executing...'と出力されており、'frj2 executing...'と'frj3 executing...'の後であること


  # ./usecases/job/dsl/01_07_15_boot_multi_ruby_jobs_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0715") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  #   finally do
  #     boot_jobs(['frj1', 'frj2'])
  #     ruby_job('frj1', :to => 'frj3'){ STDOUT.puts('frj1 executing...') }
  #     ruby_job('frj2', :to => 'frj3'){ STDOUT.puts('frj2 executing...') }
  #     ruby_job('frj3'               ){ STDOUT.puts('frj3 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_15
  シナリオ: finally内のboot_jobsに複数のruby_job(並列)が含まれるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_15_boot_multi_ruby_jobs_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0715"を実行する
    かつ ジョブネット"rjn0715"が完了することを確認する

    ならば ジョブネット"/rjn0715"       のステータスが正常終了であること
    かつ ジョブ"/rjn0715/rj1"          のステータスが正常終了であること
    かつ ジョブ"/rjn0715/rj2"          のステータスが正常終了であること
    かつ ジョブ"/rjn0715/rj3"          のステータスが正常終了であること
    かつ ジョブ"/rjn0715/rj4"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0715/finally" のステータスが正常終了であること
    かつ ジョブ"/rjn0715/finally/frj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0715/finally/frj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0715/finally/frj3" のステータスが正常終了であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...' と出力されており、'rj2 executing...' と'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj4 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj2 executing...'と出力されており、'rj4 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj3 executing...'と出力されており、'frj1 executing...'と'frj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_16_ruby_job_and_normal_job_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0716", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  #   finally do
  #     ruby_job('frj1'){ STDOUT.puts('frj1 executing...') }
  #     job('fj1', "$HOME/tengine_job_test.sh 0 job1_in_finally")
  #     ruby_job('frj2'){ STDOUT.puts('frj2 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_16
  シナリオ: finally内にruby_jobとjobが混在しているルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_16_ruby_job_and_normal_job_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0716"を実行する
    かつ ジョブネット"rjn0716"が完了することを確認する

    ならば ジョブネット"/rjn0716"       のステータスが正常終了であること
    かつ ジョブ"/rjn0716/rj1"          のステータスが正常終了であること
    かつ ジョブ"/rjn0716/rj2"          のステータスが正常終了であること
    かつ ジョブ"/rjn0716/rj3"          のステータスが正常終了であること
    かつ ジョブ"/rjn0716/rj4"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0716/finally" のステータスが正常終了であること
    かつ ジョブ"/rjn0716/finally/frj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0716/finally/fj1"  のステータスが正常終了であること
    かつ ジョブ"/rjn0716/finally/frj2" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする
    ならば "tengine_job_test job1_in_finally start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test job1_in_finally finish"と"スクリプトログ"に出力されており、"tengine_job_test job1_in_finally start"の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...' と出力されており、'rj2 executing...' と'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj4 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj2 executing...'と出力されており、'frj1 executing...'の後であること


  # ./usecases/job/dsl/01_07_17_ruby_job_at_out_of_finally_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0717") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'                       ){ raise RuntimeError }
  #   finally do
  #     ruby_job('frj1'){ STDOUT.puts('frj1 executing...') }
  #     ruby_job('frj2'){ STDOUT.puts('frj2 executing...') }
  #     ruby_job('frj3'){ STDOUT.puts('frj3 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_17
  シナリオ: finallyの外で失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_17_ruby_job_at_out_of_finally_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0717"を実行する
    かつ ジョブネット"rjn0717"が完了することを確認する

    ならば ジョブネット"/rjn0717"       のステータスがエラー終了であること
    かつ ジョブ"/rjn0717/rj1"          のステータスが正常終了であること
    かつ ジョブ"/rjn0717/rj2"          のステータスが正常終了であること
    かつ ジョブ"/rjn0717/rj3"          のステータスが正常終了であること
    かつ ジョブ"/rjn0717/rj4"          のステータスがエラー終了であること
    かつ ジョブネット"/rjn0717/finally" のステータスが正常終了であること
    かつ ジョブ"/rjn0717/finally/frj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0717/finally/frj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0717/finally/frj3" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj2 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj2 executing...'と出力されており、'frj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj3 executing...'と出力されており、'frj2 executing...'の後であること

    もし ジョブ"/rjn0717/rj4"の"実行時PID"を"rj1_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{j1_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{j1_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0717/rj4"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_18_sequencial_ruby_jobs_inside_finally_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0718") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  #   finally do
  #     ruby_job('frj1'){ STDOUT.puts('frj1 executing...') }
  #     ruby_job('frj2'){ raise RuntimeError }
  #     ruby_job('frj3'){ STDOUT.puts('frj3 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_18
  シナリオ: finally内で失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_18_sequencial_ruby_jobs_inside_finally_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0718"を実行する
    かつ ジョブネット"rjn0718"が完了することを確認する

    ならば ジョブネット"/rjn0718"       のステータスがエラー終了であること
    かつ ジョブ"/rjn0718/rj1"          のステータスが正常終了であること
    かつ ジョブ"/rjn0718/rj2"          のステータスが正常終了であること
    かつ ジョブ"/rjn0718/rj3"          のステータスが正常終了であること
    かつ ジョブ"/rjn0718/rj4"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0718/finally" のステータスがエラー終了であること
    かつ ジョブ"/rjn0718/finally/frj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0718/finally/frj2" のステータスがエラー終了であること
    かつ ジョブ"/rjn0718/finally/frj3" のステータスが初期化済であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...' と出力されており、'rj2 executing...'と'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj2 executing...' の後であること

    もし ジョブ"/rjn0718/finally/frj2"の"実行時PID"を"rj1_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{j1_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{j1_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0718/finally/frj2"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_19_multi_ruby_jobs_inside_finally_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0719") do
  #   ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  #   finally do
  #     ruby_job('frj1', :to => ['frj2', 'frj3']){ STDOUT.puts('frj1 executing...') }
  #     ruby_job('frj2', :to => 'frj4'          ){ raise RuntimeError }
  #     ruby_job('frj3', :to => 'frj4'          ){ STDOUT.puts('frj3 executing...') }
  #     ruby_job('frj4'                         ){ STDOUT.puts('frj4 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_19
  シナリオ: finally内のboot_jobsに含まれるruby_jobが失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_19_multi_ruby_jobs_inside_finally_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0719"を実行する
    かつ ジョブネット"rjn0719"が完了することを確認する

    ならば ジョブネット"/rjn0719"       のステータスがエラー終了であること
    かつ ジョブ"/rjn0719/rj1"          のステータスが正常終了であること
    かつ ジョブ"/rjn0719/rj2"          のステータスが正常終了であること
    かつ ジョブ"/rjn0719/rj3"          のステータスが正常終了であること
    かつ ジョブ"/rjn0719/rj4"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0719/finally" のステータスがエラー終了であること
    かつ ジョブ"/rjn0719/finally/frj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0719/finally/frj2" のステータスがエラー終了であること
    かつ ジョブ"/rjn0719/finally/frj3" のステータスが初期化済であること
    かつ ジョブ"/rjn0719/finally/frj4" のステータスが初期化済であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...' と出力されており、'rj2 executing...'と'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj2 executing...' の後であること

    もし ジョブ"/rjn0719/finally/frj2"の"実行時PID"を"rj1_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{j1_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{j1_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0719/finally/frj2"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  # ./usecases/job/dsl/01_07_20_jobnet_2_layers.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0720") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1") do
  #     ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   end
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_20
  シナリオ: 二階層のルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_20_jobnet_2_layers.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0720"を実行する
    かつ ジョブネット"rjn0720"が完了することを確認する

    ならば ジョブネット"/rjn0720"       のステータスが正常終了であること
    かつ ジョブ"/rjn0720/rj1"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0720/rjn1"    のステータスが正常終了であること
    かつ ジョブ"/rjn0720/rjn1/rj2"     のステータスが正常終了であること
    かつ ジョブ"/rjn0720/rj3"          のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj2 executing...' の後であること


  # ./usecases/job/dsl/01_07_21_jobnet_2_layers_parallel.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0721") do
  #   ruby_job('rj1', :to => ['rjn1', 'rj3']){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1", :to => 'rj4') do
  #     ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   end
  #   ruby_job('rj3', :to => 'rj4'){ STDOUT.puts('rj3 executing...') }
  #   ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  # end
  # ---------------------------
  #
  @01_07_21
  シナリオ: ruby_jobとjobnetが並列実行されるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_21_jobnet_2_layers_parallel.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0721"を実行する
    かつ ジョブネット"rjn0721"が完了することを確認する

    ならば ジョブネット"/rjn0721"       のステータスが正常終了であること
    かつ ジョブ"/rjn0721/rj1"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0721/rjn1"    のステータスが正常終了であること
    かつ ジョブ"/rjn0721/rjn1/rj2"     のステータスが正常終了であること
    かつ ジョブ"/rjn0721/rj3"          のステータスが正常終了であること
    かつ ジョブ"/rjn0721/rj4"          のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...' と出力されており、'rj2 executing...'と'rj3 executing...'の後であること


  # ./usecases/job/dsl/01_07_22_jobnet_2_layers_with_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0722", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1") do
  #     ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   end
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_22
  シナリオ: ruby_jobとjobが混在し、子のジョブネットを含むルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_22_jobnet_2_layers_with_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0722"を実行する
    かつ ジョブネット"rjn0722"が完了することを確認する

    ならば ジョブネット"/rjn0722"       のステータスが正常終了であること
    かつ ジョブ"/rjn0722/j1"           のステータスが正常終了であること
    かつ ジョブ"/rjn0722/rj1"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0722/rjn1"    のステータスが正常終了であること
    かつ ジョブ"/rjn0722/rjn1/rj2"     のステータスが正常終了であること
    かつ ジョブ"/rjn0722/rj3"          のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されていること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj2 executing...' の後であること


  # ./usecases/job/dsl/01_07_23_jobnet_2_layers_with_normal_job_in_jobnet.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0723", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1") do
  #     ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #     job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #   end
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_23
  シナリオ: 子のジョブネットにruby_jobとjobnetが混在するルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_23_jobnet_2_layers_with_normal_job_in_jobnet.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0723"を実行する
    かつ ジョブネット"rjn0723"が完了することを確認する

    ならば ジョブネット"/rjn0723"       のステータスが正常終了であること
    かつ ジョブネット"/rjn0723/rjn1"    のステータスが正常終了であること
    かつ ジョブ"/rjn0723/rjn1/rj2"     のステータスが正常終了であること
    かつ ジョブ"/rjn0723/rjn1/rj1"     のステータスが正常終了であること
    かつ ジョブ"/rjn0723/rj3"          のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...' と出力されており、'rj2 executing...' の後であること


  # ./usecases/job/dsl/01_07_24_jobnet_2_layers_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0724") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1") do
  #     ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #     ruby_job('rj3'){ raise RuntimeError }
  #     ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  #   end
  #   ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
  #   finally do
  #     ruby_job('frj1'){ STDOUT.puts('frj1 executing...') }
  #     ruby_job('frj2'){ STDOUT.puts('frj2 executing...') }
  #     ruby_job('frj3'){ STDOUT.puts('frj3 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_24
  シナリオ: 子のジョブネットで失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_24_jobnet_2_layers_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0724"を実行する
    かつ ジョブネット"rjn0724"が完了することを確認する

    ならば ジョブネット"/rjn0724"       のステータスがエラー終了であること
    かつ ジョブ"/rjn0724/rj1"          のステータスが正常終了であること
    かつ ジョブネット"/rjn0724/rjn1"    のステータスがエラー終了であること
    かつ ジョブ"/rjn0724/rjn1/rj2"     のステータスが正常終了であること
    かつ ジョブ"/rjn0724/rjn1/rj3"     のステータスがエラー終了であること
    かつ ジョブ"/rjn0724/rjn1/rj4"     のステータスが初期化済であること
    かつ ジョブ"/rjn0721/rj5"          のステータスが初期化済であること
    かつ ジョブネット"/rjn0724/finally" のステータスが正常終了であること
    かつ ジョブ"/rjn0721/finally/frj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0721/finally/frj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0721/finally/frj3" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj2 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj2 executing...'と出力されており、'frj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj3 executing...'と出力されており、'frj2 executing...'の後であること

    もし ジョブ"/rjn0724/rj3"の"実行時PID"を"rj1_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{j1_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{j1_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0724/rj3"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_25_jobnet_3_layers.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0725") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1") do
  #     ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #     jobnet("rjn11") do
  #       ruby_job('rj3'){ STDOUT.puts('rj3 executiong...') }
  #     end
  #   end
  #   ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  # end
  # ---------------------------
  #
  @01_07_25
  シナリオ: 三階層のルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_25_jobnet_3_layers.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0725"を実行する
    かつ ジョブネット"rjn0725"が完了することを確認する

    ならば ジョブネット"/rjn0725"          のステータスが正常終了であること
    かつ ジョブ"/rjn0725/rj1"             のステータスが正常終了であること
    かつ ジョブネット"/rjn0725/rjn1"       のステータスが正常終了であること
    かつ ジョブ"/rjn0725/rjn1/rj2"        のステータスが正常終了であること
    かつ ジョブネット"/rjn0725/rjn1/rjn11" のステータスが正常終了であること
    かつ ジョブ"/rjn0725/rjn1/rjn11/rj3"  のステータスが正常終了であること
    かつ ジョブ"/rjn0726/rj4"             のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj3 executing...'の後であること


  # ./usecases/job/dsl/01_07_26_jobnet_3_layers_parallel.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0726") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1") do
  #     ruby_job('rj2', :to => ['rjn11', 'rj4']){ STDOUT.puts('rj2 executing...') }
  #     jobnet("rjn11", :to => 'rj5') do
  #       ruby_job('rj3'){ STDOUT.puts('rj3 executiong...') }
  #     end
  #     ruby_job('rj4', :to => 'rj5'){ STDOUT.puts('rj4 executiong...') }
  #     ruby_job('rj5'              ){ STDOUT.puts('rj5 executiong...') }
  #   end
  #   ruby_job('rj6'){ STDOUT.puts('rj6 executing...') }
  # end
  # ---------------------------
  #
  @01_07_26
  シナリオ: 孫のジョブネットとruby_jobが並列実行されるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_26_jobnet_3_layers_parallel.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0726"を実行する
    かつ ジョブネット"rjn0726"が完了することを確認する

    ならば ジョブネット"/rjn0726"          のステータスが正常終了であること
    かつ ジョブ"/rjn0726/rj1"             のステータスが正常終了であること
    かつ ジョブネット"/rjn0726/rjn1"       のステータスが正常終了であること
    かつ ジョブ"/rjn0726/rjn1/rj2"        のステータスが正常終了であること
    かつ ジョブネット"/rjn0726/rjn1/rjn11" のステータスが正常終了であること
    かつ ジョブ"/rjn0726/rjn1/rjn11/rj3"  のステータスが正常終了であること
    かつ ジョブ"/rjn0726/rjn1/rj4"        のステータスが正常終了であること
    かつ ジョブ"/rjn0726/rjn1/rj5"        のステータスが正常終了であること
    かつ ジョブ"/rjn0726/rj6"             のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj5 executing...'と出力されており、'rj3 executing...'と'rj4 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj6 executing...'と出力されており、'rj5 executing...'の後であること



  @01_07_XX
  シナリオ: finally内にジョブネットを含むルートジョブネット # これの直列、並列、ruby_jobとjobの混在、失敗のパターンも必要
  # ルートジョブネット->finallyジョブネット->ジョブネット

  @01_07_XX
  シナリオ: finally内に二階層のジョブネットを含むルートジョブネット # これの直列、並列、ruby_jobとjobの混在、失敗のパターンも必要
  # ルートジョブネット->finallyジョブネット->ジョブネット->ジョブネット

  @01_07_XX
  シナリオ: finallyが入れ子になったルートジョブネット # 失敗のパターンも必要
  # ルートジョブネット->finallyジョブネット->finallyジョブネット

  @01_07_XX
  シナリオ: custom_conductorを定義したルートジョブネット

  @01_07_XX
  シナリオ: ruby_job内で明示的にjob_succeedを指定したルートジョブネット # メッセージの指定

  @01_07_XX
  シナリオ: ruby_job内で明示的にjob_failを指定したルートジョブネット # メッセージの指定、例外クラスの指定

  # ./usecases/job/dsl/01_07_54_expansion.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0754") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   expansion('rjn0754_2')
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  #
  # jobnet('rjn0754_2') do
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  # end
  # ---------------------------
  #
  @01_07_XX
  シナリオ: expansionが含まれるルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_54_expansion.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0754"を実行する
    かつ ジョブネット"rjn0754"が完了することを確認する

    ならば ジョブネット"/rjn0754"                  のステータスが正常終了であること
    かつ ジョブ"/rjn0754/rj1"                     のステータスが正常終了であること
    かつ ジョブ"/rjn0754/rjn0754_2/rj2"           のステータスが正常終了であること
    かつ ジョブ"/rjn0754/rj3"                     のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に、'rj1 executing...'と出力されていること
    かつ "Tengineコアプロセス"の標準出力に、'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に、'rj3 executing...'と出力されていり、'rj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_55_chaining_expansion.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0755") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   expansion('rjn0755_2')
  #   ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
  # end
  #
  # jobnet('rjn0755_2') do
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   expansion('rjn0755_3')
  #   ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  # end
  #
  # jobnet('rjn0755_3') do
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_55
  シナリオ: 二重にexpandされたルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_55_chaining_expansion.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0755"を実行する
    かつ ジョブネット"rjn0755"が完了することを確認する

    ならば ジョブネット"/rjn0755"                  のステータスが正常終了であること
    かつ ジョブ"/rjn0755/rj1"                     のステータスが正常終了であること
    かつ ジョブ"/rjn0755/rjn0755_2/rj2"           のステータスが正常終了であること
    かつ ジョブ"/rjn0755/rjn0755_2/rjn0755_3/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0755/rjn0755_2/rj4"           のステータスが正常終了であること
    かつ ジョブ"/rjn0755/rj5"                     のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に、'rj1 executing...'と出力されていること
    かつ "Tengineコアプロセス"の標準出力に、'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に、'rj3 executing...'と出力されていり、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に、'rj4 executing...'と出力されていり、'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に、'rj5 executing...'と出力されていり、'rj4 executing...'の後であること


  # ./usecases/job/dsl/01_07_56_infinite_loop.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0756") do
  #   boot_jobs('rj1')
  #   ruby_job('rj1', :to => 'rj2'){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2', :to => 'rj1'){ STDOUT.puts('rj2 executing...') }
  # end
  # ---------------------------
  #
  @01_07_56
  シナリオ: ruby_jobが循環参照しているルートジョブネットをロード
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_56_infinite_loop.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス"の標準エラー出力に"circular dependency"と表示されていること
    かつ "Tengineコアプロセス"の標準エラー出力に"Tengine::Job::DslError"と表示されていること

