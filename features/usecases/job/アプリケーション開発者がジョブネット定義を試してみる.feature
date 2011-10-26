
#language:ja
機能: アプリケーション開発者がジョブネット定義を試してみる

  背景:
     前提 "DBプロセス"が起動している
     かつ "キュープロセス"が起動している
     かつ "Tengineコンソールプロセス"が起動している
     かつ 仮想サーバがインスタンス識別子:"test_server1"、プロバイダID:"xxxx", IP:"x.x.x.x"で登録されていること
     かつ 認証情報が名称:"test_credential1"、認証種別:"SSHパスワード認証"、ユーザ名:"xxx"、パスワード:"xxx"で登録されている

  # ./features/usecases/job/dsl/1001_one_job_in_jobnet.rb
  # -------------------
  # require 'tengine_job'
  #
  # jobnet("jobnet1001", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "echo 'job1'")
  # end
  # -------------------
  #
  シナリオ: [正常系]1001_1つのジョブが含まれるジョブネット_を試してみる
    前提 "Tengineコアプロセス"がロードパスに"./usecases/job/dsl/1001_one_job_in_jobnet.rb"が指定され起動している
    # shell : tengined -k start -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb

    もし ジョブネット"jobnet1001"を実行する
    # rails c : execution = Tengine::Job::Execution.first を実行し、execution_id を確認する
    # rails c : execution.root_job_net  を実行し、root_jobnet_id を確認する
    # shell   : tengine_fire start.execution.job.tengine  properties:{ "execution_id" : #{execution_id}, "root_jobnet_id" : #{root_jobnet_id}, "target_jobnet_id" : #{root_jobnet_id} }

    かつ ジョブが完了することを確認する
    # イベント一覧画面で種別名に"success.execution.job.tengine"を指定し検索し、終了を確認する

    ならば ジョブネット"jobnet1001" のステータスが正常であること
    # イベント一覧画面 : "success.execution.job.tengine"のpropertieys の execution_id を確認
    # rails c : execution = Tengine::Job::Execution.find("execution_id")
    # rails c : root_jobnet = execution.root_jobnet   # ジョブネット"jobnet1001"
    # rails c : root_jobnet.phase_name                # "success" であることを確認

    かつ ジョブ"job1" のステータスが正常であること
    # rails c : job1 = root_jobnet.children[0].destination     # ジョブ "job1"
    # rails c : job1.phase_name                                # "success" であることを確認

    かつ 仮想サーバ"test_server1"でジョブ"job1"の標準出力のログに"job1"と出力されていること
    # rails c : job1.executing_pid でPID を確認する
    # shell : cat ./log/stdout-PID.log 



