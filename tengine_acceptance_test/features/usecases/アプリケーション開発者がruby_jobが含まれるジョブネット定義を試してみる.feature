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

    もし ジョブ"/rjn0708/rj1"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
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

    もし ジョブ"/rjn0709/rj2"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
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

    もし ジョブ"/rjn0710/rj3"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
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

    もし ジョブ"/rjn0711/rj1"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
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

    もし ジョブ"/rjn0717/rj4"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
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

    もし ジョブ"/rjn0718/finally/frj2"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
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

    もし ジョブ"/rjn0719/finally/frj2"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
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
  シナリオ: ruby_jobとjobnetが並列実行するルートジョブネット
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
    かつ ジョブ"/rjn0724/rj5"          のステータスが初期化済であること
    かつ ジョブネット"/rjn0724/finally" のステータスが正常終了であること
    かつ ジョブ"/rjn0724/finally/frj1" のステータスが正常終了であること
    かつ ジョブ"/rjn0724/finally/frj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0724/finally/frj3" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj2 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj2 executing...'と出力されており、'frj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj3 executing...'と出力されており、'frj2 executing...'の後であること

    もし ジョブ"/rjn0724/rj3"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
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
  シナリオ: 孫のジョブネットとruby_jobが並列実行するルートジョブネット
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


  # ./usecases/job/dsl/01_07_27_jobnet_3_layers_with_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0727", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #   jobnet("rjn1") do
  #     ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #     jobnet("rjn11") do
  #       ruby_job('rj3'){ STDOUT.puts('rj3 executiong...') }
  #       job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #     end
  #   end
  #   ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  # end
  # ---------------------------
  #
  @01_07_27
  シナリオ: 孫のジョブネットにruby_jobとjobが混在するルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_27_jobnet_3_layers_with_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0727"を実行する
    かつ ジョブネット"rjn0727"が完了することを確認する

    ならば ジョブネット"/rjn0727"          のステータスが正常終了であること
    かつ ジョブ"/rjn0727/rj1"             のステータスが正常終了であること
    かつ ジョブネット"/rjn0727/rjn1"       のステータスが正常終了であること
    かつ ジョブ"/rjn0727/rjn1/rj2"        のステータスが正常終了であること
    かつ ジョブネット"/rjn0727/rjn1/rjn11" のステータスが正常終了であること
    かつ ジョブ"/rjn0727/rjn1/rjn11/rj3"  のステータスが正常終了であること
    かつ ジョブ"/rjn0727/rjn1/rjn11/j1"   のステータスが正常終了であること
    かつ ジョブ"/rjn0727/rj4"             のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されていること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj3 executing...'の後であること


  # ./usecases/job/dsl/01_07_28_jobnet_3_layers_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0728") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1") do
  #     ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #     jobnet("rjn11") do
  #       ruby_job('rj3'){ raise RuntimeError }
  #     end
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
  @01_07_28
  シナリオ: 孫のジョブネットで失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_28_jobnet_3_layers_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0728"を実行する
    かつ ジョブネット"rjn0728"が完了することを確認する

    ならば ジョブネット"/rjn0728"          のステータスがエラー終了であること
    かつ ジョブ"/rjn0728/rj1"             のステータスが正常終了であること
    かつ ジョブネット"/rjn0728/rjn1"       のステータスがエラー終了であること
    かつ ジョブ"/rjn0728/rjn1/rj2"        のステータスが正常終了であること
    かつ ジョブネット"/rjn0728/rjn1/rjn11" のステータスがエラー終了であること
    かつ ジョブ"/rjn0728/rjn1/rjn11/rj3"  のステータスがエラー終了であること
    かつ ジョブ"/rjn0728/rjn1/rj4"        のステータスが初期化済であること
    かつ ジョブ"/rjn0728/rj5"             のステータスが初期化済であること
    かつ ジョブネット"/rjn0728/finally"    のステータスが正常終了であること
    かつ ジョブ"/rjn0728/finally/frj1"    のステータスが正常終了であること
    かつ ジョブ"/rjn0728/finally/frj2"    のステータスが正常終了であること
    かつ ジョブ"/rjn0728/finally/frj3"    のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...' と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...' と出力されており、'rj1 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj1 executing...'と出力されており、'rj2 executing...' の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj2 executing...'と出力されており、'frj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'frj3 executing...'と出力されており、'frj2 executing...'の後であること

    もし ジョブ"/rjn0724/rjn11/rj3"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0724/rjn11/rj3"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_29_jobnet_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0729") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet("rfjn1") do
  #       ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_29
  シナリオ: finally内にジョブネットを含むルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_29_jobnet_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0729"を実行する
    かつ ジョブネット"rjn0729"が完了することを確認する

    ならば ジョブネット"/rjn0729"            のステータスが正常終了であること
    かつ ジョブ"/rjn0729/rj1"               のステータスが正常終了であること
    かつ ジョブネット"/rjn0729/finally"      のステータスが正常終了であること
    かつ ジョブネット"/rjn0729/finally/rfjn1"のステータスが正常終了であること
    かつ ジョブ"/rjn0729/finally/rfjn1/rj2" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること


  # ./usecases/job/dsl/01_07_30_jobnet_in_finally_with_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0730") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet("rfjn1", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #       ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #       job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_30
  シナリオ: finally内のジョブネットにruby_jobとjobが混在しているルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_30_jobnet_in_finally_with_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0730"を実行する
    かつ ジョブネット"rjn0730"が完了することを確認する

    ならば ジョブネット"/rjn0730"            のステータスが正常終了であること
    かつ ジョブ"/rjn0730/rj1"               のステータスが正常終了であること
    かつ ジョブネット"/rjn0730/finally"      のステータスが正常終了であること
    かつ ジョブネット"/rjn0730/finally/rfjn1"のステータスが正常終了であること
    かつ ジョブ"/rjn0730/finally/rfjn1/rj2" のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されていること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること


  # ./usecases/job/dsl/01_07_31_jobnet_in_finally_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0731") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet("rfjn1") do
  #       ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #       ruby_job('rj3'){ raise RuntimeError }
  #       ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_31
  シナリオ: finally内のジョブネットで失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_31_jobnet_in_finally_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0731"を実行する
    かつ ジョブネット"rjn0731"が完了することを確認する

    ならば ジョブネット"/rjn0731"            のステータスが正常終了であること
    かつ ジョブ"/rjn0731/rj1"               のステータスが正常終了であること
    かつ ジョブネット"/rjn0731/finally"      のステータスが正常終了であること
    かつ ジョブネット"/rjn0731/finally/rfjn1"のステータスが正常終了であること
    かつ ジョブ"/rjn0731/finally/rfjn1/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0731/finally/rfjn1/rj3" のステータスがエラー終了であること
    かつ ジョブ"/rjn0731/finally/rfjn1/rj4" のステータスが初期化済であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること

    もし ジョブ"/rjn0731/finally/rfjn1/rj3"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0724/finally/rfjn1/rj3"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_32_jobnet_2_layers_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0732") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet("rfjn1") do
  #       ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #       jobnet("rfjn11") do
  #         ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #       end
  #       ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_32
  シナリオ: finally内に二階層のジョブネットを含むルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_32_jobnet_2_layers_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0732"を実行する
    かつ ジョブネット"rjn0732"が完了することを確認する

    ならば ジョブネット"/rjn0732"                   のステータスが正常終了であること
    かつ ジョブ"/rjn0732/rj1"                      のステータスが正常終了であること
    かつ ジョブネット"/rjn0732/finally"             のステータスが正常終了であること
    かつ ジョブネット"/rjn0732/finally/rfjn1"       のステータスが正常終了であること
    かつ ジョブ"/rjn0732/finally/rfjn1/rj2"        のステータスが正常終了であること
    かつ ジョブネット"/rjn0732/finally/rfjn1/rfjn11"のステータスが正常終了であること
    かつ ジョブ"/rjn0732/finally/rfjn1/rfjn11/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0732/finally/rfjn1/rj4"        のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj3 executing...'の後であること


  # ./usecases/job/dsl/01_07_33_jobnet_2_layers_in_finally_parallel.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0733") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet("rfjn1") do
  #       ruby_job('rj2', :to => ['rfjn11', 'rj4']){ STDOUT.puts('rj2 executing...') }
  #       jobnet("rfjn11", :to => 'rj5') do
  #         ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #       end
  #       ruby_job('rj4', :to => 'rj5'){ STDOUT.puts('rj4 executing...') }
  #       ruby_job('rj5'              ){ STDOUT.puts('rj5 executing...') }
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_33
  シナリオ: finally内の孫のジョブネットとruby_jobが並列実行するルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_33_jobnet_2_layers_in_finally_parallel.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0733"を実行する
    かつ ジョブネット"rjn0733"が完了することを確認する

    ならば ジョブネット"/rjn0733"                   のステータスが正常終了であること
    かつ ジョブ"/rjn0733/rj1"                      のステータスが正常終了であること
    かつ ジョブネット"/rjn0733/finally"             のステータスが正常終了であること
    かつ ジョブネット"/rjn0733/finally/rfjn1"       のステータスが正常終了であること
    かつ ジョブ"/rjn0733/finally/rfjn1/rj2"        のステータスが正常終了であること
    かつ ジョブネット"/rjn0733/finally/rfjn1/rfjn11"のステータスが正常終了であること
    かつ ジョブ"/rjn0733/finally/rfjn1/rfjn11/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0733/finally/rfjn1/rj4"        のステータスが正常終了であること
    かつ ジョブ"/rjn0733/finally/rfjn1/rj5"        のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj5 executing...'と出力されており、'rj3 executing...'と'rj4 executing...'の後であること


  # ./usecases/job/dsl/01_07_34_jobnet_2_layers_in_finally_with_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0734") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet("rfjn1") do
  #       ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #       jobnet("rfjn11", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #         ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #         job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #         ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  #       end
  #       ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_34
  シナリオ: finally内の孫のジョブネット内にruby_jobとjobが混在するルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_34_jobnet_2_layers_in_finally_with_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0734"を実行する
    かつ ジョブネット"rjn0734"が完了することを確認する

    ならば ジョブネット"/rjn0734"                   のステータスが正常終了であること
    かつ ジョブ"/rjn0734/rj1"                      のステータスが正常終了であること
    かつ ジョブネット"/rjn0734/finally"             のステータスが正常終了であること
    かつ ジョブネット"/rjn0734/finally/rfjn1"       のステータスが正常終了であること
    かつ ジョブ"/rjn0734/finally/rfjn1/rj2"        のステータスが正常終了であること
    かつ ジョブネット"/rjn0734/finally/rfjn1/rfjn11"のステータスが正常終了であること
    かつ ジョブ"/rjn0734/finally/rfjn1/rfjn11/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0734/finally/rfjn1/rfjn11/j1"  のステータスが正常終了であること
    かつ ジョブ"/rjn0734/finally/rfjn1/rfjn11/rj4" のステータスが正常終了であること
    かつ ジョブ"/rjn0734/finally/rfjn1/rj5"        のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されていること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj5 executing...'と出力されており、'rj4 executing...'の後であること


  # ./usecases/job/dsl/01_07_35_jobnet_2_layers_in_finally_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0735") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet("rfjn1") do
  #       ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #       jobnet("rfjn11") do
  #         ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #         ruby_job('rj4'){ raise RuntimeError }
  #         ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
  #       end
  #       ruby_job('rj6'){ STDOUT.puts('rj6 executing...') }
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_35
  シナリオ: finally内の孫のジョブネット内にruby_jobとjobが混在するルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_35_jobnet_2_layers_in_finally_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0735"を実行する
    かつ ジョブネット"rjn0735"が完了することを確認する

    ならば ジョブネット"/rjn0735"                   のステータスが正常終了であること
    かつ ジョブ"/rjn0735/rj1"                      のステータスが正常終了であること
    かつ ジョブネット"/rjn0735/finally"             のステータスが正常終了であること
    かつ ジョブネット"/rjn0735/finally/rfjn1"       のステータスが正常終了であること
    かつ ジョブ"/rjn0735/finally/rfjn1/rj2"        のステータスが正常終了であること
    かつ ジョブネット"/rjn0735/finally/rfjn1/rfjn11"のステータスが正常終了であること
    かつ ジョブ"/rjn0735/finally/rfjn1/rfjn11/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0735/finally/rfjn1/rfjn11/rj4" のステータスがエラー終了であること
    かつ ジョブ"/rjn0735/finally/rfjn1/rfjn11/rj5" のステータスが初期化済であること
    かつ ジョブ"/rjn0735/finally/rfjn1/rj6"        のステータスが初期化済であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj3 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj5 executing...'と出力されており、'rj4 executing...'の後であること

    もし ジョブ"/rjn0735/finally/rfjn1/rfjn11/rj4"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0724/finally/rfjn1/rfjn11/rj4"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_36_finally_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0736") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet('rfjn1') do
  #       ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #       finally do
  #         ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #       end
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_36
  シナリオ: finallyが入れ子になったルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_36_finally_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0736"を実行する
    かつ ジョブネット"rjn0736"が完了することを確認する

    ならば ジョブネット"/rjn0736"                    のステータスが正常終了であること
    かつ ジョブ"/rjn0736/rj1"                       のステータスが正常終了であること
    かつ ジョブネット"/rjn0736/finally"              のステータスが正常終了であること
    かつ ジョブネット"/rjn0736/finally/rfjn1"        のステータスが正常終了であること
    かつ ジョブ"/rjn0736/finally/rfjn1/rj2"         のステータスが正常終了であること
    かつ ジョブネット"/rjn0736/finally/rfjn1/finally"のステータスが正常終了であること
    かつ ジョブ"/rjn0736/finally/rfjn1/finally/rj3" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_37_finally_in_finally_with_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0737") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet("rfjn1", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #       ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #       finally do
  #         ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #         job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #       end
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_37
  シナリオ: finally内のfinallyにruby_jobとjobが混在するルートジョブネット
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_37_finally_in_finally_with_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0737"を実行する
    かつ ジョブネット"rjn0737"が完了することを確認する

    ならば ジョブネット"/rjn0737"                    のステータスが正常終了であること
    かつ ジョブ"/rjn0737/rj1"                       のステータスが正常終了であること
    かつ ジョブネット"/rjn0737/finally"              のステータスが正常終了であること
    かつ ジョブネット"/rjn0737/finally/rfjn1"        のステータスが正常終了であること
    かつ ジョブ"/rjn0737/finally/rfjn1/rj2"         のステータスが正常終了であること
    かつ ジョブネット"/rjn0737/finally/rfjn1/finally"のステータスが正常終了であること
    かつ ジョブ"/rjn0737/finally/rfjn1/finally/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0737/finally/rfjn1/finally/j1"  のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されていること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_38_finally_in_finally_in_vain.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0738") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   finally do
  #     jobnet("rfjn1") do
  #       ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #       finally do
  #         ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #         ruby_job('rj4'){ raise RuntimeError }
  #         ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
  #       end
  #     end
  #   end
  # end
  # ---------------------------
  #
  @01_07_38
  シナリオ: finally内のfinallyで失敗
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_38_finally_in_finally_in_vain.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0738"を実行する
    かつ ジョブネット"rjn0738"が完了することを確認する

    ならば ジョブネット"/rjn0738"                    のステータスがエラー終了であること
    かつ ジョブ"/rjn0738/rj1"                       のステータスが正常終了であること
    かつ ジョブネット"/rjn0738/finally"              のステータスがエラー終了であること
    かつ ジョブネット"/rjn0738/finally/rfjn1"        のステータスが正常終了であること
    かつ ジョブ"/rjn0738/finally/rfjn1/rj2"         のステータスが正常終了であること
    かつ ジョブネット"/rjn0738/finally/rfjn1/finally"のステータスがエラー終了であること
    かつ ジョブ"/rjn0738/finally/rfjn1/finally/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0738/finally/rfjn1/finally/rj4" のステータスがエラー終了であること
    かつ ジョブ"/rjn0738/finally/rfjn1/finally/rj5" のステータスが初期化済であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること

    もし ジョブ"/rjn0738/finally/rfjn1/finally/rj4"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0724/finally/rfjn1/finally/rj4"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_39_custom_conductors.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # custom_conductor = lambda do |job|
  #   begin
  #     job.run
  #   rescue => e
  #     job.succeed
  #   end
  # end
  #
  # jobnet('rjn0739', :conductors => {:ruby_job => custom_conductor}) do
  #   ruby_job('rj1'){ raise RuntimeError }
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  # end
  # ---------------------------
  #
  @01_07_39
  シナリオ: jobnetにcustom_conductorsを定義したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_39_custom_conductors.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0739"を実行する
    かつ ジョブネット"rjn0739"が完了することを確認する

    ならば ジョブネット"/rjn0739"のステータスが正常終了であること
    かつ ジョブ"/rjn0739/rj1"   のステータスが正常終了であること
    かつ ジョブ"/rjn0739/rj2"   のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること


  # ./usecases/job/dsl/01_07_40_custom_conductors_with_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # custom_conductor = lambda do |job|
  #   begin
  #     job.run
  #   rescue => e
  #     job.succeed
  #   end
  # end
  #
  # jobnet('rjn0740', :instance_name => "test_server1", :credential_name => "test_credential1", :conductors => {:ruby_job => custom_conductor}) do
  #   job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #   ruby_job('rj1'){ raise RuntimeError }
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  # end
  # ---------------------------
  #
  @01_07_40
  シナリオ: jobnetにcustom_conductorsを定義したルートジョブネット内にruby_jobとjobが混在
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_40_custom_conductors_with_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0740"を実行する
    かつ ジョブネット"rjn0740"が完了することを確認する

    ならば ジョブネット"/rjn0740"のステータスが正常終了であること
    かつ ジョブ"/rjn0740/j1"    のステータスが正常終了であること
    かつ ジョブ"/rjn0740/rj1"   のステータスが正常終了であること
    かつ ジョブ"/rjn0740/rj2"   のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されていること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること


  # ./usecases/job/dsl/01_07_41_custom_conductors_in_child_jobnet.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # custom_conductor = lambda do |job|
  #   begin
  #     job.run
  #   rescue => e
  #     job.succeed
  #   end
  # end
  #
  # jobnet('rjn0741', :conductors => {:ruby_job => custom_conductor}) do
  #   ruby_job('rj1'){ raise RuntimeError }
  #   jobnet('rjn1', :conductors => {:ruby_job => Tengine::Job::RubyJob::DEFAULT_CONDUCTOR}) do
  #     ruby_job('rj2'){ raise RuntimeError }
  #   end
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_41
  シナリオ: jobnetにcustom_conductorsを定義したルートジョブネット内にruby_jobとjobが混在
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_41_custom_conductors_in_child_jobnet.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0741"を実行する
    かつ ジョブネット"rjn0741"が完了することを確認する

    ならば ジョブネット"/rjn0741"   のステータスが正常終了であること
    かつ ジョブ"/rjn0741/jr1"      のステータスが正常終了であること
    かつ ジョブネット"/rjn0741/rjn1"のステータスが正常終了であること
    かつ ジョブ"/rjn0741/rjn1/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0741/rj3"      のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること


  # ./usecases/job/dsl/01_07_42_custom_conductor.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # custom_conductor = lambda do |job|
  #   begin
  #     job.run
  #   rescue => e
  #     job.succeed
  #   end
  # end
  #
  # jobnet('rjn0742') do
  #   ruby_job('rj1', :conductor => {:ruby_job => custom_conductor}){ raise RuntimeError }
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   ruby_job('rj3'){ raise RuntimeError }
  #   ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  # end
  # ---------------------------
  #
  @01_07_42
  シナリオ: ruby_jobにcustom_conductorを定義したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_42_custom_conductor.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0742"を実行する
    かつ ジョブネット"rjn0742"が完了することを確認する

    ならば ジョブネット"/rjn0742"のステータスがエラー終了であること
    かつ ジョブ"/rjn0742/jr1"   のステータスが正常終了であること
    かつ ジョブ"/rjn0742/rj2"   のステータスが正常終了であること
    かつ ジョブ"/rjn0742/rj3"   のステータスがエラー終了であること
    かつ ジョブ"/rjn0742/rj4"   のステータスが初期化済であること

    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されていることを確認する

    もし ジョブ"/rjn0742/rj3"の"実行時PID"を"job_pid"と呼ぶ
    かつ ジョブ実行環境の"tengine_job_agent.yml.erb"に設定されたlog_dirの値を"log_dir"と呼ぶこととする
    かつ "#{logdir}/stdout-#{job_pid}.log"を"標準出力のファイルパス"と呼ぶこととする
    かつ "#{logdir}/stderr-#{job_pid}.log"を"標準エラー出力のファイルパス"と呼ぶこととする
    かつ ジョブ"/rjn0724/rj3"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  # ./usecases/job/dsl/01_07_43_custom_conductor_with_normal_job.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # custom_conductor = lambda do |job|
  #   begin
  #     job.run
  #   rescue => e
  #     job.succeed
  #   end
  # end
  #
  # jobnet('rjn0743', :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   job('j1', "$HOME/tengine_job_test.sh 0 job1")
  #   ruby_job('rj1', :conductor => {:ruby_job => custom_conductor}){ raise RuntimeError })
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  # end
  # ---------------------------
  #
  @01_07_43
  シナリオ: ruby_jobにcustom_conductorを定義したルートジョブネット内にruby_jobとjobが混在
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_43_custom_conductor_with_normal_job.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0743"を実行する
    かつ ジョブネット"rjn0743"が完了することを確認する

    ならば ジョブネット"/rjn0743"のステータスが正常終了であること
    かつ ジョブ"/rjn0743/j1"    のステータスが正常終了であること
    かつ ジョブ"/rjn0743/rj1"   のステータスが正常終了であること
    かつ ジョブ"/rjn0743/rj2"   のステータスが正常終了であること

    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"に出力されていること
    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること


  # ./usecases/job/dsl/01_07_44_custom_conductor_in_child_jobnet.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # custom_conductor = lambda do |job|
  #   begin
  #     job.run
  #   rescue => e
  #     job.succeed
  #   end
  # end
  #
  # jobnet('rjn0744') do
  #   ruby_job('rj1', :conductor => {:ruby_job => custom_conductor}){ raise RuntimeError }
  #   jobnet('rjn1') do
  #     ruby_job('rj2', :conductor => {:ruby_job => Tengine::Job::RubyJob::DEFAULT_CONDUCTOR}){ raise RuntimeError }
  #   end
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_44
  シナリオ: ruby_jobにcustom_conductorを定義したルートジョブネット内にruby_jobとjobが混在
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_44_custom_conductor_in_child_jobnet.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0744"を実行する
    かつ ジョブネット"rjn0744"が完了することを確認する

    ならば ジョブネット"/rjn0744"   のステータスがエラー終了であること
    かつ ジョブ"/rjn0744/rj1"      のステータスが正常終了であること
    かつ ジョブネット"/rjn0744/rjn1"のステータスがエラー終了であること
    かつ ジョブ"/rjn0744/rjn1/rj2" のステータスがエラー終了であること
    かつ ジョブ"/rjn0744/rj3"      のステータスが初期化済であること


  # ./usecases/job/dsl/01_07_45_explicit_job_succeed.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0745") do
  #   ruby_job('rj1'){ job.succeed(:message => "succeeded rj1 by explicitly coding"); STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  # end
  # ---------------------------
  #
  @01_07_45
  シナリオ: ruby_job内で明示的にjob_succeedを指定したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_45_explicit_job_succeed.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0745"を実行する
    かつ ジョブネット"rjn0745"が完了することを確認する

    ならば ジョブネット"/rjn0745"のステータスが正常終了であること
    かつ ジョブ"/rjn0745/jr1"   のステータスが正常終了であること
    かつ ジョブ"/rjn0745/rj2"   のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること

    かつ ジョブ"/rjn0745/rj3"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "メッセージ"に"succeeded rj1 by explicitly coding"が表示されていること



  # ./usecases/job/dsl/01_07_46_explicit_job_succeed_in_child_jobnet.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0746") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1") do
  #     ruby_job('rj2'){ job.succeed(:message => "succeeded rj2 by explicitly coding"); STDOUT.puts('rj2 executing...') }
  #   end
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  # end
  # ---------------------------
  #
  @01_07_46
  シナリオ: 子のジョブネット内のruby_job内で明示的にjob_succeedを指定したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_46_explicit_job_succeed_in_child_jobnet.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0746"を実行する
    かつ ジョブネット"rjn0746"が完了することを確認する

    ならば ジョブネット"/rjn0746"   のステータスが正常終了であること
    かつ ジョブ"/rjn0746/jr1"      のステータスが正常終了であること
    かつ ジョブネット"/rjn0746/rjn1"のステータスが正常終了であること
    かつ ジョブ"/rjn0746/rjn1/rj2" のステータスが正常終了であること
    かつ ジョブ"/rjn0746/rj3"      のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること

    かつ ジョブ"/rjn0746/rj2"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "メッセージ"に"succeeded rj2 by explicitly coding"が表示されていること


  # ./usecases/job/dsl/01_07_47_explicit_job_succeed_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0747") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet("rjn1") do
  #     ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   end
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #   finally do
  #     ruby_job('rj4'){ job.succeed(:message => "succeeded rj4 by explicitly coding"); STDOUT.puts('rj4 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_47
  シナリオ: finally内のruby_job内で明示的にjob_succeedを指定したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_47_explicit_job_succeed_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0747"を実行する
    かつ ジョブネット"rjn0747"が完了することを確認する

    ならば ジョブネット"/rjn0747"      のステータスが正常終了であること
    かつ ジョブ"/rjn0747/jr1"         のステータスが正常終了であること
    かつ ジョブネット"/rjn0747/rjn1"   のステータスが正常終了であること
    かつ ジョブ"/rjn0747/rjn1/rj2"    のステータスが正常終了であること
    かつ ジョブ"/rjn0747/rj3"         のステータスが正常終了であること
    かつ ジョブネット"/rjn0747/finally"のステータスが正常終了であること
    かつ ジョブ"/rjn0747/finally/rj4" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj3 executing...'の後であること

    かつ ジョブ"/rjn0747/rj4"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "メッセージ"に"succeeded rj4 by explicitly coding"が表示されていること


  # ./usecases/job/dsl/01_07_48_explicit_job_fail.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0748") do
  #   ruby_job('rj1'){ job.fail(:message => "failed rj1 by explicitly coding"); STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   finally do
  #     ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_48
  シナリオ: 明示的にjob_failを指定したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_48_explicit_job_fail.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0748"を実行する
    かつ ジョブネット"rjn0748"が完了することを確認する

    ならば ジョブネット"/rjn0748"      のステータスがエラー終了であること
    かつ ジョブ"/rjn0748/jr1"         のステータスがエラー終了であること
    かつ ジョブ"/rjn0748/rj2"         のステータスが初期化済であること
    かつ ジョブネット"/rjn0748/finally"のステータスが正常終了であること
    かつ ジョブ"/rjn0748/finally/rj3" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj1 executing...'の後であること

    かつ ジョブ"/rjn0748/rj1"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "メッセージ"に"failed rj1 by explicitly coding"が表示されていること


  # ./usecases/job/dsl/01_07_49_explicit_job_fail_in_child_jobnet.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0749") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet('rjn1') do
  #     ruby_job('rj2'){ job.fail(:message => "failed rj2 by explicitly coding"); STDOUT.puts('rj2 executing...') }
  #   end
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #   finally do
  #     ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_49
  シナリオ: 子のジョブネット内のruby_jobで明示的にjob_failを指定したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_49_explicit_job_fail_in_child_jobnet.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0749"を実行する
    かつ ジョブネット"rjn0749"が完了することを確認する

    ならば ジョブネット"/rjn0749"      のステータスがエラー終了であること
    かつ ジョブ"/rjn0749/jr1"         のステータスが正常終了であること
    かつ ジョブネット"/rjn0749/rjn1/   のステータスがエラー終了であること
    かつ ジョブ"/rjn0749/rjn1/rj2"    のステータスがエラー終了であること
    かつ ジョブ"/rjn0749/jr3"         のステータスが初期化済であること
    かつ ジョブネット"/rjn0749/finally"のステータスが正常終了であること
    かつ ジョブ"/rjn0749/finally/rj4" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj2 executing...'の後であること

    かつ ジョブ"/rjn0749/rj2"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "メッセージ"に"failed rj2 by explicitly coding"が表示されていること


  # ./usecases/job/dsl/01_07_50_explicit_job_fail_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0750") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   finally do
  #     ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #     ruby_job('rj4'){ job.fail(:message => "succeeded rj4 by explicitly coding"); STDOUT.puts('rj4 executing...') }
  #     ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_50
  シナリオ: finally内のruby_jobで明示的にjob_failを指定したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_50_explicit_job_fail_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0750"を実行する
    かつ ジョブネット"rjn0750"が完了することを確認する

    ならば ジョブネット"/rjn0750"      のステータスがエラー終了であること
    かつ ジョブ"/rjn0750/jr1"         のステータスが正常終了であること
    かつ ジョブ"/rjn0750/jr2"         のステータスが正常終了であること
    かつ ジョブネット"/rjn0750/finally"のステータスが正常終了であること
    かつ ジョブ"/rjn0750/finally/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0750/finally/rj4" のステータスがエラー終了であること
    かつ ジョブ"/rjn0750/finally/rj5" のステータスが初期化済であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj3 executing...'の後であること

    かつ ジョブ"/rjn0750/rj4"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "メッセージ"に"failed rj4 by explicitly coding"が表示されていること


  # ./usecases/job/dsl/01_07_51_explicit_job_fail_with_exception.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0751") do
  #   ruby_job('rj1'){ job.fail(:exception => RuntimeError.new("failed rj1 by explicitly coding")); STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   finally do
  #     ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_51
  シナリオ: job_failに例外クラスを指定したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_51_explicit_job_fail_with_exception.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0751"を実行する
    かつ ジョブネット"rjn0751"が完了することを確認する

    ならば ジョブネット"/rjn0751"      のステータスがエラー終了であること
    かつ ジョブ"/rjn0751/jr1"         のステータスがエラー終了であること
    かつ ジョブ"/rjn0751/jr2"         のステータスが初期化済であること
    かつ ジョブネット"/rjn0751/finally"のステータスが正常終了であること
    かつ ジョブ"/rjn0751/finally/rj3" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj1 executing...'の後であること

    かつ ジョブ"/rjn0751/rj1"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "メッセージ"に"RuntimeError"および"failed rj1 by explicitly coding"が表示されていること


  # ./usecases/job/dsl/01_07_52_explicit_job_fail_with_exception_in_child_jobnet.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0752") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   jobnet('rjn1') do
  #     ruby_job('rj2'){ job.fail(:exception => RuntimeError.new("failed rj2 by explicitly coding")); STDOUT.puts('rj2 executing...') }
  #   end
  #   ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #   finally do
  #     ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_52
  シナリオ: 子のジョブネット内のjob_failに例外クラスを指定したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_52_explicit_job_fail_with_exception_in_child_jobnet.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0752"を実行する
    かつ ジョブネット"rjn0752"が完了することを確認する

    ならば ジョブネット"/rjn0752"      のステータスがエラー終了であること
    かつ ジョブ"/rjn0752/jr1"         のステータスが正常終了であること
    かつ ジョブネット"/rjn0752/rjn1"   のステータスがエラー終了であること
    かつ ジョブ"/rjn0752/rjn1/jr2"    のステータスがエラー終了であること
    かつ ジョブ"/rjn0752/rj3"         のステータスが初期化済であること
    かつ ジョブネット"/rjn0752/finally"のステータスが正常終了であること
    かつ ジョブ"/rjn0752/finally/rj4" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj2 executing...'の後であること

    かつ ジョブ"/rjn0752/rj2"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "メッセージ"に"RuntimeError"および"failed rj2 by explicitly coding"が表示されていること


  # ./usecases/job/dsl/01_07_53_explicit_job_fail_with_exception_in_finally.rb
  # ---------------------------
  # -*- coding: utf-8 -*-
  # require 'tengine_job'
  #
  # jobnet("rjn0753") do
  #   ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  #   ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  #   finally do
  #     ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  #     ruby_job('rj4'){ job.fail(:exception => RuntimeError.new("failed rj4 by explicitly coding")); STDOUT.puts('rj4 executing...') }
  #     ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
  #   end
  # end
  # ---------------------------
  #
  @01_07_53
  シナリオ: finally内のjob_failに例外クラスを指定したルートジョブネット
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_07_53_explicit_job_fail_with_exception_in_finally.rb -f ./features/config/tengined_debug.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"rjn0753"を実行する
    かつ ジョブネット"rjn0753"が完了することを確認する

    ならば ジョブネット"/rjn0753"      のステータスがエラー終了であること
    かつ ジョブ"/rjn0753/jr1"         のステータスが正常終了であること
    かつ ジョブ"/rjn0753/jr2"         のステータスが正常終了であること
    かつ ジョブネット"/rjn0753/finally"のステータスが正常終了であること
    かつ ジョブ"/rjn0753/finally/rj3" のステータスが正常終了であること
    かつ ジョブ"/rjn0753/finally/rj4" のステータスが正常終了であること
    かつ ジョブ"/rjn0753/finally/rj5" のステータスが正常終了であること

    かつ "Tengineコアプロセス"の標準出力に'rj1 executing...'と出力されていることを確認する
    かつ "Tengineコアプロセス"の標準出力に'rj2 executing...'と出力されており、'rj1 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj3 executing...'と出力されており、'rj2 executing...'の後であること
    かつ "Tengineコアプロセス"の標準出力に'rj4 executing...'と出力されており、'rj3 executing...'の後であること

    かつ ジョブ"/rjn0752/rj4"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "メッセージ"に"RuntimeError"および"failed rj4 by explicitly coding"が表示されていること


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
  @01_07_54
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

